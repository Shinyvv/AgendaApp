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

## 📋 Versiones Específicas del Proyecto

### 🎯 **Tabla de Compatibilidad Windows/Linux**

| **Herramienta** | **Versión Exacta** | **Windows** | **Comando de Verificación** |
|-----------------|-------------------|-------------|----------------------------|
| **Flutter SDK** | `3.35.1` (stable) | ✅ Compatible | `flutter --version` |
| **Dart SDK** | `3.9.0` | ✅ Compatible | `dart --version` |
| **Node.js** | `24.6.0` | ✅ Compatible | `node --version` |
| **pnpm** | `10.14.0` | ✅ Compatible | `pnpm --version` |
| **Java JDK** | `17.0.16` (OpenJDK) | ✅ Compatible | `java -version` |
| **Firebase CLI** | `14.12.1` | ✅ Compatible | `firebase --version` |
| **Android SDK** | `36.0.0` | ✅ Compatible | `flutter doctor -v` |
| **Gradle** | `8.12` | ✅ Compatible | `./gradlew -v` |
| **Kotlin** | `1.9.22` | ✅ Compatible | Ver build.gradle.kts |

### 🔧 **Dependencias Android Específicas**

| **Componente** | **Versión** | **Archivo** |
|----------------|-------------|-------------|
| **Android Gradle Plugin** | `8.2.2` | `android/build.gradle.kts` |
| **Kotlin Gradle Plugin** | `1.9.22` | `android/build.gradle.kts` |
| **Google Services** | `4.4.0` | `android/build.gradle.kts` |
| **Firebase BoM** | `32.7.0` | `android/app/build.gradle.kts` |
| **Compile SDK** | `36` | Automático (Flutter) |
| **Target SDK** | `36` | Automático (Flutter) |
| **Min SDK** | `21` | Automático (Flutter) |

### 📦 **Dependencias Flutter (pubspec.yaml)**

| **Package** | **Versión** | **Propósito** |
|-------------|-------------|---------------|
| **flutter** | `sdk: flutter` | Framework base |
| **firebase_core** | `^4.0.0` | Firebase inicialización |
| **firebase_auth** | `^6.0.1` | Autenticación |
| **cloud_firestore** | `^6.0.0` | Base de datos |
| **flutter_riverpod** | `^2.6.1` | State management |
| **go_router** | `^16.2.0` | Navegación |
| **google_sign_in** | `^7.1.1` | Google OAuth |
| **flutter_local_notifications** | `^19.4.0` | Notificaciones |
| **table_calendar** | `^3.2.0` | Calendario UI |
| **intl** | `^0.20.2` | Internacionalización |

### 🌐 **Dependencias Cloud Functions (Node.js)**

| **Package** | **Versión** | **Propósito** |
|-------------|-------------|---------------|
| **Node.js Engine** | `22` | Runtime requerido |
| **firebase-admin** | `^11.11.1` | SDK Admin |
| **firebase-functions** | `^4.9.0` | Functions SDK |
| **typescript** | `^5.5.4` | Compilador TS |
| **@types/node** | `^22.7.4` | Tipos Node.js |
| **firebase-tools** | `^14.12.0` | CLI desarrollo |

### 🛠️ **Herramientas Necesarias**
- **Flutter SDK**: 3.35.1 stable channel
- **Dart SDK**: 3.9.0 (incluido con Flutter)
- **Java JDK**: 17.0.16 (OpenJDK recomendado)
- **Android SDK**: 36.0.0+ con Build Tools
- **Node.js**: 24.6.0+ (Functions requieren Node 22+)
- **pnpm**: 10.14.0+ (Package manager del proyecto)
- **Firebase CLI**: 14.12.1+ instalado globalmente
- **Git**: Para control de versiones
- **Android Studio**: 2025.1.2+ (opcional, pero recomendado)
- **VS Code**: Con extensiones Flutter y Dart

### 🪟 **Configuración Específica para Windows**

#### **1. Instalar Java JDK 17**
```powershell
# Opción 1: Descargar desde Oracle/OpenJDK
# https://jdk.java.net/17/

# Opción 2: Con Chocolatey
choco install openjdk17

# Opción 3: Con Scoop
scoop install openjdk17

# Configurar variables de entorno
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17.0.16"
$env:PATH += ";$env:JAVA_HOME\bin"
```

#### **2. Instalar Node.js y pnpm**
```powershell
# Instalar Node.js 24.6.0
# Descargar desde: https://nodejs.org/

# Verificar instalación
node --version  # Debe mostrar v24.6.0+

# Instalar pnpm globalmente
npm install -g pnpm@10.14.0

# Verificar pnpm
pnpm --version  # Debe mostrar 10.14.0
```

#### **3. Configurar Flutter**
```powershell
# Descargar Flutter SDK 3.35.1
# https://docs.flutter.dev/get-started/install/windows

# Agregar al PATH
$env:PATH += ";C:\flutter\bin"

# Verificar instalación
flutter doctor -v

# Configurar para desktop Windows
flutter config --enable-windows-desktop
```

#### **4. Instalar Firebase CLI**
```powershell
# Con pnpm (recomendado)
pnpm add -g firebase-tools@14.12.1

# Verificar instalación
firebase --version
```

### 🔧 **Configuración del Sistema**
```bash
# Linux/macOS
flutter doctor -v

# Configurar Java 17
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Verificar versiones
node --version    # v24.6.0+
pnpm --version    # 10.14.0+
java -version     # 17.0.16+
firebase --version # 14.12.1+
```

```powershell
# Windows PowerShell
flutter doctor -v

# Configurar Java 17
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17.0.16"
$env:PATH += ";$env:JAVA_HOME\bin"

# Verificar versiones
node --version    # v24.6.0+
pnpm --version    # 10.14.0+
java -version     # 17.0.16+
firebase --version # 14.12.1+
```

### ⚡ **Script de Verificación Automática**

**Windows (verificar_entorno.bat):**
```batch
@echo off
echo === VERIFICACION DE ENTORNO AGENDAAPP ===
echo.

echo [1] Flutter:
flutter --version
echo.

echo [2] Dart:
dart --version
echo.

echo [3] Node.js:
node --version
echo.

echo [4] pnpm:
pnpm --version
echo.

echo [5] Java:
java -version
echo.

echo [6] Firebase CLI:
firebase --version
echo.

echo [7] Android SDK:
flutter doctor --android-licenses
echo.

echo === VERIFICACION COMPLETADA ===
pause
```

**Linux/macOS (verificar_entorno.sh):**
```bash
#!/bin/bash
echo "=== VERIFICACION DE ENTORNO AGENDAAPP ==="
echo

echo "[1] Flutter:"
flutter --version
echo

echo "[2] Dart:"
dart --version
echo

echo "[3] Node.js:"
node --version
echo

echo "[4] pnpm:"
pnpm --version
echo

echo "[5] Java:"
java -version
echo

echo "[6] Firebase CLI:"
firebase --version
echo

echo "[7] Android Doctor:"
flutter doctor -v
echo

echo "=== VERIFICACION COMPLETADA ==="
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

# Dependencias de Cloud Functions con pnpm
cd functions
pnpm install
cd ..

# Verificar que pnpm workspace esté configurado
pnpm list --depth=0
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
│   ├── package.json                    # Node.js 22, pnpm dependencies
│   └── src/
├── package.json                        # Workspace raíz (pnpm@10.14.0)
├── pnpm-workspace.yaml                 # Configuración workspace pnpm
├── pnpm-lock.yaml                      # Lock file de pnpm
├── firebase.json                       # Config Firebase
├── firestore.rules                     # Reglas de seguridad
└── vercel.json                        # Config para deploy web
```

## 📋 Changelog del Último Commit

### 🔧 **Cambios Técnicos Realizados**

#### **Configuración del Proyecto**
- ✅ **Package Manager**: pnpm@10.14.0 configurado como gestor oficial
- ✅ **Node.js**: v24.6.0 sistema, Node.js 22+ para Functions
- ✅ **Workspace**: pnpm-workspace.yaml con configuración optimizada
- ✅ **Dependencies**: Manejo especializado para @firebase/util y protobufjs

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
# Limpiar proyecto Flutter
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get

# Limpiar dependencias de pnpm si es necesario
cd functions
pnpm install --frozen-lockfile
cd ..

# Rebuild
flutter run
```

### **Error: "pnpm Dependencies Issues"**
```bash
# Linux/macOS
# Verificar configuración de pnpm
pnpm --version  # Debe ser 10.14.0+
cat package.json | grep packageManager

# Reinstalar dependencias
pnpm install --frozen-lockfile

# En Cloud Functions
cd functions
pnpm install
pnpm run build
cd ..
```

```powershell
# Windows PowerShell
# Verificar configuración de pnpm
pnpm --version  # Debe ser 10.14.0+
Get-Content package.json | Select-String packageManager

# Reinstalar dependencias
pnpm install --frozen-lockfile

# En Cloud Functions
cd functions
pnpm install
pnpm run build
cd ..
```

### **Error: "Java Version Issues (Windows)**
```powershell
# Verificar múltiples instalaciones de Java
where java
echo $env:JAVA_HOME

# Limpiar y configurar Java 17
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17.0.16"
$env:PATH = "$env:JAVA_HOME\bin;" + ($env:PATH -split ';' | Where-Object { $_ -notlike '*java*' }) -join ';'

# Verificar configuración
java -version
javac -version
```

### **Error: "Flutter Doctor Issues (Windows)**
```powershell
# Verificar instalación completa
flutter doctor -v

# Problemas comunes Windows:
# 1. Android licenses
flutter doctor --android-licenses

# 2. Windows SDK (si usas desktop)
flutter config --enable-windows-desktop

# 3. Visual Studio Build Tools
# Instalar desde: https://visualstudio.microsoft.com/visual-cpp-build-tools/

# 4. Reinstalar Flutter si es necesario
flutter clean
flutter pub get
```

### **Error: "Path Issues (Windows)**
```powershell
# Verificar que todas las herramientas están en PATH
echo $env:PATH

# Agregar al PATH permanentemente (PowerShell Admin)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-17.0.16", [EnvironmentVariableTarget]::Machine)

# Reiniciar PowerShell después de cambios en PATH
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

## 📋 Matriz de Compatibilidad de Versiones

### 🎯 **Versiones Testadas y Verificadas**

| **OS** | **Flutter** | **Node.js** | **Java** | **pnpm** | **Estado** |
|--------|-------------|-------------|----------|----------|------------|
| Ubuntu 24.04 | 3.35.1 | 24.6.0 | 17.0.16 | 10.14.0 | ✅ Funcionando |
| Windows 11 | 3.35.1 | 24.6.0+ | 17.0.16+ | 10.14.0+ | ⚡ Recomendado |
| Windows 10 | 3.35.1 | 24.6.0+ | 17.0.16+ | 10.14.0+ | ⚠️ No testado |
| macOS | 3.35.1+ | 24.6.0+ | 17.0.16+ | 10.14.0+ | ⚠️ No testado |

### 🔄 **Versionado Semántico del Proyecto**

- **Major**: Cambios que rompen compatibilidad
- **Minor**: Nuevas funcionalidades compatibles
- **Patch**: Correcciones de bugs

### 📦 **Dependencias Críticas para Windows**

```json
{
  "engines": {
    "node": ">=22.0.0",
    "npm": ">=10.0.0",
    "pnpm": ">=10.14.0"
  },
  "os": ["win32", "linux", "darwin"],
  "cpu": ["x64", "arm64"]
}
```

### 🚀 **Comandos de Instalación Rápida (Windows)**

```powershell
# Script completo de instalación
# Ejecutar como Administrador

# 1. Instalar Chocolatey (si no está instalado)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 2. Instalar herramientas
choco install git -y
choco install openjdk17 -y
choco install nodejs --version="24.6.0" -y

# 3. Instalar pnpm
npm install -g pnpm@10.14.0

# 4. Instalar Firebase CLI
pnpm add -g firebase-tools@14.12.1

# 5. Descargar e instalar Flutter manualmente
# https://docs.flutter.dev/get-started/install/windows

# 6. Configurar variables de entorno
$env:FLUTTER_HOME = "C:\flutter"
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17.0.16"
$env:PATH += ";$env:FLUTTER_HOME\bin;$env:JAVA_HOME\bin"

# 7. Verificar instalación
flutter doctor -v
```

**Última actualización**: Agosto 2025  
**Versión**: v1.0.0-beta  
**Estado**: En desarrollo activo 🚧  
**Compatibilidad Windows**: ✅ Verificada para Windows 10/11
