Post-Contenido 2

Implementación de Seguridad HTTPS con Certificate Pinning en Flutter

Descripción

En este laboratorio se desarrolló una aplicación en Flutter enfocada en reforzar la seguridad de las comunicaciones HTTPS mediante la técnica de certificate pinning.

Se utilizó un cliente HTTP personalizado que valida únicamente un certificado específico, evitando ataques como Man-in-the-Middle (MITM). La aplicación simula un entorno donde la integridad de los datos transmitidos es crítica, como en sistemas financieros o aplicaciones sensibles.

Objetivo del laboratorio

Implementar medidas de seguridad en la comunicación de red:

Validar certificados digitales de forma estricta
Detectar errores en conexiones seguras
Proteger credenciales del usuario
Automatizar encabezados de autenticación

Tecnologías utilizadas
Flutter
Dart
Dio (cliente HTTP)
flutter_secure_storage
OpenSSL

Configuración del proyecto
Instalación de dependencias
flutter pub get
Ejecución
flutter run

Configuración de seguridad

Para pruebas, se generó un certificado digital autofirmado:

openssl req -x509 -newkey rsa:2048 -keyout assets/certs/key.pem -out assets/certs/cert.pem -days 365 -nodes -subj "/CN=secure.api.test/O=SecureApp/C=CO"

El certificado utilizado en la app:

assets/certs/cert.pem

Implementación

1. Validación de certificado

Se configuró un entorno seguro donde solo se acepta el certificado incluido en la aplicación, bloqueando cualquier otro intento de conexión.

2. Cliente HTTP personalizado

Se utilizó Dio con configuración especial para integrar validación SSL personalizada.

3. Manejo de errores TLS

Se capturan errores de tipo HandshakeException y se manejan mostrando mensajes adecuados al usuario.

4. Protección de datos

Se almacenan tokens de forma segura utilizando almacenamiento cifrado.

5. Interceptor de solicitudes

Se implementó un interceptor que añade automáticamente el token en cada petición HTTP.



Checkpoint 1: Conexión segura
La aplicación se conecta correctamente al servidor
Se valida el certificado
Respuesta exitosa (HTTP 200)

Evidencia:

![Checkpoint 1](screenshots/1.jpeg)

Checkpoint 2: Rechazo de certificado
Se bloquea conexión con certificado inválido
Se genera error de seguridad
No se permite acceso

Evidencia:

![Checkpoint 2](screenshots/2.jpeg)

Checkpoint 3: Header de autorización
Se incluye automáticamente el token
Se valida en cada solicitud HTTP

Evidencia:

![Checkpoint 3](screenshots/3.png)

Checkpoint 4: Flujo completo
Funcionamiento completo del sistema
Seguridad activa en todas las peticiones
Sin errores en ejecución

Evidencia:

![Checkpoint 4](screenshots/4.jpeg)

Estructura del proyecto
lib/
 ├── network/
 │    ├── http_client.dart
 │    ├── error_handler.dart
 │    └── auth_interceptor.dart
 ├── screens/
 │    └── main_screen.dart
 └── main.dart

assets/
 └── certs/
      └── cert.pem


