class PaginatedResponseClientes<T> {
  final String continuationToken;
  final List<T> data;

  PaginatedResponseClientes({
    required this.continuationToken,
    required this.data,
  });

  factory PaginatedResponseClientes.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    return PaginatedResponseClientes(
      continuationToken: json['continuationToken'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonItem(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ClientesModel {
  final num codCliente;
  final String nome;

  ClientesModel({required this.codCliente, required this.nome});

  factory ClientesModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return ClientesModel(
      codCliente: toInt(json['codCliente']),
      nome: json['nome']?.toString() ?? '',
    );
  }
}