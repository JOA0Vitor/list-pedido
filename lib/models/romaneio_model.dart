class PaginatedResponseRomaneio<T> {
  final String codPedido;
  final List<T> itens;

  PaginatedResponseRomaneio({required this.codPedido, required this.itens});

  factory PaginatedResponseRomaneio.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    return PaginatedResponseRomaneio(
      codPedido: json['codPedido'] ?? '',
      itens: (json['itens'] as List<dynamic>)
          .map((item) => fromJsonItem(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RomaneioModel {
  final String codPedido;
  final String codProduto;
  final String descProdutoGen;
  final String? localNatureza;
  final double qtdPedida; 
  final String? codProdutoPai;
  final String? codCor;


  RomaneioModel({
    required this.codPedido,
    required this.codProduto,
    required this.descProdutoGen,
    this.localNatureza,
    required this.qtdPedida,
    this.codProdutoPai,
    this.codCor,
  });

  factory RomaneioModel.fromJson(Map<String, dynamic> json) => RomaneioModel(
    codPedido: json['codPedido'] ?? '',
    codProduto: json['codProduto'] ?? '',
    descProdutoGen: json['descProdutoGen'] ?? '',
    localNatureza: json['localNatureza'],
    qtdPedida: ((json['qtdPedida'] ?? 0) as num).toDouble(),
    codProdutoPai: json['codProdutoPai'],
    codCor: json['codCor'],
  );

  Map<String, dynamic> toJson() => {
    'codPedido': codPedido,
    'codProduto': codProduto,
    'descProdutoGen': descProdutoGen,
    'localNatureza': localNatureza,
    'qtdPedida': qtdPedida,
    'codProdutoPai': codProdutoPai,
    'codCor': codCor,
  };
}
