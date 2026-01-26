// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBadgeModel _$UserBadgeModelFromJson(Map<String, dynamic> json) =>
    UserBadgeModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      badgeId: (json['badgeId'] as num).toInt(),
      awardedAt: DateTime.parse(json['awardedAt'] as String),
      badge: BadgeModel.fromJson(json['badge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserBadgeModelToJson(UserBadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'badgeId': instance.badgeId,
      'awardedAt': instance.awardedAt.toIso8601String(),
      'badge': instance.badge,
    };
