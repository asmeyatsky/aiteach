// frontend/lib/data/repositories/course_repository_impl.dart
import 'package:frontend/data/datasources/course_api_data_source.dart';
import 'package:frontend/data/mappers/course_mapper.dart';
import 'package:frontend/data/mappers/lesson_mapper.dart';
import 'package:frontend/domain/entities/course.dart';
import 'package:frontend/domain/entities/lesson.dart';
import 'package:frontend/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseApiDataSource apiDataSource;

  CourseRepositoryImpl(this.apiDataSource);

  @override
  Future<List<Course>> getCourses() async {
    final courseModels = await apiDataSource.getCourses();
    return courseModels.map((model) => CourseMapper.fromModel(model)).toList();
  }

  @override
  Future<Course> getCourseDetails(int courseId) async {
    final courseModel = await apiDataSource.getCourseDetails(courseId);
    return CourseMapper.fromModel(courseModel);
  }

  @override
  Future<Course> createCourse(String title, String description, String tier, String? thumbnailUrl) async {
    final courseModel = await apiDataSource.createCourse(title, description, tier, thumbnailUrl);
    return CourseMapper.fromModel(courseModel);
  }

  @override
  Future<Lesson> createLesson(int courseId, String title, String contentType, String contentData, int order) async {
    final lessonModel = await apiDataSource.createLesson(courseId, title, contentType, contentData, order);
    return LessonMapper.fromModel(lessonModel);
  }

  @override
  Future<List<Lesson>> getLessonsByCourse(int courseId) async {
    final lessonModels = await apiDataSource.getLessonsByCourse(courseId);
    return lessonModels.map((model) => LessonMapper.fromModel(model)).toList();
  }
}
