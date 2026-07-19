// import 'package:firebase_database/firebase_database.dart';

// class PedidoLockService {
//   final _ref = FirebaseDatabase.instance.ref('pedidos_em_uso');

//   /// Retorna o nome do usuário que está usando o pedido, ou null se estiver livre.
//   Future<String?> usuarioEmUso(String codPedido) async {
//     final snapshot = await _ref.child(codPedido).get();
//     if (snapshot.exists) {
//       final data = Map<String, dynamic>.from(snapshot.value as Map);
//       return data['usuario'] as String?;
//     }
//     return null;
//   }

//   /// Marca o pedido como em uso pelo usuário atual.
//   Future<void> travar(String codPedido, String usuario) async {
//     final ref = _ref.child(codPedido);
//     await ref.set({
//       'usuario': usuario,
//       'desde': ServerValue.timestamp,
//     });
//     ref.onDisconnect().remove(); // remove sozinho se o app cair/perder conexão
//   }

//   /// Libera o pedido quando o usuário sai da tela normalmente.
//   Future<void> destravar(String codPedido) async {
//     final ref = _ref.child(codPedido);
//     await ref.onDisconnect().cancel();
//     await ref.remove();
//   }
// }