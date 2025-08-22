# 📅 AgendaApp - Sistema de Citas con Flutter & Firebase

Una aplicación completa de gestión de citas desarrollada con Flutter, Firebase Auth y Firestore, con soporte multi-plataforma (Web, Android, Desktop).

## 🚀 Características Implementadas

### ✅ **Sistema de Autenticación Completo**
- **Login con Email/Contraseña**: Autenticación tradicional con validación
- **Google Sign-In**: Integración con Google OAuth2 
- **Registro de Usuarios**: Creación de cuentas con validación de datos
- **Logout Funcional**: Cierre de sesión seguro
- **Estados de Usuario**: Gestión de sesiones con Riverpod

### ✅ **Arquitectura y Configuración**
- **Clean Architecture**: Separación clara de responsabilidades
- **State Management**: Riverpod para gestión de estado reactivo
- **Navegación**: GoRouter con rutas tipadas
- **Firebase Integration**: Auth, Firestore y emuladores
- **Multi-Platform**: Web, Android, Desktop Linux

### ✅ **Build System & DevOps**
- **Android Gradle**: Configurado para Java 17 y AGP 8.2.2
- **Firebase Emulators**: Desarrollo local sin conexión a producción
- **Hot Reload**: Desarrollo rápido con recarga en caliente
- **APK Generation**: Compilación exitosa para dispositivos Android

## 📋 Requisitos Previos

### 🛠️ **Herramientas Necesarias**
- **Flutter SDK**: 3.32.8 o superior
- **Dart SDK**: Incluido con Flutter
- **Java JDK**: 17 (configurado en `JAVA_HOME`)
- **Android SDK**: API 31+ (para desarrollo Android)
- **Node.js**: 16+ (para Firebase CLI)
- **Firebase CLI**: `npm install -g firebase-tools`
- **Git**: Para control de versiones

### 🔧 **Configuración del Sistema**
```bash
# Verificar Flutter
flutter doctor

# Configurar Java 17
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Verificar Firebase CLI
firebase --version
```

## 🚀 Guía de Instalación y Ejecución

### **PASO 1: Clonar el Repositorio**
```bash
git clone https://github.com/Shinyvv/AgendaApp.git
cd AgendaApp
```

### **PASO 2: Instalar Dependencias**
```bash
# Dependencias de Flutter
flutter pub get

# Dependencias de Cloud Functions (opcional)
cd functions
npm install
cd ..
```

### **PASO 3: Iniciar Firebase Emulators** 🔥
```bash
# Terminal 1: Iniciar emuladores (MANTENER ABIERTO)
firebase emulators:start --only auth,firestore

# Los emuladores se ejecutarán en:
# - Auth: http://127.0.0.1:9099
# - Firestore: http://127.0.0.1:8080
# - UI: http://127.0.0.1:4001
```

### **PASO 4: Ejecutar la Aplicación**

#### 🌐 **Opción A: Web (Recomendado para desarrollo)**
```bash
# Terminal 2: App Web
flutter run -d chrome --web-port=3001

# La app se abrirá en: http://localhost:3001
```

#### 📱 **Opción B: Android (Para testing en dispositivo)**
```bash
# Verificar dispositivos conectados
flutter devices

# Ejecutar en dispositivo Android
flutter run -d [DEVICE_ID]

# O compilar APK
flutter build apk --debug
```

#### 🖥️ **Opción C: Desktop Linux**
```bash
# Verificar soporte de desktop
flutter config --enable-linux-desktop

# Ejecutar en desktop
flutter run -d linux
```

## 🧪 Guía de Testing y Desarrollo

### **Testing del Sistema de Autenticación**

#### 1. **Login con Email/Contraseña**
- Abrir la app en: `http://localhost:3001`
- Hacer clic en "¿No tienes cuenta? Regístrate"
- Crear usuario de prueba: `test@example.com` / `password123`
- Iniciar sesión con las credenciales creadas

#### 2. **Google Sign-In con Emuladores**
- Hacer clic en "Continuar con Google"
- Se abrirá la interfaz del emulador de Firebase Auth
- Ingresar cualquier email de prueba (no necesita ser real)
- El emulador simulará un login exitoso

#### 3. **Verificar Autenticación**
- Ver usuarios creados en: `http://127.0.0.1:4001/auth`
- Probar logout desde el menú de usuario
- Verificar redirección a pantalla de login

### **Hot Reload y Desarrollo**
```bash
# En la terminal donde corre Flutter:
r    # Hot reload (recarga cambios instantáneamente)
R    # Hot restart (reinicia la app completa)
q    # Salir
d    # Detach (deja la app corriendo)
```

## 📁 Estructura del Proyecto

```
AgendaApp/
├── lib/
│   ├── src/
│   │   ├── app/
│   │   │   ├── app.dart                 # App principal
│   │   │   └── router.dart              # Configuración de rutas
│   │   └── features/
│   │       ├── auth/
│   │       │   └── presentation/
│   │       │       ├── screens/
│   │       │       │   ├── login_screen.dart      # Pantalla de login
│   │       │       │   └── splash_screen.dart     # Splash con auto-redirect
│   │       │       └── widgets/
│   │       │           └── google_sign_in_button.dart
│   │       ├── booking/
│   │       │   └── presentation/
│   │       │       └── screens/
│   │       │           └── booking_home_screen.dart # Home con logout
│   │       └── notifications/
│   │           └── local_notifications.dart
│   ├── features/
│   │   └── auth/
│   │       └── auth_service.dart        # Servicio de autenticación
│   ├── firebase_options.dart           # Config Firebase
│   └── main.dart                       # Entry point
├── android/
│   ├── app/
│   │   └── build.gradle.kts            # Config Android + Java 17
│   ├── build.gradle.kts                # Config proyecto Android
│   └── gradle.properties               # Props optimizadas para Java 17
├── web/
│   └── index.html                      # Config web + Google Sign-In
├── functions/                          # Cloud Functions (TypeScript)
├── firebase.json                       # Config Firebase
├── firestore.rules                     # Reglas de seguridad
└── vercel.json                        # Config para deploy web
```

## 📋 Changelog del Último Commit

### 🔧 **Cambios Técnicos Realizados**

#### **Sistema de Autenticación**
- ✅ **AuthService**: Servicio centralizado con Firebase Auth
- ✅ **Google Sign-In**: Implementación web con popup
- ✅ **Email/Password Auth**: Login y registro tradicional
- ✅ **State Management**: Providers con Riverpod
- ✅ **Session Persistence**: Manejo de estados de usuario

#### **Configuración Android**
- ✅ **build.gradle.kts**: Actualizado para Java 17 y AGP 8.2.2
- ✅ **gradle.properties**: Optimizado para compilación eficiente
- ✅ **Firebase Dependencies**: BoM 32.7.0 con Auth y Firestore
- ✅ **MultiDex**: Soporte para apps grandes
- ✅ **ProGuard**: Optimización de release builds

#### **UI/UX Improvements**
- ✅ **Login Screen**: Diseño moderno con Material Design
- ✅ **Responsive Design**: Adaptación a diferentes tamaños
- ✅ **Google Button**: Ícono local en lugar de imagen externa
- ✅ **Error Handling**: Validación y mensajes de error
- ✅ **Loading States**: Indicadores de progreso

#### **DevOps y Build**
- ✅ **APK Compilation**: Build exitoso para Android
- ✅ **Web Compilation**: Soporte completo para navegadores
- ✅ **Desktop Support**: Habilitado para Linux
- ✅ **Firebase Emulators**: Configuración para desarrollo local
- ✅ **Hot Reload**: Desarrollo rápido habilitado

### 🐛 **Problemas Solucionados**
- ✅ **Java Version Conflicts**: Configuración correcta de Java 17
- ✅ **Gradle Build Errors**: Archivo build.gradle.kts corregido
- ✅ **Network Image Error**: Reemplazado por ícono local
- ✅ **UI Overflow**: Layout responsive implementado
- ✅ **Firebase Connection**: Emuladores configurados correctamente
- ✅ **Device Detection**: USB tethering compatibility

## 🚧 Funcionalidades Pendientes

### **Próximas Implementaciones**

#### 📅 **Sistema de Citas**
- [ ] **Calendario Interactivo**: Widget de selección de fechas
- [ ] **Gestión de Horarios**: Slots disponibles por profesional
- [ ] **Reserva de Citas**: Flow completo de booking
- [ ] **Confirmaciones**: Email/SMS notifications
- [ ] **Cancelaciones**: Gestión de cancelaciones

#### 👥 **Gestión de Usuarios**
- [ ] **Roles y Permisos**: Admin/Employee/Client
- [ ] **Profile Management**: Edición de perfil de usuario
- [ ] **Multi-tenancy**: Soporte para múltiples negocios
- [ ] **Employee Dashboard**: Panel para empleados
- [ ] **Admin Panel**: Gestión completa del negocio

#### 💳 **Pagos y Facturación**
- [ ] **Stripe Integration**: Procesamiento de pagos
- [ ] **Pricing Plans**: Planes de suscripción
- [ ] **Invoicing**: Generación de facturas
- [ ] **Revenue Analytics**: Métricas de ingresos

#### 📱 **Mejoras de UX**
- [ ] **Push Notifications**: Recordatorios de citas
- [ ] **Dark Mode**: Tema oscuro
- [ ] **Offline Support**: Funcionalidad sin conexión
- [ ] **Multi-language**: Soporte internacional
- [ ] **Accessibility**: Mejoras de accesibilidad

#### 🔧 **DevOps y Deploy**
- [ ] **CI/CD Pipeline**: Automatización de deploys
- [ ] **Production Firebase**: Configuración de producción
- [ ] **Vercel Deploy**: Deploy automático de web
- [ ] **Play Store**: Publicación en Android
- [ ] **Monitoring**: Error tracking y analytics

## 🔧 Solución de Problemas Comunes

### **Error: "ERR_CONNECTION_REFUSED"**
```bash
# Verificar que los emuladores estén corriendo
firebase emulators:start --only auth,firestore

# Verificar puertos disponibles
netstat -tulpn | grep :9099
netstat -tulpn | grep :8080
```

### **Error: "Java Version Conflicts"**
```bash
# Configurar Java 17
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
source ~/.bashrc

# Verificar versión
java -version
./gradlew -v
```

### **Error: "Flutter Device Not Found"**
```bash
# Para Android
adb devices
adb kill-server && adb start-server

# Para Desktop
flutter config --enable-linux-desktop
flutter devices
```

### **Error: "Build Failed - Gradle"**
```bash
# Limpiar proyecto
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get

# Rebuild
flutter run
```

## 📞 Soporte y Contribución

### **Contacto**
- **GitHub**: [Shinyvv/AgendaApp](https://github.com/Shinyvv/AgendaApp)
- **Issues**: Reportar bugs en GitHub Issues
- **Discussions**: Preguntas y sugerencias

### **Contribuir**
1. Fork del repositorio
2. Crear feature branch: `git checkout -b feature/nueva-funcionalidad`
3. Commit changes: `git commit -am 'Add nueva funcionalidad'`
4. Push branch: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

---

**Última actualización**: Agosto 2025  
**Versión**: v1.0.0-beta  
**Estado**: En desarrollo activo 🚧
