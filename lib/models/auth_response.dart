class AuthResponse {
  final bool success;
  final String? message;
  final AuthData? data;

  AuthResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

class AuthData {
  final String token;
  final User? user;

  AuthData({
    required this.token,
    this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final String username;
  final String? name;

  User({
    required this.username,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      name: json['name'],
    );
  }
}