import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/badge.dart';

part 'user_badge.g.dart';

@JsonSerializable()
class UserBadge {
  UserBadge({
    required this.userId,
    required this.badgeId,
    required this.awardedAt,
    required this.badge,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) => _$UserBadgeFromJson(json);
  Map<String, dynamic> toJson() => _$UserBadgeToJson(this);

  final int userId;
  final int badgeId;
  final DateTime awardedAt;
  final Badge badge;
}
