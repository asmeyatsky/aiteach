import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge {
  Badge({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  final int id;
  final String name;
  final String description;
  final String? iconUrl;
}
