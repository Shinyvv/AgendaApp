# Sistema de Reservas con Roles de Usuario

Una aplicación Flutter que permite gestionar reservas con diferenciación de roles entre usuarios (clientes) y trabajadores.

## ✨ Características Principales

### 🔐 Autenticación
- **Google Sign-In nativo**: Inicio de sesión sin abrir navegador externo
- **Firebase Authentication**: Gestión segura de usuarios
- **Selección de rol**: Los usuarios pueden elegir entre ser Cliente o Trabajador

### 👥 Sistema de Roles

#### 🛍️ Usuario (Cliente)
**Permisos:**
- ✅ Crear reservas
- ✅ Ver sus propias reservas
- ✅ Cancelar reservas
- ✅ Calificar servicios
- ✅ Navegar trabajadores disponibles

**Funcionalidades:**
- Dashboard personalizado con lista de trabajadores
- Acciones rápidas para crear reservas
- Historial de servicios utilizados

#### 🔧 Trabajador
**Permisos:**
- ✅ Ver todas las reservas asignadas
- ✅ Aceptar/rechazar reservas
- ✅ Completar trabajos
- ✅ Ver ganancias
- ✅ Gestionar horarios
- ✅ Ver información de clientes

**Funcionalidades:**
- Panel de control con estadísticas
- Gestión de agenda y horarios
- Seguimiento de ganancias y trabajos completados

### 🔄 Cambio de Rol Dinámico
- Los usuarios pueden cambiar entre roles Usuario y Trabajador
- Interfaz diferente según el rol activo
- Persistencia del rol en Firebase Firestore

## 🛠️ Tecnologías Utilizadas

- **Flutter 3.35.1**
- **Firebase Suite**:
  - Firebase Auth 6.0.1
  - Cloud Firestore 6.0.0
  - Firebase Core 4.0.0
- **Google Sign-In 6.2.1** (versión estable)
- **State Management**: flutter_riverpod 2.6.1
- **Routing**: go_router 14.8.1
- **JSON Serialization**: json_annotation + build_runner

## 🏗️ Arquitectura del Proyecto

```
lib/
├── src/
│   ├── models/
│   │   └── user_model.dart          # Modelo de usuario con roles
│   ├── services/
│   │   ├── auth_service.dart        # Servicio de autenticación
│   │   └── user_service.dart        # Gestión de usuarios y roles
│   └── app/
│       ├── app.dart                 # Configuración principal
│       └── router.dart              # Enrutamiento de la app
├── features/
│   ├── auth/
│   │   ├── login_screen.dart        # Pantalla de login
│   │   ├── role_selection_screen.dart # Selección de rol
│   │   └── auth_service.dart        # Servicio de autenticación
│   └── dashboard/
│       ├── main_dashboard.dart      # Dashboard principal (router)
│       ├── user_dashboard.dart      # Dashboard para clientes
│       ├── worker_dashboard.dart    # Dashboard para trabajadores
│       └── role_switcher.dart       # Widget para cambiar roles
└── main.dart
```

## 🚀 Configuración y Uso

### Prerrequisitos
- Flutter SDK 3.35.1 o superior
- Configuración de Firebase (android/app/google-services.json)
- Dependencias instaladas

### Instalación
```bash
flutter pub get
dart run build_runner build  # Generar archivos de serialización JSON
```

### Ejecución
```bash
flutter run
```

## 📱 Flujo de Usuario

1. **Login**: El usuario inicia sesión con Google
2. **Selección de Rol**: Si es nuevo usuario, elige entre Cliente o Trabajador
3. **Dashboard**: Se muestra la interfaz correspondiente a su rol
4. **Cambio de Rol**: Puede cambiar dinámicamente usando el botón de cambio de rol

## 🔧 Configuraciones Especiales

### Google Sign-In Nativo
Para evitar que se abra el navegador durante el login:
```yaml
# pubspec.yaml
google_sign_in: 6.2.1  # Versión estable, NO usar 7.x
```

### Firebase Configuration
Asegurate de tener configurado:
- `google-services.json` en `android/app/`
- `firebase_options.dart` generado con FlutterFire CLI

## 📊 Estado del Proyecto

✅ **Completado:**
- Sistema de autenticación nativo con Google
- Modelo de usuarios con roles y permisos
- Dashboards diferenciados por rol  
- Cambio dinámico de roles
- Integración con Firebase Firestore
- Serialización JSON de modelos

🟡 **En Desarrollo:**
- Sistema de reservas completo
- Notificaciones push
- Chat entre usuarios y trabajadores

## 🤝 Contribución

Este proyecto está en desarrollo activo. Las contribuciones son bienvenidas siguiendo las mejores prácticas de Flutter y manteniendo la arquitectura limpia establecida.
