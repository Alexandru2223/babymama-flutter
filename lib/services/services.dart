export 'storage_service.dart';
export 'api_client.dart';
export 'auth_service.dart';
export 'onboarding_service.dart';

import 'storage_service.dart';
import 'api_client.dart';
import 'auth_service.dart';
import 'onboarding_service.dart';

// Lazy singletons — shared across the app.
final storageService = StorageService();
final apiClient = ApiClient(storageService);
final authService = AuthService(apiClient, storageService);
final onboardingService = OnboardingService(apiClient);
