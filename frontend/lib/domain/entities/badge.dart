// frontend/lib/domain/entities/badge.dart
import 'package:equatable/equatable.dart';

class Badge extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
  });

  @override
  List<Object?> get props => [id, name, description, iconUrl];
}
