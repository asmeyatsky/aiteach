// frontend/lib/domain/entities/user_proficiency.dart
import 'package:equatable/equatable.dart';

class UserProficiency extends Equatable {
  final int id;
  final int userId;
  final String skill;
  final int level;

  const UserProficiency({
    required this.id,
    required this.userId,
    required this.skill,
    required this.level,
  });

  @override
  List<Object?> get props => [id, userId, skill, level];
}
