import 'api_client.dart';

class OnboardingSnapshot {
  const OnboardingSnapshot({
    required this.babyName,
    required this.interests,
    required this.communities,
  });

  final String? babyName;
  final Set<String> interests;
  final Set<String> communities;

  factory OnboardingSnapshot.fromJson(Map<String, dynamic> json) {
    final prefs = json['preferences'] as Map<String, dynamic>? ?? {};
    final babies = json['babies'] as List<dynamic>? ?? [];
    final baby =
        babies.isNotEmpty ? babies.first as Map<String, dynamic> : null;

    return OnboardingSnapshot(
      babyName: baby?['firstName'] as String?,
      interests: Set<String>.from(prefs['mainInterests'] as List? ?? []),
      communities:
          Set<String>.from(prefs['joinedCommunities'] as List? ?? []),
    );
  }
}

class OnboardingService {
  OnboardingService(this._client);

  final ApiClient _client;

  Future<void> savePreferences(Map<String, dynamic> prefs) =>
      _client.put('/onboarding/preferences', prefs);

  Future<void> createBaby({
    required String firstName,
    required DateTime birthDate,
    int? birthWeightGrams,
    String? gender, // 'MALE' | 'FEMALE' | 'OTHER'
    bool isPremature = false,
  }) {
    final body = <String, dynamic>{
      'firstName': firstName,
      'birthDate': '${birthDate.year.toString().padLeft(4, '0')}-'
          '${birthDate.month.toString().padLeft(2, '0')}-'
          '${birthDate.day.toString().padLeft(2, '0')}',
      'isPremature': isPremature,
    };
    if (birthWeightGrams != null) body['birthWeight'] = birthWeightGrams;
    if (gender != null) body['gender'] = gender;
    return _client.post('/onboarding/baby', body);
  }

  Future<OnboardingSnapshot> complete() async {
    final data = await _client.post('/onboarding/complete');
    return OnboardingSnapshot.fromJson(data);
  }
}
