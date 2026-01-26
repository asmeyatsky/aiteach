import 'package:dio/dio.dart';
import 'package:frontend/data/models/project_model.dart';

class ProjectApiService {
  final Dio _dio;

  ProjectApiService(this._dio);

  Future<List<Project>> getProjects({int skip = 0, int limit = 100}) async {
    final response = await _dio.get('/projects/', queryParameters: {
      'skip': skip,
      'limit': limit,
    });
    
    return (response.data as List)
        .map((json) => Project.fromJson(json))
        .toList();
  }

  Future<Project> getProject(int projectId) async {
    final response = await _dio.get('/projects/$projectId');
    return Project.fromJson(response.data);
  }

  Future<UserProject> submitProject(int projectId, String submissionUrl) async {
    final response = await _dio.post('/projects/$projectId/submit', data: {
      'submission_url': submissionUrl
    });
    return UserProject.fromJson(response.data);
  }

  Future<List<UserProject>> getMyProjects() async {
    final response = await _dio.get('/projects/me/');
    return (response.data as List)
        .map((json) => UserProject.fromJson(json))
        .toList();
  }
}