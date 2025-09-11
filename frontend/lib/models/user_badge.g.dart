// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBadge _$UserBadgeFromJson(Map<String, dynamic> json) => UserBadge(
  userId: (json['userId'] as num).toInt(),
  badgeId: (json['badgeId'] as num).toInt(),
  awardedAt: DateTime.parse(json['awardedAt'] as String),
  badge: Badge.fromJson(json['badge'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserBadgeToJson(UserBadge instance) => <String, dynamic>{
  'userId': instance.userId,
  'badgeId': instance.badgeId,
  'awardedAt': instance.awardedAt.toIso8601String(),
  'badge': instance.badge,
};
