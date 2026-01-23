import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/playground_api_service.dart';

final playgroundApiServiceProvider = Provider<PlaygroundApiService>((ref) {
  throw UnimplementedError();
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