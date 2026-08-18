import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:pedidosdp/models/romaneio_model.dart';

class ApiService {
  // static const String _baseUrl = 'https://187.85.164.196/api/comercial/v10';
  static const String _baseUrlRomaneio = 'http://192.168.0.36:8000';
  final int empresa = 2;

  final String apiToken;
  late final http.Client _client;

  ApiService({required this.apiToken, String baseUrl = _baseUrlRomaneio}) {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    _client = IOClient(ioClient);
  }


  Future<PaginatedResponseRomaneio<RomaneioModel>> getRomaneio(
    int empresa,
    String codPedido,
    String token,
  ) async {
    final uri = Uri.parse(
      '$_baseUrlRomaneio/pedidos/$codPedido/itens-detalhados',
    ).replace(queryParameters: {'cod_empresa': empresa.toString()});

    debugPrint('Romaneio uri: $uri');

    try {
      final response = await _client
          .get(uri, headers: {'accept': 'application/json', 'x-api-key': token})
          .timeout(const Duration(minutes: 2));

      print('STATUS ROMANEIO: ${response.statusCode}');
      print('BODY ROMANEIO: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PaginatedResponseRomaneio.fromJson(
          jsonData,
          RomaneioModel.fromJson,
        );
      } else {
        throw Exception(
          'Erro tabela de preços: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException {
      throw Exception('Servidor não respondeu a tempo. Verifique sua conexão.');
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<void> finalizarPedidoT(
    String? operador,
    String codPedido, {
    List<Map<String, dynamic>>? itens,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrlRomaneio/pedidos/$codPedido/finalizar').replace(
        queryParameters: {
          if (operador != null && operador.isNotEmpty) 'operador': operador,
        },
      ),
      headers: {'X-API-Key': apiToken, 'Content-Type': 'application/json'},
      body: jsonEncode({'itens': itens ?? []}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao finalizar pedido: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<PaginatedResponseCorte<CorteModel>> getFilaCorte() async {
    final uri = Uri.parse('$_baseUrlRomaneio/corte/fila');

    final response = await _client
        .get(
          uri,
          headers: {'accept': 'application/json', 'x-api-key': apiToken},
        )
        .timeout(const Duration(seconds: 10));

    print('STATUS FILA CORTE: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return PaginatedResponseCorte.fromJson({
        'codPedido': '',
        'itens': jsonData['itens'],
      }, CorteModel.fromJson);
    }

    throw Exception(
      'Erro ao buscar fila de corte: ${response.statusCode} - ${response.body}',
    );
  }

  Future<RespostaPedidosRecentes> getPedidosRecentes(
    int codEmpresa, {
    int limite = 50,
  }) async {
    final uri = Uri.parse('$_baseUrlRomaneio/pedidos/recentes').replace(
      queryParameters: {
        'cod_empresa': codEmpresa.toString(),
        'limite': limite.toString(),
      },
    );

    final response = await _client.get(uri, headers: {'x-api-key': apiToken});

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar pedidos: ${response.statusCode}');
    }

    return RespostaPedidosRecentes.fromJson(jsonDecode(response.body));
  }

  Future<List<String>> buscarSelecaoRomaneio(String codPedido) async {
    final uri = Uri.parse('$_baseUrlRomaneio/romaneio/$codPedido/selecao');
    final response = await _client.get(uri, headers: {'x-api-key': apiToken});
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar seleção: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['itens'] as List).cast<String>();
  }

  Future<void> salvarSelecaoRomaneio(
    String codPedido,
    List<String> itens,
  ) async {
    final uri = Uri.parse('$_baseUrlRomaneio/romaneio/$codPedido/selecao');
    final response = await _client.post(
      uri,
      headers: {'x-api-key': apiToken, 'Content-Type': 'application/json'},
      body: jsonEncode({'itens': itens}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao salvar seleção: ${response.statusCode}');
    }
  }

  Future<List<String>> buscarGavetas(String chave) async {
    final uri = Uri.parse('$_baseUrlRomaneio/localizacao/$chave');
    final response = await _client.get(uri, headers: {'x-api-key': apiToken});
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar localização: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['gavetas'] as List).cast<String>();
  }

  Future<List<String>> adicionarGaveta(String chave, String gaveta) async {
    final uri = Uri.parse('$_baseUrlRomaneio/localizacao/$chave/gaveta');
    final response = await _client.post(
      uri,
      headers: {'x-api-key': apiToken, 'Content-Type': 'application/json'},
      body: jsonEncode({'gaveta': gaveta}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao adicionar gaveta: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['gavetas'] as List).cast<String>();
  }

  // Future<List<String>> removerGaveta(String chave, String gaveta) async {
  //   final uri = Uri.parse(
  //     '$_baseUrlRomaneio/localizacao/$chave/gaveta/$gaveta',
  //   );
  //   final response = await _client.delete(
  //     uri,
  //     headers: {'x-api-key': apiToken},
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('Erro ao remover gaveta: ${response.statusCode}');
  //   }
  //   final json = jsonDecode(response.body) as Map<String, dynamic>;
  //   return (json['gavetas'] as List).cast<String>();
  // }

  Future<Map<String, dynamic>> verificarStatusRomaneio(String codPedido) async {
    final uri = Uri.parse('$_baseUrlRomaneio/romaneio/$codPedido/status');
    final response = await _client.get(uri, headers: {'x-api-key': apiToken});
    if (response.statusCode != 200) {
      throw Exception('Erro ao verificar status do pedido');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String> entrarNoRomaneio(
    String codPedido,
    String operador,
    String dispositivoId,
  ) async {
    final uri = Uri.parse('$_baseUrlRomaneio/romaneio/$codPedido/entrar');
    final response = await _client.post(
      uri,
      headers: {'x-api-key': apiToken, 'Content-Type': 'application/json'},
      body: jsonEncode({'operador': operador, 'dispositivoId': dispositivoId}),
    );

    if (response.statusCode == 409) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw PedidoEmUsoException(body['detail'] as String? ?? 'Pedido em uso');
    }
    if (response.statusCode != 200) {
      throw Exception('Erro ao entrar no romaneio: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['token'] as String;
  }

  Future<bool> heartbeatRomaneio(String codPedido, String token) async {
    final uri = Uri.parse('$_baseUrlRomaneio/romaneio/$codPedido/heartbeat');
    final response = await _client.post(
      uri,
      headers: {'x-api-key': apiToken, 'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );
    return response.statusCode == 200;
  }

  Future<void> sairDoRomaneio(String codPedido, String token) async {
    final uri = Uri.parse(
      '$_baseUrlRomaneio/romaneio/$codPedido/entrar',
    ).replace(queryParameters: {'token': token});
    await _client.delete(uri, headers: {'x-api-key': apiToken});
  }

  void dispose() {
    _client.close();
  }
}

class PedidoEmUsoException implements Exception {
  final String mensagem;
  PedidoEmUsoException(this.mensagem);
  @override
  String toString() => mensagem;
}
