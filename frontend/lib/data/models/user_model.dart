import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  final int id;
  final String username;
  final String email;
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
}
