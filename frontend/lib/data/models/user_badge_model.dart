import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/data/models/badge_model.dart';

part 'user_badge_model.g.dart';

@JsonSerializable()
class UserBadgeModel {
  UserBadgeModel({
    required this.userId,
    required this.badgeId,
    required this.awardedAt,
    required this.badge,
  });

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) => _$UserBadgeModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserBadgeModelToJson(this);

  final int userId;
  final int badgeId;
  final DateTime awardedAt;
  final BadgeModel badge;
}
