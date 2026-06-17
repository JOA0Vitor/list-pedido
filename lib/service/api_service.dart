import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:pedidosdp/models/pedidos.dart';

class ApiService {
  static const String _baseUrl = 'https://187.85.164.196/api/comercial/v10';

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

  void dispose() {
    _client.close();
  }
}
