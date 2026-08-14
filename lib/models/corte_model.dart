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
  final String? corHex; //vou colocor no layout
  final int? peso;
  final int status;
  final String dataEmissao;
  final String? dataAgendada;

  CorteModel({
    required this.codPedido,
    this.codProdutoPai,
    this.codCor,
    this.corHex,
    this.peso,
    required this.status,
    required this.dataEmissao,
    this.dataAgendada,
  });

  factory CorteModel.fromJson(Map<String, dynamic> json) => CorteModel(
    codPedido: json['codPedido'] ?? '',
    codProdutoPai: json['codProdutoPai'],
    codCor: json['codCor'],
    corHex: json['corHex'],
    peso: ((json['peso'] ?? 0) as num).toInt(),
    status: json['status'] as int,
    dataEmissao: json['dataEmissao'] ?? '',
    dataAgendada: json['dataAgendada'],
  );

  Map<String, dynamic> toJson() => {
    'codPedido': codPedido,
    'codProdutoPai': codProdutoPai,
    'codCor': codCor,
    'corHex': corHex,
    'peso': peso,
    'status': status,
    'dataEmissao': dataEmissao,
    'dataAgendada': dataAgendada,
  };
  CorteModel copyWith({
    String? codPedido,
    String? codProdutoPai,
    String? codCor,
    String? corHex,
    int? peso,
    int? status,
    String? dataEmissao,
    String? dataAgendada,
  }) {
    return CorteModel(
      codPedido: codPedido ?? this.codPedido,
      codProdutoPai: codProdutoPai ?? this.codProdutoPai,
      codCor: codCor ?? this.codCor,
      corHex: corHex ?? this.corHex,
      peso: peso ?? this.peso,
      status: status ?? this.status,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      dataAgendada: dataAgendada ?? this.dataAgendada,
    );
  }
}
