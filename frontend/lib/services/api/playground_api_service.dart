import 'package:dio/dio.dart';

class PlaygroundApiService {
  final Dio _dio;

  PlaygroundApiService(this._dio);

  Future<Map<String, dynamic>> chatWithAi(String prompt) async {
    final response = await _dio.post('/playground/chat', data: {
      'prompt': prompt
    });
    return response.data;
  }
}