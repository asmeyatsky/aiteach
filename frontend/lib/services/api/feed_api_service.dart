import 'package:dio/dio.dart';
import 'package:frontend/data/models/feed_item_model.dart';

class FeedApiService {
  final Dio _dio;

  FeedApiService(this._dio);

  Future<List<FeedItem>> getFeedItems({int skip = 0, int limit = 20}) async {
    final response = await _dio.get('/feed/', queryParameters: {
      'skip': skip,
      'limit': limit,
    });
    
    return (response.data as List)
        .map((json) => FeedItem.fromJson(json))
        .toList();
  }
}