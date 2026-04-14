import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _accessKey = 'babymama_access_token';
  static const _refreshKey = 'babymama_refresh_token';
  static const _babyIdKey = 'babymama_active_baby_id';

  final _store = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveTokens(String accessToken, String refreshToken) =>
      Future.wait([
        _store.write(key: _accessKey, value: accessToken),
        _store.write(key: _refreshKey, value: refreshToken),
      ]);

  Future<String?> getAccessToken() => _store.read(key: _accessKey);
  Future<String?> getRefreshToken() => _store.read(key: _refreshKey);

  Future<void> clearTokens() => Future.wait([
        _store.delete(key: _accessKey),
        _store.delete(key: _refreshKey),
      ]);

  Future<void> saveBabyId(String babyId) =>
      _store.write(key: _babyIdKey, value: babyId);
  Future<String?> getBabyId() => _store.read(key: _babyIdKey);
  Future<void> clearBabyId() => _store.delete(key: _babyIdKey);
}
