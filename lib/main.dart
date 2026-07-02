import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidosdp/page/home_page.dart';
import 'package:pedidosdp/service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

   NotificationService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF7FBFD)),
      ),

      home: const HomePage(),
    );
  }
}
