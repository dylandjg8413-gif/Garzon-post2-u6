import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/api_client.dart';
import '../network/security_error_handler.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _saveToken() async {
    await _storage.write(key: 'access_token', value: 'fake_secure_token_123');
    _showSnackBar("Token guardado correctamente");
  }

  Future<void> _testValidConnection() async {
    try {
      final response = await apiClient.testConnection('/');
      _showSnackBar("Conexión exitosa: Status ${response.statusCode}");
    } catch (e) {
      _showSnackBar(SecurityErrorHandler.handleError(e), isError: true);
    }
  }

  Future<void> _testInvalidCertificate() async {
    // Simulamos conexión a un host que fallará por certificate pinning
    // ya que no coincide con server_cert.pem
    try {
      final response = await apiClient.dio.get("https://expired.badssl.com/");
      _showSnackBar("Conexión exitosa inesperada: ${response.statusCode}");
    } catch (e) {
      _showSnackBar(SecurityErrorHandler.handleError(e), isError: true);
    }
  }

  Future<void> _testHeader() async {
    try {
      // Esta llamada fallará o tendrá éxito según el server, 
      // pero lo importante es ver el log del Authorization header.
      await apiClient.testConnection('/secure-data');
      _showSnackBar("Petición enviada. Revise los logs para el header.");
    } catch (e) {
      _showSnackBar("Log generado. Error esperado de endpoint: ${e.toString().split(' ').take(3).join(' ')}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banca Segura - Lab 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _saveToken,
              child: const Text('Guardar Token Seguro'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testValidConnection,
              child: const Text('Probar Conexión Válida'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testInvalidCertificate,
              child: const Text('Probar Certificado Inválido'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testHeader,
              child: const Text('Probar Header Authorization'),
            ),
          ],
        ),
      ),
    );
  }
}
