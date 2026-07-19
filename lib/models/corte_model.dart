class PaginatedResponseCorte<T> {
  final String codPedido;
  final List<T> itens;

  PaginatedResponseCorte({required this.codPedido, required this.itens});

  factory PaginatedResponseCorte.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    return PaginatedResponseCorte(
      codPedido: json['codPedido'] ?? '',
      itens: (json['itens'] as List<dynamic>)
          .map((item) => fromJsonItem(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CorteModel {
  final String codPedido;
  final String? codProdutoPai;
  final String? codCor;
  final String? corHex; //vou se coloco no modelo
  final int? peso;

  CorteModel({
    required this.codPedido,
    this.codProdutoPai,
    this.codCor,
    this.corHex,
    this.peso,
  });

  factory CorteModel.fromJson(Map<String, dynamic> json) => CorteModel(
    codPedido: json['codPedido'] ?? '',
    codProdutoPai: json['codProdutoPai'],
    codCor: json['codCor'],
    corHex: json['corHex'],
    peso: ((json['peso'] ?? 0) as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'codPedido': codPedido,
    'codProdutoPai': codProdutoPai,
    'codCor': codCor,
    'corHex': corHex,
    'peso': peso,
  };
}
