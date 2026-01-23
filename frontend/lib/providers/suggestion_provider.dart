import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/suggestion_api_service.dart';
import '../models/suggestion_model.dart';

final suggestionApiServiceProvider = Provider<SuggestionApiService>((ref) {
  throw UnimplementedError();
});

final createSuggestionProvider = FutureProvider.autoDispose.family<SuggestedContent, SuggestedContentCreate>((ref, suggestion) async {
  final apiService = ref.watch(suggestionApiServiceProvider);
  return await apiService.createSuggestion(suggestion);
});