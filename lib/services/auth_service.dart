import 'api_client.dart';
import 'storage_service.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    required this.onboardingCompleted,
  });

  final String id;
  final String email;
  final String? fullName;
  final bool onboardingCompleted;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        fullName: json['fullName'] as String?,
        onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      );
}

class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final UserModel user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}

class AuthService {
  AuthService(this._client, this._storage);

  final ApiClient _client;
  final StorageService _storage;

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final data = await _client.postPublic('/auth/register', {
      'email': email,
      'password': password,
      if (fullName != null && fullName.isNotEmpty) 'fullName': fullName,
    });
    final resp = AuthResponse.fromJson(data);
    await _storage.saveTokens(resp.accessToken, resp.refreshToken);
    return resp;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final data = await _client.postPublic('/auth/login', {
      'email': email,
      'password': password,
    });
    final resp = AuthResponse.fromJson(data);
    await _storage.saveTokens(resp.accessToken, resp.refreshToken);
    return resp;
  }

  Future<void> logout() async {
    await _client.postWithRefreshToken('/auth/logout');
    await _storage.clearTokens();
  }

  Future<UserModel> me() async {
    final data = await _client.get('/auth/me');
    return UserModel.fromJson(data);
  }
}
