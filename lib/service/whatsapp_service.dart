import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> enviarMensagem({
    required String telefone,
    required String mensagem,
  }) async {
    try {
      await WhatsappShare.share(text: mensagem, phone: telefone);
    } catch (e) {
      final url = Uri.parse(
        'https://wa.me/$telefone?text=${Uri.encodeComponent(mensagem)}',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o WhatsApp';
      }
    }
  }

  static Future<void> compartilhar(String mensagem) async {
    await WhatsappShare.share(text: mensagem, phone: '+5581999999999');
  }
}

// import 'package:whatsapp_share2/whatsapp_share2.dart';
// import 'package:url_launcher/url_launcher.dart';

// class WhatsAppService {
//   static Future<void> enviar({
//     required String numero,
//     required String mensagem,
//     bool abrirApp = true, // true = abre WhatsApp, false = envia silencioso
//   }) async {
//     if (abrirApp) {
//       // Abre WhatsApp com mensagem pré-preenchida
//       await WhatsappShare.share(text: mensagem, phone: numero);
//     } else {
//       // Chama sua API para envio silencioso
//       await api.post(
//         '/whatsapp/enviar',
//         data: {'telefone': numero, 'mensagem': mensagem},
//       );
//     }
//   }
// }
