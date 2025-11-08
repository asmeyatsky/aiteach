// frontend/lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? profilePictureUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, username, email, profilePictureUrl, createdAt];
}
