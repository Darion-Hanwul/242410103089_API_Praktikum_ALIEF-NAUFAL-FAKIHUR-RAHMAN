import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'https://task.itprojects.web.id';
  static const String loginEndpoint = '/api/auth/login';
  static const String productsEndpoint = '/api/products';
  static const String submitEndpoint = '/api/products/submit';
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String username = 'username';
}

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color background = Color(0xFFF9FAFB);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
}