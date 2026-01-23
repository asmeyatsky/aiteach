// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedItem _$FeedItemFromJson(Map<String, dynamic> json) => FeedItem(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  sourceName: json['sourceName'] as String,
  originalUrl: json['originalUrl'] as String,
  summary: json['summary'] as String,
  publishedAt: FeedItem._dateTimeFromJson(json['published_at']),
);

Map<String, dynamic> _$FeedItemToJson(FeedItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'sourceName': instance.sourceName,
  'originalUrl': instance.originalUrl,
  'summary': instance.summary,
  'published_at': FeedItem._dateTimeToJson(instance.publishedAt),
};
