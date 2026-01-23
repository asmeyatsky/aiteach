import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'feed_item_model.g.dart';

@JsonSerializable()
class FeedItem {
  final int id;
  final String title;
  final String sourceName;
  final String originalUrl;
  final String summary;
  @JsonKey(
    name: 'published_at',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime publishedAt;

  FeedItem({
    required this.id,
    required this.title,
    required this.sourceName,
    required this.originalUrl,
    required this.summary,
    required this.publishedAt,
  });

  static DateTime _dateTimeFromJson(dynamic timestamp) {
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime date) {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(date);
  }

  factory FeedItem.fromJson(Map<String, dynamic> json) => _$FeedItemFromJson(json);
  Map<String, dynamic> toJson() => _$FeedItemToJson(this);
}