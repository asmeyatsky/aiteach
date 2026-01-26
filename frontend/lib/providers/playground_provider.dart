// frontend/lib/providers/playground_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/api/playground_api_service.dart';
import 'package:frontend/providers/auth_provider.dart';

final playgroundApiServiceProvider = Provider<PlaygroundApiService>((ref) {
  return PlaygroundApiService(ref.read(dioProvider));
});

final chatHistoryProvider = StateProvider<List<Map<String, String>>>((ref) {
  return [];
});

final isChatLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final chatWithAiProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, prompt) async {
  final apiService = ref.watch(playgroundApiServiceProvider);
  return await apiService.chatWithAi(prompt);
});