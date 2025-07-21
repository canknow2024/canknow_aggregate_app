plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.canknow.canknow_aggregate_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.canknow.canknow_aggregate_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["JPUSH_PKGNAME"] = applicationId.toString()
        manifestPlaceholders["JPUSH_APPKEY"] = "8400711789178fdf51f6bb60"
        manifestPlaceholders["JPUSH_CHANNEL"] = "developer-default"
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("canknow.keystore")
            storePassword = "lianhubo"
            keyAlias = "canknow"
            keyPassword = "lianhubo"
        }
        create("release") {
            storeFile = file("canknow.keystore")
            storePassword = "lianhubo"
            keyAlias = "canknow"
            keyPassword = "lianhubo"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

// 解决Kotlin增量编译问题
tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs += listOf("-Xskip-prerelease-check")
    }
}
