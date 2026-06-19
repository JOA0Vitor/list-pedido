import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:pedidosdp/models/clientes_model.dart';
import 'package:pedidosdp/models/pedidos_model.dart';

class ApiService {
  static const String _baseUrl = 'https://187.85.164.196/api/comercial/v10';
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

  Future<PaginatedResponsePedido<PedidoModel>> getListPedidos(
    int empresa,
    String dataDigitacaoInicio,
    String dataDigitacaoFim,
  ) async {
    final uri = Uri.parse('$_baseUrl/pedidoVenda').replace(
      queryParameters: {
        'dataDigitacaoInicio': dataDigitacaoInicio,
        'dataDigitacaoFim': dataDigitacaoFim,
      },
    );

    print('Empresa uri: $uri');

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
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PaginatedResponsePedido.fromJson(jsonData, PedidoModel.fromJson);
    } else {
      throw Exception(
        'Erro tabela de preços: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<PaginatedResponseClientes<ClientesModel>> getClientes(
    int empresa, {
    String? continuationToken,
    int paginacao = 1200,
  }) async {
    final uri = Uri.parse('$_baseUrl/cliente').replace(
      queryParameters: {
        'paginacao': paginacao.toString(),
        if (continuationToken != null && continuationToken.isNotEmpty)
          'continuationToken': continuationToken,
      },
    );

    final response = await _client
        .get(
          uri,
          headers: {
            'accept': 'application/json',
            'empresa': empresa.toString(),
            'Authorization': apiToken,
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return PaginatedResponseClientes.fromJson(
        jsonData,
        ClientesModel.fromJson,
      );
    } else {
      throw Exception('Erro: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getRomaneioTextil({
    List<String>? pedidos,
    String? dataEmissaoInicio,
    String? dataEmissaoFim,
    List<int>? situacoes,
    String? continuationToken,
  }) async {
    final queryParams = <String, String>{};

    if (continuationToken != null && continuationToken.isNotEmpty) {
      queryParams['continuationToken'] = continuationToken;
    }
    if (dataEmissaoInicio != null && dataEmissaoInicio.isNotEmpty) {
      queryParams['dataEmissaoInicio'] = dataEmissaoInicio;
    }
    if (dataEmissaoFim != null && dataEmissaoFim.isNotEmpty) {
      queryParams['dataEmissaoFim'] = dataEmissaoFim;
    }
    if (pedidos != null && pedidos.isNotEmpty) {
      for (final p in pedidos) {
        queryParams.putIfAbsent('pedido', () => p);
      }
    }
    if (situacoes != null && situacoes.isNotEmpty) {
      for (final s in situacoes) {
        queryParams.putIfAbsent('situacao', () => s.toString());
      }
    }

    final uri = Uri.parse(
      '$_baseUrl/romaneioTextil',
    ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    debugPrint('Romaneio uri: $uri');

    final response = await _client.get(
      uri,
      headers: {
        'accept': 'application/json',
        'empresa': empresa.toString(),
        'Authorization': apiToken,
      },
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Erro romaneio: ${response.statusCode} - ${response.body}');
  }


  void dispose() {
    _client.close();
  }
}
