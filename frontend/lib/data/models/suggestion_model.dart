import 'package:json_annotation/json_annotation.dart';

part 'suggestion_model.g.dart';

@JsonSerializable()
class SuggestedContent {
  final int id;
  final int userId;
  final String url;
  final String? comment;
  final String suggestedTrack; // user, builder, innovator
  final String status; // pending, approved, rejected

  SuggestedContent({
    required this.id,
    required this.userId,
    required this.url,
    this.comment,
    required this.suggestedTrack,
    required this.status,
  });

  factory SuggestedContent.fromJson(Map<String, dynamic> json) => _$SuggestedContentFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestedContentToJson(this);
}

@JsonSerializable()
class SuggestedContentCreate {
  final String url;
  final String? comment;
  final String suggestedTrack;

  SuggestedContentCreate({
    required this.url,
    this.comment,
    required this.suggestedTrack,
  });

  factory SuggestedContentCreate.fromJson(Map<String, dynamic> json) => _$SuggestedContentCreateFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestedContentCreateToJson(this);
}