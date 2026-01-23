// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestedContent _$SuggestedContentFromJson(Map<String, dynamic> json) =>
    SuggestedContent(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      url: json['url'] as String,
      comment: json['comment'] as String?,
      suggestedTrack: json['suggestedTrack'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$SuggestedContentToJson(SuggestedContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'url': instance.url,
      'comment': instance.comment,
      'suggestedTrack': instance.suggestedTrack,
      'status': instance.status,
    };

SuggestedContentCreate _$SuggestedContentCreateFromJson(
  Map<String, dynamic> json,
) => SuggestedContentCreate(
  url: json['url'] as String,
  comment: json['comment'] as String?,
  suggestedTrack: json['suggestedTrack'] as String,
);

Map<String, dynamic> _$SuggestedContentCreateToJson(
  SuggestedContentCreate instance,
) => <String, dynamic>{
  'url': instance.url,
  'comment': instance.comment,
  'suggestedTrack': instance.suggestedTrack,
};
