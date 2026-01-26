import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/api/project_api_service.dart';
import 'package:frontend/data/models/project_model.dart'; // Keep this import as it defines Project and UserProject
import 'package:frontend/providers/auth_provider.dart';

final projectApiServiceProvider = Provider<ProjectApiService>((ref) {
  return ProjectApiService(ref.read(dioProvider));
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