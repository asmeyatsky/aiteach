import 'package:json_annotation/json_annotation.dart';

part 'badge_model.g.dart';

@JsonSerializable()
class BadgeModel {
  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) => _$BadgeModelFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeModelToJson(this);

  final int id;
  final String name;
  final String description;
  final String? iconUrl;
}
