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
  final int? codEtapa; // 3 = Separacao, 4 = Bipagem, null = sem itens ainda

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
  });

  bool get finalizadoLocalmente => situacao == situacaoConcluidoLocal;
  int get codEtapaOuPadrao => codEtapa ?? 0;

  /// Regra combinada: so precisa entrar na fila de romaneio se estiver
  /// comercialmente "Digitado" E ainda nao ter comecado a producao (etapa 3).
  bool get precisaDeRomaneio => situacao == 'Digitado' && codEtapa == 3;

   static Color corPorEtapa(int? codEtapa) {
    switch (codEtapa) {
      case 3:
        return const Color(0xFF9E9E9E); // Separacao
      case 4:
        return const Color(0xFFFE8D00); // Bipagem
      case 5:
        return const Color(0xFF4e2da2); // Faturamento
      case 9:
        return const Color(0xFF3d7d24); // Concluido (de verdade, na API)
      case etapaRomaneioConcluidoLocal:
        return const Color(0xFF0043AC); // Concluido localmente (mesmo azul do botao Finalizar)
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
    );
  }
}
