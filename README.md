# Post-Contenido 2 - Seguridad Móvil

## Implementación de Certificate Pinning en Flutter

## Descripción

En este laboratorio se desarrolló una aplicación móvil en Flutter que implementa certificate pinning para asegurar la comunicación HTTPS. Se utilizó la librería Dio junto con un SecurityContext personalizado que permite validar únicamente un certificado específico, evitando conexiones con servidores no confiables.

El proyecto simula un entorno de aplicación bancaria donde la seguridad en la comunicación es un aspecto crítico.

## Objetivo del laboratorio

Implementar mecanismos de seguridad en la capa de red mediante:

* Validación de certificados (certificate pinning)
* Manejo de errores TLS
* Almacenamiento seguro de credenciales
* Inclusión de headers de autenticación

## Tecnologías utilizadas

* Flutter
* Dart
* Dio
* flutter_secure_storage
* OpenSSL

## Configuración del proyecto

### Instalación de dependencias

```text
flutter pub get
```

### Ejecución

```text
flutter run
```

## Configuración de seguridad

Se generó un certificado autofirmado para pruebas utilizando OpenSSL:

```text
openssl req -x509 -newkey rsa:2048 -keyout assets/certs/server_key.pem -out assets/certs/server_cert.pem -days 365 -nodes -subj "/CN=api.bancasegura.test/O=BancaSegura/C=CO"
```

El certificado utilizado por la aplicación es:

```text
assets/certs/server_cert.pem
```

La clave privada no se incluye en el repositorio.

## Implementación

### 1. Certificate Pinning

Se configuró un SecurityContext sin certificados de confianza por defecto, cargando únicamente el certificado definido en el proyecto.

### 2. Cliente HTTP

Se utilizó Dio con un adaptador personalizado para integrar el contexto de seguridad y validar el certificado del servidor.

### 3. Manejo de errores

Se implementó un manejador que detecta errores de tipo HandshakeException y muestra mensajes comprensibles al usuario.

### 4. Almacenamiento seguro

Se utilizó flutter_secure_storage para guardar el token de autenticación.

### 5. Interceptor de red

Se implementó un interceptor que agrega automáticamente el header Authorization en cada solicitud.

## Evidencias

Las evidencias del laboratorio se encuentran en la carpeta:

```text
/evidencias
```

### Checkpoint 1: Conexión segura

Se evidencia una conexión exitosa con el certificado válido (respuesta HTTP 200).

### Checkpoint 2: Rechazo de certificado

Se muestra el rechazo de una conexión con certificado inválido, generando un error de tipo HandshakeException.

### Checkpoint 3: Header de autorización

Se evidencia la inclusión del header Authorization en las solicitudes HTTP.

## Estructura del proyecto

```text
lib/
 ├── network/
 │    ├── api_client.dart
 │    ├── security_error_handler.dart
 │    └── token_interceptor.dart
 ├── screens/
 │    └── home_screen.dart
 └── main.dart

assets/
 └── certs/
      └── server_cert.pem

evidencias/
```

## Consideraciones de seguridad

* No se incluyen claves privadas en el repositorio
* Se valida estrictamente el certificado del servidor
* Se evita el uso de conexiones inseguras
* Se protege la información sensible del usuario

## Control de versiones

El repositorio incluye commits descriptivos en modo imperativo, cumpliendo con los requisitos del laboratorio.


