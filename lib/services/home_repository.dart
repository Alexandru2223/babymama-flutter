import 'api_client.dart';
import 'storage_service.dart';
import '../screens/home/home_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeRepository
//
// Single entry point for the GET /api/v1/home endpoint.
// Handles:
//   - Optional babyId query param (multi-baby support, future)
//   - 404 with stale babyId → clears stored id, retries without it
//   - Token refresh is transparent via ApiClient's 401 handling
// ─────────────────────────────────────────────────────────────────────────────

class HomeRepository {
  HomeRepository(this._client, this._storage);

  final ApiClient _client;
  final StorageService _storage;

  Future<HomeResponse> fetch() async {
    final babyId = await _storage.getBabyId();
    final path = babyId != null ? '/home?babyId=$babyId' : '/home';

    try {
      final data = await _client.get(path);
      return HomeResponse.fromJson(data);
    } on ApiException catch (e) {
      // Stale babyId stored on device — clear it and retry without the param.
      if (e.statusCode == 404 && babyId != null) {
        await _storage.clearBabyId();
        final data = await _client.get('/home');
        return HomeResponse.fromJson(data);
      }
      rethrow;
    }
  }
}
