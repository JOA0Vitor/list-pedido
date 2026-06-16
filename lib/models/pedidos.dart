import 'package:flutter/material.dart';

class Pedido {
  final int numero;
  final String dataHora;
  final String cliente;
  final String etapa;
  final Color etapaColor;
  final bool concluido;

  const Pedido({
    required this.numero,
    required this.dataHora,
    required this.cliente,
    required this.etapa,
    required this.etapaColor,
    this.concluido = false,
  });
}