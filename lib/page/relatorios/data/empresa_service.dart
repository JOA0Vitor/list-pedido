import 'package:flutter/material.dart';
import 'package:pedidosdp/page/api_configuracao/api_configuracao.dart';

class EmpresaService {
  EmpresaService._();
  static final EmpresaService instance = EmpresaService._();

  final ValueNotifier<Empresa> empresaAtual = ValueNotifier(Empresa.santaCruz);
}
