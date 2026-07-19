import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/page/corte_industrial_home_page.dart';
import 'package:pedidosdp/page/home_page.dart';
import 'package:pedidosdp/page/selecao_perfil_page.dart';
import 'package:pedidosdp/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

enum PerfilApp { romaneio, corteIndustrial }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  NotificationService();

  final prefs = await SharedPreferences.getInstance();
  final perfilSalvo = prefs.getString('perfil_app');

  final Widget telaInicial = perfilSalvo == PerfilApp.corteIndustrial.name
      ? const CorteIndustrialHomePage()
      : const HomePage();

  runApp(MyApp(telaInicial: telaInicial));
}

class MyApp extends StatelessWidget {
  final Widget telaInicial;
  const MyApp({super.key, required this.telaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // flutter build apk --split-per-abi
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF7FBFD)),
      ),

      home: SelecaoPerfilPage(),
    );
  }
}
