import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/data/models/user_proficiency_model.dart'; // Import the new model

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.createdAt,
    this.proficiencies, // Add proficiencies to constructor
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  final int id;
  final String username;
  final String email;
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final List<UserProficiencyModel>? proficiencies; // Add proficiencies field
}
