import 'package:flutter/material.dart';
import 'package:pedidosdp/models/pedidos.dart';
import 'package:pedidosdp/page/list_pedidos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //https://187.85.164.196/api/comercial/v10/pedidoVenda?dataDigitacaoInicio=2026-06-16&dataDigitacaoFim=2026-06-16
  //modulo = comercial - serviço = Comercial v1.0 

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E5EB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7FBFD),
        title: Text(
          'Consulta de Pedidos',
          style: TextStyle(
            color: const Color(0xFF0043AC),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.info_outline, color: Color(0xFF0043AC)),
          ),
        ],
      ),
      body: PedidosScreen(
        pedidos: [
          Pedido(
            numero: 4082,
            dataHora: '12/06/2026',
            cliente: 'teste123',
            etapa: 'Separação & Romaneio',
            etapaColor: const Color(0xFFFE8D00),
          ),
          Pedido(
            numero: 4083,
            dataHora: '13/06/2026',
            cliente: 'cliente2',
            etapa: 'Expedição',
            etapaColor: const Color(0xFF0043AC),
            concluido: true,
          ),
          Pedido(
            numero: 4084,
            dataHora: '14/06/2026',
            cliente: 'cliente3',
            etapa: 'Entrega',
            etapaColor: const Color(0xFF677383),
          ),
          Pedido(
            numero: 4085,
            dataHora: '15/06/2026',
            cliente: 'cliente4',
            etapa: 'Recebimento',
            etapaColor: const Color(0xFF0B1628),
          ),
          Pedido(
            numero: 4086,
            dataHora: '16/06/2026',
            cliente: 'cliente5',
            etapa: 'Entrega',
            etapaColor: const Color(0xFF677383),
          ),
          Pedido(
            numero: 4087,
            dataHora: '17/06/2026',
            cliente: 'cliente6',
            etapa: 'Recebimento',
            etapaColor: const Color(0xFF0B1628),
            concluido: true,
          ),
          Pedido(
            numero: 4088,
            dataHora: '18/06/2026',
            cliente: 'cliente7',
            etapa: 'Entrega',
            etapaColor: const Color(0xFF677383),
          ),
          Pedido(
            numero: 4089,
            dataHora: '19/06/2026',
            cliente: 'cliente8',
            etapa: 'Recebimento',
            etapaColor: const Color(0xFF0B1628),
            concluido: true,
          ),
          Pedido(
            numero: 4090,
            dataHora: '20/06/2026',
            cliente: 'cliente9',
            etapa: 'Entrega',
            etapaColor: const Color(0xFF677383),
          ),
          Pedido(
            numero: 4091,
            dataHora: '21/06/2026',
            cliente: 'cliente10',
            etapa: 'Recebimento',
            etapaColor: const Color(0xFF0B1628),
            concluido: true,
          ),
          Pedido(
            numero: 4092,
            dataHora: '22/06/2026',
            cliente: 'cliente11',
            etapa: 'Entrega',
            etapaColor: const Color(0xFF677383),
          ),
          Pedido(
            numero: 4093,
            dataHora: '23/06/2026',
            cliente: 'cliente12',
            etapa: 'Recebimento',
            etapaColor: const Color(0xFF0B1628),
            concluido: true,
          ),
          Pedido(
            numero: 4094,
            dataHora: '24/06/2026',
            cliente: 'cliente13',
            etapa: 'Entrega',
            etapaColor: const Color(0xFF677383),
          ),
          Pedido(
            numero: 4095,
            dataHora: '25/06/2026',
            cliente: 'cliente14',
            etapa: 'Recebimento',
            etapaColor: const Color(0xFF0B1628),
            concluido: true,
          ),
        ],
      ),
    );
  }

  listaPedidos() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFF7FBFD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'N° Pedido',
                    style: TextStyle(
                      color: Color(0xFF677383),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '4082',
                    style: TextStyle(
                      color: Color(0xFF0043AC),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'data / hora'.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF677383),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '12/06/2026',
                    style: TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente'.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF677383),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'teste123',
                    style: TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sepearação & romaneio'.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFF0B1628),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width / 6,
                    height: 6,
                    color: Color(0xFFFE8D00),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFFE8D00),
                    size: 25,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF677383),
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
