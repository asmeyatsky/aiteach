import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/project_api_service.dart';
import '../models/project_model.dart';

final projectApiServiceProvider = Provider<ProjectApiService>((ref) {
  throw UnimplementedError();
});

final projectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  final apiService = ref.watch(projectApiServiceProvider);
  return await apiService.getProjects();
});

final projectDetailProvider = FutureProvider.family<Project, int>((ref, projectId) async {
  final apiService = ref.watch(projectApiServiceProvider);
  return await apiService.getProject(projectId);
});

final myProjectsProvider = FutureProvider.autoDispose<List<UserProject>>((ref) async {
  final apiService = ref.watch(projectApiServiceProvider);
  return await apiService.getMyProjects();
});