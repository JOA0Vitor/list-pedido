import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:pedidosdp/models/clientes_model.dart';
import 'package:pedidosdp/models/pedidos_model.dart';
import 'package:pedidosdp/models/romaneio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://187.85.164.196/api/comercial/v10';
  static const String _baseUrlClientes =
      'https://187.85.164.196/api/cadastrosgerais/v10';
  static const String _baseUrlRomaneio = 'http://192.168.0.36:8000';
  static const String _baseUrlRomaneioCasa = 'http://192.168.1.103:8000';
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

  // Future<PaginatedResponsePedido<PedidoModel>> getListPedidos(
  //   int empresa,
  //   String dataDigitacaoInicio,
  //   String dataDigitacaoFim,
  // ) async {
  //   final uri = Uri.parse('$_baseUrl/pedidoVenda').replace(
  //     queryParameters: {
  //       'dataDigitacaoInicio': dataDigitacaoInicio,
  //       'dataDigitacaoFim': dataDigitacaoFim,
  //     },
  //   );

  //   print('Empresa uri: $uri');
  //   try {
  //     final response = await _client
  //         .get(
  //           uri,
  //           headers: {
  //             'accept': 'application/json',
  //             'empresa': empresa.toString(),
  //             'Authorization': apiToken,
  //             'dataDigitacaoInicio': dataDigitacaoInicio,
  //             'dataDigitacaoFim': dataDigitacaoFim,
  //           },
  //         )
  //         .timeout(const Duration(seconds: 10));
  //     print('STATUS PEDIDOS: ${response.statusCode}');
  //     print('BODY PEDIDOS: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       return PaginatedResponsePedido.fromJson(jsonData, PedidoModel.fromJson);
  //     } else {
  //       throw Exception(
  //         'Erro tabela de preços: ${response.statusCode} - ${response.body}',
  //       );
  //     }
  //   } on TimeoutException {
  //     throw Exception('Servidor não respondeu a tempo. Verifique sua conexão.');
  //   } on SocketException {
  //     throw Exception('Sem conexão com a internet.');
  //   } catch (e) {
  //     throw Exception('Erro inesperado: $e');
  //   }
  // }

  Future<PaginatedResponsePedido<PedidoModel>> getListPedidos(
    int empresa,
    String dataDigitacaoInicio,
    String dataDigitacaoFim,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final chaveCache =
        'pedidos_cache_${empresa}_${dataDigitacaoInicio}_$dataDigitacaoFim';

    // Agora aponta pro SEU backend (que já cacheia server-side), não mais direto na API externa
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

        // só grava cache local se veio algo útil
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

  Future<void> finalizarPedido(String codPedido) async {
    final uri = Uri.parse('$_baseUrlRomaneioCasa/pedidos/$codPedido/finalizar');
    print('Finalizando pedido uri: $uri');
    final response = await _client
        .post(
          uri,
          headers: {'accept': 'application/json', 'x-api-key': apiToken},
        )
        .timeout(const Duration(seconds: 10));

    print('STATUS FINALIZAR: ${response.statusCode}');
    print('BODY FINALIZAR: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao finalizar pedido: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Future<Map<String, dynamic>> getRomaneioTextil({
  //   List<String>? pedidos,
  //   String? dataEmissaoInicio,
  //   String? dataEmissaoFim,
  //   List<int>? situacoes,
  //   String? continuationToken,
  //   int numeroPedidos = 371,
  // }) async {
  //   final queryParams = <String, String>{};

  //   if (continuationToken != null && continuationToken.isNotEmpty) {
  //     queryParams['continuationToken'] = continuationToken;
  //   }
  //   if (dataEmissaoInicio != null && dataEmissaoInicio.isNotEmpty) {
  //     queryParams['dataEmissaoInicio'] = dataEmissaoInicio;
  //   }
  //   if (dataEmissaoFim != null && dataEmissaoFim.isNotEmpty) {
  //     queryParams['dataEmissaoFim'] = dataEmissaoFim;
  //   }
  //   if (pedidos != null && pedidos.isNotEmpty) {
  //     for (final p in pedidos) {
  //       queryParams.putIfAbsent('pedido', () => p);
  //     }
  //   }
  //   if (situacoes != null && situacoes.isNotEmpty) {
  //     for (final s in situacoes) {
  //       queryParams.putIfAbsent('situacao', () => s.toString());
  //     }
  //   }

  //   final uri = Uri.parse(
  //     '$_baseUrl/romaneioTextil',
  //   ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

  //   final responseRomaneio = await _client.get(
  //     Uri.parse('$_baseUrlRomaneio/$numeroPedidos/itens?cod_empresa=$empresa'),
  //     headers: {'X-API-Key': 'sua-chave-aqui'},
  //   );

  //   debugPrint('Romaneio uri: $uri');

  //   final response = await _client.get(
  //     uri,
  //     headers: {
  //       'accept': 'application/json',
  //       'empresa': empresa.toString(),
  //       'Authorization': apiToken,
  //     },
  //   );

  //   debugPrint('STATUS: ${response.statusCode}');
  //   debugPrint('BODY: ${response.body}');

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as Map<String, dynamic>;
  //   }

  //   throw Exception('Erro romaneio: ${response.statusCode} - ${response.body}');
  // }

  void dispose() {
    _client.close();
  }
}
