import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'network/api_client.dart';

// Proveedor global simple para el laboratorio
final apiClient = ApiClient();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar certificate pinning antes de arrancar
  try {
    await apiClient.initCertificatePinning();
  } catch (e) {
    debugPrint("Error inicializando certificados: $e");
  }

  runApp(const BancaSeguraApp());
}

class BancaSeguraApp extends StatelessWidget {
  const BancaSeguraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banca Segura Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
