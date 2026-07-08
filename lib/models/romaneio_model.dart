class PaginatedResponseRomaneio<T> {
  final String continuationToken;
  final List<T> data;

  PaginatedResponseRomaneio({
    required this.continuationToken,
    required this.data,
  });

  factory PaginatedResponseRomaneio.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    return PaginatedResponseRomaneio(
      continuationToken: json['continuationToken'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonItem(item as Map<String, dynamic>))
          .toList(),
    );
  }
}


class RomaneioModel {
  final String codPedido;
  final String codProduto;
  final String descProdutoGen;
  final String localNatureza;
  final int qtdPedida;

  RomaneioModel({
    required this.codPedido,
    required this.codProduto,
    required this.descProdutoGen,
    required this.localNatureza,
    required this.qtdPedida,
  });

  factory RomaneioModel.fromJson(Map<String, dynamic> json) => RomaneioModel(
    codPedido: json['codPedido'],
    codProduto: json['codProduto'],
    descProdutoGen: json['descProdutoGen'],
    localNatureza: json['localNatureza'],
    qtdPedida: json['qtdPedida'],
  );

  Map<String, dynamic> toJson() => {
    'codPedido': codPedido,
    'codProduto': codProduto,
    'descProdutoGen': descProdutoGen,
    'localNatureza': localNatureza,
    'qtdPedida': qtdPedida,
  };
}
