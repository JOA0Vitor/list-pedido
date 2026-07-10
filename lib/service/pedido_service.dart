// import 'package:http/http.dart' as api;

// class PedidoService {
//   Future<void> finalizarPedido(String codPedido) async {
//     // 1. Finaliza pedido
//     await api.post('/pedidos/$codPedido/finalizar');
    
//     // 2. Dispara mensagem WhatsApp pelo backend
//     await api.post('/whatsapp/enviar', data: {
//       'telefone': '5581999999999',
//       'mensagem': 'Pedido $codPedido finalizado ✅',
//     });
//   }
// }