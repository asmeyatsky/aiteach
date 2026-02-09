// frontend/lib/domain/entities/course.dart
import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final int id;
  final String title;
  final String description;
  final String tier;
  final String? thumbnailUrl;
  final String? provider;
  final String? url;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.tier,
    this.thumbnailUrl,
    this.provider,
    this.url,
  });

  @override
  List<Object?> get props => [id, title, description, tier, thumbnailUrl, provider, url];
}
