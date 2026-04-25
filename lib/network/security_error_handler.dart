import 'dart:io';
import 'package:dio/dio.dart';

class SecurityErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      if (error.error is HandshakeException || 
          error.type == DioExceptionType.badCertificate ||
          error.toString().contains('HandshakeException')) {
        return "Conexión rechazada: el certificado del servidor no es confiable";
      }
      
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return "Error de red: Tiempo de espera agotado";
        case DioExceptionType.connectionError:
          return "Error de red: No se pudo establecer la conexión";
        default:
          return "Error inesperado de red";
      }
    }
    return "Error desconocido: ${error.toString()}";
  }
}
