// Configuración de build a nivel de proyecto para Flutter con Java 17
// Compatible con Android Gradle Plugin 8.2.x y Kotlin 1.9.x

buildscript {
    // Versión de Kotlin compatible con Java 17 y AGP 8.2
    val kotlinVersion by extra("1.9.22")
    
    repositories {
        google()
        mavenCentral()
        // Repositorio específico para plugins de Gradle
        gradlePluginPortal()
    }
    
    dependencies {
        // Android Gradle Plugin - versión estable compatible con Java 17
        classpath("com.android.tools.build:gradle:8.2.2")
        
        // Plugin de Kotlin compatible con la versión de Kotlin especificada
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        
        // Google Services para Firebase - versión estable
        classpath("com.google.gms:google-services:4.4.0")
    }
}

// Configuración para todos los proyectos y subproyectos
allprojects {
    repositories {
        google()
        mavenCentral()
        
        // Repositorio adicional para dependencias de Flutter
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}

// Configuración estándar de Flutter sin reubicación de directorios
// Esto evita referencias circulares y mantiene la estructura por defecto

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
