import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/entities/course.dart';
import 'package:frontend/domain/entities/lesson.dart';
import 'package:frontend/data/datasources/course_api_data_source.dart';
import 'package:frontend/data/repositories/course_repository_impl.dart';
import 'package:frontend/providers/auth_provider.dart'; // To get Dio instance
import 'package:frontend/data/mappers/lesson_mapper.dart';
import 'package:frontend/data/models/lesson_model.dart';

final courseApiDataSourceProvider = Provider<CourseApiDataSource>((ref) {
  return CourseApiDataSource(ref.read(dioProvider));
});

final courseRepositoryProvider = Provider<CourseRepositoryImpl>((ref) {
  return CourseRepositoryImpl(ref.read(courseApiDataSourceProvider));
});

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  final courseRepository = ref.read(courseRepositoryProvider);
  return courseRepository.getCourses();
});

final courseProvider = FutureProvider.family<Course, int>((ref, courseId) async {
  final courseRepository = ref.read(courseRepositoryProvider);
  return courseRepository.getCourseDetails(courseId);
});

final lessonsByCourseProvider = FutureProvider.family<List<LessonModel>, int>((ref, courseId) async {
  final courseRepository = ref.read(courseRepositoryProvider);
  final lessons = await courseRepository.getLessonsByCourse(courseId);
  return lessons.map((lesson) => LessonMapper.toModel(lesson)).toList();
});