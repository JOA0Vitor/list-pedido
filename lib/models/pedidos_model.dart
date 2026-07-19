// import 'package:flutter/material.dart';

// class PaginatedResponsePedido<T> {
//   final String continuationToken;
//   final List<T> data;

//   PaginatedResponsePedido({
//     required this.continuationToken,
//     required this.data,
//   });

//   factory PaginatedResponsePedido.fromJson(
//     Map<String, dynamic> json,
//     T Function(Map<String, dynamic>) fromJsonItem,
//   ) {
//     return PaginatedResponsePedido(
//       continuationToken: json['continuationToken'] ?? '',
//       data: (json['data'] as List<dynamic>)
//           .map((item) => fromJsonItem(item as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

// class PedidoModel {

//   ///////////////////////
//   static const int etapaRomaneioConcluidoLocal = 10;
//   final int codEtapa;
//   final int codCliente;
//   final String codPedido;
//   final int codRepresentante;
//   final String dataEmissao;

//   const PedidoModel({
  
//     ///////////////////
//     required this.codEtapa,
//     required this.codCliente,
//     required this.codPedido,
//     required this.codRepresentante,
//     required this.dataEmissao,
//   });

//   factory PedidoModel.fromJson(Map<String, dynamic> json) {
//     final codEtapa = json['codEtapa'] as int? ?? 0;

//     return PedidoModel(
//     // exemplo: ajuste pra sua regra real
//       codEtapa: codEtapa,
//       codCliente: json['codCliente'] as int? ?? 0,
//       codPedido: json['codPedido']?.toString() ?? '',
//       codRepresentante: json['codRepresentante'] as int? ?? 0,
//       dataEmissao: json['dataEmissao'] as String? ?? '',
//     );
//   }
//   static Color corPorEtapa(int codEtapa) {
//     switch (codEtapa) {
//       case 1:
//         return const Color(0xFF9E9E9E);
//       case 4:
//         return const Color(0xFFFE8D00);
//       case 5:
//         return const Color(0xFF4e2da2);
//       case 9:
//         return const Color(0xFF3d7d24);
//         case etapaRomaneioConcluidoLocal:
//         return const Color(0xFF0043AC);
//       default:
//         return const Color(0xFF9E9E9E);
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
    
//       'codEtapa': codEtapa,
//       'codCliente': codCliente,
//       'codPedido': codPedido,
//       'codRepresentante': codRepresentante,
//       'dataEmissao': dataEmissao,
//     };
//   }
// }
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
  // Etapa local, que nunca vem da API — só existe no app depois que o
  // usuário finaliza o romaneio na tela. Deixo como constante nomeada
  // pra não espalhar o número "10" mágico pelo código.
  static const int etapaRomaneioConcluidoLocal = 10;

  final int codEtapa;
  final int codCliente;
  final String codPedido;
  final int codRepresentante;
  final String dataEmissao;

  const PedidoModel({
    required this.codEtapa,
    required this.codCliente,
    required this.codPedido,
    required this.codRepresentante,
    required this.dataEmissao,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    final codEtapa = json['codEtapa'] as int? ?? 0;

    return PedidoModel(
      codEtapa: codEtapa,
      codCliente: json['codCliente'] as int? ?? 0,
      codPedido: json['codPedido']?.toString() ?? '',
      codRepresentante: json['codRepresentante'] as int? ?? 0,
      dataEmissao: json['dataEmissao'] as String? ?? '',
    );
  }

  PedidoModel copyWith({
    int? codEtapa,
    int? codCliente,
    String? codPedido,
    int? codRepresentante,
    String? dataEmissao,
  }) {
    return PedidoModel(
      codEtapa: codEtapa ?? this.codEtapa,
      codCliente: codCliente ?? this.codCliente,
      codPedido: codPedido ?? this.codPedido,
      codRepresentante: codRepresentante ?? this.codRepresentante,
      dataEmissao: dataEmissao ?? this.dataEmissao,
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
      case etapaRomaneioConcluidoLocal:
        return const Color(0xFF0043AC); // mesmo azul do botão Finalizar
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