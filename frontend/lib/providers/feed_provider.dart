import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/feed_item_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api/feed_api_service.dart';

final feedApiServiceProvider = Provider<FeedApiService>((ref) {
  return FeedApiService(ref.read(dioProvider));
});

final feedItemsProvider = FutureProvider.autoDispose<List<FeedItem>>((ref) async {
  final apiService = ref.watch(feedApiServiceProvider);
  return apiService.getFeedItems();
});