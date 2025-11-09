// frontend/lib/domain/repositories/course_repository.dart
import 'package:frontend/domain/entities/course.dart';
import 'package:frontend/domain/entities/lesson.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourseDetails(int courseId);
  Future<Course> createCourse(String title, String description, String tier, String? thumbnailUrl);
  Future<Lesson> createLesson(int courseId, String title, String contentType, String contentData, int order);
  Future<List<Lesson>> getLessonsByCourse(int courseId);
}
