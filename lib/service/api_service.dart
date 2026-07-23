import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:pedidosdp/models/clientes_model.dart';
import 'package:pedidosdp/models/corte_model.dart';
import 'package:pedidosdp/models/pedido_recentes_model.dart';
import 'package:pedidosdp/models/pedidos_model.dart';
import 'package:pedidosdp/models/romaneio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://187.85.164.196/api/comercial/v10';
  static const String _baseUrlClientes =
      'https://187.85.164.196/api/cadastrosgerais/v10';
  static const String _baseUrlRomaneio = 'http://192.168.0.36:8000';
  final int empresa = 2;

  final String apiToken;
  late final http.Client _client;

  ApiService({required this.apiToken, String baseUrl = _baseUrl}) {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    _client = IOClient(ioClient);
  }

  static String getUrl(String modulo, String servico) {
    return '$_baseUrl/$modulo/$servico';
  }

  //usar esse Endpoint - /pedidos/recentes - para pegar os pedidos mais recentes

  Future<PaginatedResponsePedido<PedidoModel>> getListPedidos(
    int empresa,
    String dataDigitacaoInicio,
    String dataDigitacaoFim,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final chaveCache =
        'pedidos_cache_${empresa}_${dataDigitacaoInicio}_$dataDigitacaoFim';

    final uri = Uri.parse('$_baseUrl/pedidoVenda/').replace(
      queryParameters: {
        // 'empresa': empresa.toString(),
        'dataDigitacaoInicio': dataDigitacaoInicio,
        'dataDigitacaoFim': dataDigitacaoFim,
      },
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'accept': 'application/json',
              'empresa': empresa.toString(),
              'Authorization': apiToken,
              'dataDigitacaoInicio': dataDigitacaoInicio,
              'dataDigitacaoFim': dataDigitacaoFim,
            },
          )
          .timeout(const Duration(seconds: 10));

      print('STATUS PEDIDOS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final resultado = PaginatedResponsePedido.fromJson(
          jsonDecode(response.body),
          PedidoModel.fromJson,
        );

        if (resultado.data.isNotEmpty) {
          await prefs.setString(chaveCache, response.body);
        }
        return resultado;
      }

      return _lerCacheOuFalhar(
        prefs,
        chaveCache,
        'Erro ${response.statusCode}: ${response.body}',
      );
    } on TimeoutException {
      return _lerCacheOuFalhar(
        prefs,
        chaveCache,
        'Servidor não respondeu a tempo.',
      );
    } on SocketException {
      return _lerCacheOuFalhar(
        prefs,
        chaveCache,
        'Sem conexão com a internet.',
      );
    } catch (e) {
      return _lerCacheOuFalhar(prefs, chaveCache, 'Erro inesperado: $e');
    }
  }

  PaginatedResponsePedido<PedidoModel> _lerCacheOuFalhar(
    SharedPreferences prefs,
    String chaveCache,
    String mensagemErro,
  ) {
    final salvo = prefs.getString(chaveCache);
    if (salvo != null) {
      print('[cache local] usando dado salvo por causa de: $mensagemErro');
      return PaginatedResponsePedido.fromJson(
        jsonDecode(salvo),
        PedidoModel.fromJson,
      );
    }
    throw Exception(mensagemErro);
  }

  Future<PaginatedResponseClientes<ClientesModel>> getClientes(
    int empresa, {
    String? continuationToken,
    // int paginacao = 1165,// Preciso achar uma solução para isso, ta demorando muito para pegar os dados
    int paginacao = 165,
    int situacao = 1,
  }) async {
    final uri = Uri.parse('$_baseUrlClientes/cliente').replace(
      queryParameters: {
        'situacao': situacao.toString(),
        'paginacao': paginacao.toString(),
        if (continuationToken != null && continuationToken.isNotEmpty)
          'continuationToken': continuationToken,
      },
    );

    debugPrint('Cliente uri: $uri');
    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'accept': 'application/json',
              'empresa': empresa.toString(),
              'Authorization': 'Bearer $apiToken',
              // 'situacao': situacao.toString(),
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Testando conexão com $_baseUrl...');
      print('STATUS CLIENTES: ${response.statusCode}');
      print('BODY CLIENTES: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PaginatedResponseClientes.fromJson(
          jsonData,
          ClientesModel.fromJson,
        );
      } else {
        throw Exception('Erro API: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Servidor não respondeu a tempo. Verifique sua conexão.');
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
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
          .timeout(const Duration(seconds: 10));

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

  // Future<void> finalizarPedidoT(
  //   String codPedido, {
  //   List<Map<String, dynamic>>? itens,
  // }) async {
  //   final response = await http.post(
  //     Uri.parse('$_baseUrlRomaneio/pedidos/$codPedido/finalizar'),
  //     headers: {'X-API-Key': apiToken, 'Content-Type': 'application/json'},
  //     body: itens != null ? jsonEncode({'itens': itens}) : null,
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Falha ao finalizar pedido: ${response.body}');
  //   }
  // }

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

  void dispose() {
    _client.close();
  }
}
