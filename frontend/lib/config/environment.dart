import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class EnvironmentConfig {
  static const Environment _currentEnvironment = kDebugMode
      ? Environment.development
      : Environment.production;

  static Environment get currentEnvironment => _currentEnvironment;

  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'http://localhost:8000';
      case Environment.staging:
        return 'https://aiteach-backend-staging-xyz.run.app';
      case Environment.production:
        return 'https://api.aiteach.app';
    }
  }

  static String get websiteUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging.aiteach.app';
      case Environment.production:
        return 'https://aiteach.app';
    }
  }

  static bool get isProduction => _currentEnvironment == Environment.production;
  static bool get isDevelopment => _currentEnvironment == Environment.development;
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