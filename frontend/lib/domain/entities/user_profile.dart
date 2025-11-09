// frontend/lib/domain/entities/user_profile.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/user_proficiency.dart'; // Assuming UserProficiency entity exists

class UserProfile extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final List<UserProficiency> proficiencies; // Assuming proficiencies are loaded with the profile

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.createdAt,
    this.proficiencies = const [],
  });

  @override
  List<Object?> get props => [id, username, email, profilePictureUrl, createdAt, proficiencies];
}
