import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/course_service.dart';
import 'package:frontend/models/course.dart';
import 'package:frontend/models/lesson.dart';
import 'package:frontend/providers/auth_provider.dart';

final courseServiceProvider = Provider<CourseService>((ref) {
  final authService = ref.read(authServiceProvider);
  return CourseService(authService);
});

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  final courseService = ref.read(courseServiceProvider);
  return courseService.getCourses();
});

final courseProvider = FutureProvider.family<Course, int>((ref, courseId) async {
  final courseService = ref.read(courseServiceProvider);
  final courses = await courseService.getCourses();
  return courses.firstWhere((course) => course.id == courseId);
});

final lessonsByCourseProvider = FutureProvider.family<List<Lesson>, int>((ref, courseId) async {
  final courseService = ref.read(courseServiceProvider);
  return courseService.getLessonsByCourse(courseId);
});
