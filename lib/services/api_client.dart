import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  static const _base = 'http://10.0.2.2:3000/api/v1';

  ApiClient(this._storage);

  final StorageService _storage;
  final _http = http.Client();

  // ── Public surface ────────────────────────────

  /// Authenticated GET (access token, auto-refreshes on 401).
  Future<Map<String, dynamic>> get(String path) =>
      _send('GET', path, null, _TokenType.access);

  /// Authenticated POST (access token, auto-refreshes on 401).
  Future<Map<String, dynamic>> post(String path, [Map<String, dynamic>? body]) =>
      _send('POST', path, body, _TokenType.access);

  /// Authenticated PUT (access token, auto-refreshes on 401).
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) =>
      _send('PUT', path, body, _TokenType.access);

  /// Unauthenticated POST (register, login).
  Future<Map<String, dynamic>> postPublic(
    String path,
    Map<String, dynamic> body,
  ) =>
      _send('POST', path, body, _TokenType.none);

  /// POST that sends the *refresh* token (logout).
  Future<Map<String, dynamic>> postWithRefreshToken(String path) =>
      _send('POST', path, null, _TokenType.refresh);

  // ── Internals ─────────────────────────────────

  Future<Map<String, dynamic>> _send(
    String method,
    String path,
    Map<String, dynamic>? body,
    _TokenType tokenType, {
    bool isRetry = false,
  }) async {
    final token = await _resolveToken(tokenType);
    final response = await _raw(method, path, body, token);

    if (response.statusCode == 401 &&
        tokenType == _TokenType.access &&
        !isRetry) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        throw const ApiException(401, 'Sesiunea a expirat');
      }

      final refreshResp =
          await _raw('POST', '/auth/refresh', null, refreshToken);

      if (refreshResp.statusCode == 200) {
        final data =
            jsonDecode(refreshResp.body) as Map<String, dynamic>;
        await _storage.saveTokens(
          data['accessToken'] as String,
          data['refreshToken'] as String,
        );
        final retryResp =
            await _raw(method, path, body, data['accessToken'] as String);
        return _parse(retryResp);
      } else {
        await _storage.clearTokens();
        throw const ApiException(
            401, 'Sesiunea a expirat. Te rog autentifică-te din nou.');
      }
    }

    return _parse(response);
  }

  Future<String?> _resolveToken(_TokenType type) {
    return switch (type) {
      _TokenType.access => _storage.getAccessToken(),
      _TokenType.refresh => _storage.getRefreshToken(),
      _TokenType.none => Future.value(null),
    };
  }

  Future<http.Response> _raw(
    String method,
    String path,
    Map<String, dynamic>? body,
    String? token,
  ) {
    final uri = Uri.parse('$_base$path');
    final headers = <String, String>{
      if (body != null) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final encoded = body != null ? jsonEncode(body) : null;

    return switch (method) {
      'GET' => _http.get(uri, headers: headers),
      'POST' => _http.post(uri, headers: headers, body: encoded),
      'PUT' => _http.put(uri, headers: headers, body: encoded),
      _ => throw ArgumentError('Unsupported method: $method'),
    };
  }

  Map<String, dynamic> _parse(http.Response response) {
    if (response.statusCode == 204) return {};

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded as Map<String, dynamic>;
    }

    final errBody = decoded as Map<String, dynamic>;
    final raw = errBody['message'];
    final msg = raw is List
        ? raw.join(', ')
        : (raw as String? ?? 'Eroare necunoscută');
    throw ApiException(response.statusCode, msg);
  }
}

enum _TokenType { access, refresh, none }
