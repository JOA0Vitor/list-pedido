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
  final int numero;
  final String dataHora;
  final String cliente;

  final Color etapaColor;
  final bool concluido;
  ///////////////////////
  final int codEtapa;
  final int codCliente;
  final String codPedido;
  final int codRepresentante;
  final String dataEmissao;


  const PedidoModel({
    required this.numero,
    required this.dataHora,
    required this.cliente,
    this.concluido = false,
    required this.etapaColor,
    ///////////////////
    required this.codEtapa,
    required this.codCliente,
    required this.codPedido,
    required this.codRepresentante,
    required this.dataEmissao,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      numero: json['numero'] as int,
      dataHora: json['dataHora'] as String,
      cliente: json['cliente'] as String,
      etapaColor: Color(json['etapaColor'] as int),
      concluido: json['concluido'] as bool,
      codEtapa: json['codEtapa'] as int,
      codCliente: json['codCliente'] as int,
      codPedido: json['codPedido'] as String,
      codRepresentante: json['codRepresentante'] as int,
      dataEmissao: json['dataEmissao'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'dataHora': dataHora,
      'cliente': cliente,
      'etapaColor': etapaColor,
      'concluido': concluido,
      'codEtapa': codEtapa,
      'codCliente': codCliente,
      'codPedido': codPedido,
      'codRepresentante': codRepresentante,
      'dataEmissao': dataEmissao,
    };
  }
}
