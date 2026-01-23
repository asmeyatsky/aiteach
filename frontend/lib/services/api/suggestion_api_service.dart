import 'package:dio/dio.dart';
import '../models/suggestion_model.dart';

class SuggestionApiService {
  final Dio _dio;

  SuggestionApiService(this._dio);

  Future<SuggestedContent> createSuggestion(SuggestedContentCreate suggestion) async {
    final response = await _dio.post('/suggestions/', data: suggestion.toJson());
    return SuggestedContent.fromJson(response.data);
  }
}