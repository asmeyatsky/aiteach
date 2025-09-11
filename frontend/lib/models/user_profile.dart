import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  final int id;
  final String username;
  final String email;
  final String? profilePictureUrl;
  final DateTime createdAt;
}
