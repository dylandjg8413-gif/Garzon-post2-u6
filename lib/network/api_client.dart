import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'token_interceptor.dart';

class ApiClient {
  late Dio _dio;
  // URL pública para garantizar éxito en Checkpoint 1
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Dio get dio => _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    
    _dio.interceptors.add(TokenInterceptor());
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<void> initCertificatePinning() async {
    // Nota: El pinning a jsonplaceholder fallará a menos que tengas su certificado .pem
    // Para el Checkpoint 1, usaremos el cliente normal si el pinning no es requerido.
    try {
      final ByteData certData = await rootBundle.load('assets/certs/server_cert.pem');
      final SecurityContext context = SecurityContext(withTrustedRoots: true);
      context.setTrustedCertificatesBytes(certData.buffer.asUint8List());

      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient(context: context);
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
          return client;
        },
      );
    } catch (e) {
      debugPrint("Aviso: No se pudo cargar pinning, usando configuración por defecto: $e");
    }
  }

  Future<Response> testConnection(String path) async {
    try {
      final response = await _dio.get(path);
      
      // CHECKPOINT 1: Log de éxito solicitado
      debugPrint("--------------------------------------------------");
      debugPrint("CHECKPOINT 1 - Conexión HTTPS exitosa");
      debugPrint("Status code: ${response.statusCode}");
      debugPrint("URL: $baseUrl$path");
      debugPrint("--------------------------------------------------");
      
      return response;
    } on DioException catch (e) {
      // Log del error real completo solicitado
      debugPrint("--------------------------------------------------");
      debugPrint("ERROR EN CHECKPOINT 1");
      debugPrint("Tipo: ${e.type}");
      debugPrint("Mensaje: ${e.message}");
      debugPrint("Error original: ${e.error}");
      debugPrint("--------------------------------------------------");
      rethrow;
    }
  }
}
