import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rifino/features/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingResponseService {
  const OnboardingResponseService();

  static const _databaseUrl =
      'https://rifino-8a0ef-default-rtdb.europe-west1.firebasedatabase.app';
  static const _anonymousUserIdKey = 'rifino.anonymous.user.id';

  Future<void> saveResponse(OnboardingProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    final userId = _getOrCreateUserId(preferences);
    final now = DateTime.now().millisecondsSinceEpoch;

    final response = {
      'userId': userId,
      'source': profile.source,
      'level': profile.level,
      'reason': profile.reason,
      'goal': profile.goal,
      'notificationsEnabled': profile.notificationsEnabled,
      'createdAt': now,
    };

    final uri = Uri.parse('$_databaseUrl/onboardingResponses.json');
    final result = await http
        .post(
          uri,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(response),
        )
        .timeout(const Duration(seconds: 8));

    if (result.statusCode < 200 || result.statusCode >= 300) {
      throw Exception('Realtime Database error: ${result.statusCode}');
    }
  }

  String _getOrCreateUserId(SharedPreferences preferences) {
    final existingUserId = preferences.getString(_anonymousUserIdKey);
    if (existingUserId != null) return existingUserId;

    final userId = 'anonymous_${DateTime.now().microsecondsSinceEpoch}';
    preferences.setString(_anonymousUserIdKey, userId);
    return userId;
  }
}
