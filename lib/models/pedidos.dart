import 'package:flutter/material.dart';

class PaginatedResponsePedido<T> {
  final String continuationToken;
  final List<T> data;

  PaginatedResponsePedido({
    required this.continuationToken,
    required this.data,
  });

  factory PaginatedResponsePedido.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    return PaginatedResponsePedido(
      continuationToken: json['continuationToken'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonItem(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PedidoModel {

  ///////////////////////
  final int codEtapa;
  final int codCliente;
  final String codPedido;
  final int codRepresentante;
  final String dataEmissao;

  const PedidoModel({
  
    ///////////////////
    required this.codEtapa,
    required this.codCliente,
    required this.codPedido,
    required this.codRepresentante,
    required this.dataEmissao,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    final codEtapa = json['codEtapa'] as int? ?? 0;

    return PedidoModel(
    // exemplo: ajuste pra sua regra real
      codEtapa: codEtapa,
      codCliente: json['codCliente'] as int? ?? 0,
      codPedido: json['codPedido']?.toString() ?? '',
      codRepresentante: json['codRepresentante'] as int? ?? 0,
      dataEmissao: json['dataEmissao'] as String? ?? '',
    );
  }
  static Color corPorEtapa(int codEtapa) {
    switch (codEtapa) {
      case 1:
        return const Color(0xFF9E9E9E);
      case 4:
        return const Color(0xFFFE8D00);
      case 5:
        return const Color(0xFF4e2da2);
      case 9:
        return const Color(0xFF3d7d24);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Map<String, dynamic> toJson() {
    return {
    
      'codEtapa': codEtapa,
      'codCliente': codCliente,
      'codPedido': codPedido,
      'codRepresentante': codRepresentante,
      'dataEmissao': dataEmissao,
    };
  }
}
