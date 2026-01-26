import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/screens/project_detail_screen.dart';
import 'package:frontend/providers/project_provider.dart';

class ProjectListScreen extends ConsumerWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project-Based Learning'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: projectsAsync.when(
        data: (projects) => RefreshIndicator(
          onRefresh: () => ref.refresh(projectsProvider.future),
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(project.title),
                  subtitle: Text('${project.track} • ${project.difficulty} • ${project.description.substring(0, min(100, project.description.length))}...'),
                  trailing: Chip(
                    label: Text(
                      project.difficulty.toUpperCase(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: _getDifficultyColor(project.difficulty),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailScreen(project: project),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading projects: $error'),
              ElevatedButton(
                onPressed: () => ref.refresh(projectsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'hard':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}