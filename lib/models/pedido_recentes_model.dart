import 'dart:ui';

class RespostaPedidosRecentes {
  final List<PedidoRecenteModel> pedidos;

  const RespostaPedidosRecentes({required this.pedidos});

  factory RespostaPedidosRecentes.fromJson(Map<String, dynamic> json) {
    return RespostaPedidosRecentes(
      pedidos: (json['pedidos'] as List<dynamic>)
          .map(
            (item) => PedidoRecenteModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PedidoRecenteModel {
  static const String situacaoConcluidoLocal = 'Concluído (local)';
  static const int etapaRomaneioConcluidoLocal = 10;

  final String codPedido;
  final String dataDigitacao;
  final int codEmpresa;
  final String? razaoEmpresa;
  final String nomeCliente;
  final String nomeRepresentante;
  final String situacao;
  final double valorTotalOriginal;
  final int? codEtapa;
  final bool finalizadoLocalmente;

  const PedidoRecenteModel({
    required this.codPedido,
    required this.dataDigitacao,
    required this.codEmpresa,
    required this.razaoEmpresa,
    required this.nomeCliente,
    required this.nomeRepresentante,
    required this.situacao,
    required this.valorTotalOriginal,
    required this.codEtapa,
    required this.finalizadoLocalmente,
  });

  int? get codEtapaExibicao =>
      finalizadoLocalmente ? etapaRomaneioConcluidoLocal : codEtapa;

  bool get apareceNaLista =>
      codEtapa == 4 || codEtapa == etapaRomaneioConcluidoLocal;

  bool get precisaDeRomaneio => codEtapa == 4;

  String get primeiroNomeRepresentante {
    final partes = nomeRepresentante.trim().split(RegExp(r'\s+'));
    return partes.isNotEmpty && partes.first.isNotEmpty ? partes.first : '-';
  }

  static Color corPorEtapa(int codEtapa) {
    switch (codEtapa) {
      case 3:
        return const Color(0xFFFE8D00);
      case 4:
        return const Color(0xFF4CAF50);
      case etapaRomaneioConcluidoLocal:
        return const Color(0xFF0043AC);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  factory PedidoRecenteModel.fromJson(Map<String, dynamic> json) {
    return PedidoRecenteModel(
      codPedido: json['codPedido']?.toString() ?? '',
      dataDigitacao: json['dataDigitacao'] as String? ?? '',
      codEmpresa: json['codEmpresa'] as int? ?? 0,
      razaoEmpresa: json['razaoEmpresa'] as String?,
      nomeCliente: json['nomeCliente'] as String? ?? '',
      nomeRepresentante: json['nomeRepresentante'] as String? ?? '',
      situacao: json['situacao'] as String? ?? '',
      valorTotalOriginal: (json['valorTotalOriginal'] as num?)?.toDouble() ?? 0,
      codEtapa: json['codEtapa'] as int?,
      finalizadoLocalmente: json['finalizadoLocalmente'] as bool? ?? false,
    );
  }

  PedidoRecenteModel copyWith({String? situacao, int? codEtapa}) {
    return PedidoRecenteModel(
      codPedido: codPedido,
      dataDigitacao: dataDigitacao,
      codEmpresa: codEmpresa,
      razaoEmpresa: razaoEmpresa,
      nomeCliente: nomeCliente,
      nomeRepresentante: nomeRepresentante,
      situacao: situacao ?? this.situacao,
      valorTotalOriginal: valorTotalOriginal,
      codEtapa: codEtapa ?? this.codEtapa,
      finalizadoLocalmente: finalizadoLocalmente,
    );
  }
}
