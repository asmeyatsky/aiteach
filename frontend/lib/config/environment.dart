import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class EnvironmentConfig {
  // Compile-time constants from --dart-define
  static const String _envOverride =
      String.fromEnvironment('ENVIRONMENT');
  static const String _backendUrlOverride =
      String.fromEnvironment('BACKEND_URL');

  static Environment get currentEnvironment {
    if (_envOverride.isNotEmpty) {
      switch (_envOverride) {
        case 'staging':
          return Environment.staging;
        case 'production':
          return Environment.production;
        default:
          return Environment.development;
      }
    }
    return kDebugMode ? Environment.development : Environment.production;
  }

  static String get apiBaseUrl {
    if (_backendUrlOverride.isNotEmpty) return _backendUrlOverride;
    switch (currentEnvironment) {
      case Environment.development:
        return 'http://localhost:8000';
      case Environment.staging:
        return 'https://aiteach-backend-stage-186667783026.europe-west2.run.app';
      case Environment.production:
        return 'https://api.aiteach.app';
    }
  }

  static String get websiteUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging.aiteach.app';
      case Environment.production:
        return 'https://aiteach.app';
    }
  }

  static bool get isProduction => currentEnvironment == Environment.production;
  static bool get isDevelopment =>
      currentEnvironment == Environment.development;
  static bool get enableLogging => !isProduction;

  // Feature flags
  static bool get enableAnalytics => isProduction;
  static bool get enableCrashReporting => isProduction;
  static bool get showDebugInfo => isDevelopment;

  // API timeouts
  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);

  // Cache settings
  static Duration get cacheExpiry => const Duration(hours: 1);
  static int get maxCacheSize => 50 * 1024 * 1024; // 50MB
}
