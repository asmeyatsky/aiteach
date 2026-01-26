import 'package:frontend/data/models/feed_item_model.dart';

final mockFeedItems = [
  FeedItem(
    id: 1,
    title: 'Feed Item 1 Title',
    sourceName: 'Source 1',
    originalUrl: 'https://example.com/item1',
    summary: 'Summary of feed item 1',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  FeedItem(
    id: 2,
    title: 'Feed Item 2 Title',
    sourceName: 'Source 2',
    originalUrl: 'https://example.com/item2',
    summary: 'Summary of feed item 2',
    publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
];