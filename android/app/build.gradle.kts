import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use {
        localProperties.load(it)
    }
}

android {
    namespace = "com.baroallgi.baroallgi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // 기존 toString() 에러 방지를 위해 문자열로 직접 지정
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.baroallgi.baroallgi"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 중요: Kotlin DSL(.kts)에서는 아래와 같이 mapOf를 사용해야 합니다.
        manifestPlaceholders += mapOf(
            "applicationName" to (localProperties.getProperty("applicationName") ?: "")
        )
    }

    buildTypes {
        getByName("release") {
            // release 빌드 시에도 일단 debug 키 사용 (필요 시 수정)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}