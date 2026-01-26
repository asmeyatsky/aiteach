import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/api/suggestion_api_service.dart';
import 'package:frontend/data/models/suggestion_model.dart';
import 'package:frontend/providers/auth_provider.dart';

final suggestionApiServiceProvider = Provider<SuggestionApiService>((ref) {
  return SuggestionApiService(ref.read(dioProvider));
});

final createSuggestionProvider = FutureProvider.autoDispose.family<SuggestedContent, SuggestedContentCreate>((ref, suggestion) async {
  final apiService = ref.watch(suggestionApiServiceProvider);
  return await apiService.createSuggestion(suggestion);
});