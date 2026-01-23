import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/feed_api_service.dart';
import '../models/feed_item_model.dart';

final feedApiServiceProvider = Provider<FeedApiService>((ref) {
  throw UnimplementedError();
});

final feedItemsProvider = FutureProvider.autoDispose<List<FeedItem>>((ref) async {
  final apiService = ref.watch(feedApiServiceProvider);
  return await apiService.getFeed();
});