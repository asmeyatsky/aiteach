import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:frontend/providers/gamification_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/presentation/widgets/badges_grid.dart';
import 'package:frontend/presentation/widgets/points_display.dart';
import 'package:frontend/presentation/dialogs/proficiency_selection_dialog.dart';
import 'package:frontend/domain/value_objects/proficiency_level.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final userProfileAsyncValue = ref.watch(userProfileProvider);
    final userBadgesAsyncValue = ref.watch(userBadgesProvider(userId ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Show proficiency selection dialog
              final result = await showDialog<ProficiencyLevel>(
                context: context,
                builder: (context) => const ProficiencySelectionDialog(),
              );
              
              if (result != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proficiency level updated!')),
                );
              }
            },
          ),
        ],
      ),
      body: userId == null
          ? const Center(
              child: Text(
                'Please log in to view your profile',
                style: TextStyle(fontSize: 16),
              ),
            )
          : userProfileAsyncValue.when(
              data: (userProfile) => SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.neonCyan.withOpacity(0.15),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.neonCyan,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userProfile?.username ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProfile?.email ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Proficiency level section
                    _ProficiencySection(),
                    const SizedBox(height: 30),
                    const PointsDisplay(points: 1250),
                    userBadgesAsyncValue.when(
                      data: (userBadges) {
                        return BadgesGrid(userBadges: userBadges);
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text(
                          'Failed to load badges. Please check your internet connection or try again later. Error: $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Failed to load user profile. Please check your internet connection or try again later. Error: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
    );
  }
}

class _ProficiencySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.school, color: AppColors.neonCyan),
                SizedBox(width: 12),
                Text(
                  'Your Learning Path',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neonCyan.withOpacity(0.15)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_graph, color: AppColors.neonCyan),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beginner Level',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neonCyan,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Complete foundational courses to build your AI knowledge',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.neonCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recommended Next Steps:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const _RecommendationItem(
              icon: Icons.book,
              title: 'Introduction to AI Concepts',
              description: 'Learn the fundamentals of artificial intelligence',
              duration: '2 hours',
            ),
            const SizedBox(height: 8),
            const _RecommendationItem(
              icon: Icons.code,
              title: 'Python for Data Science',
              description: 'Master Python programming for AI applications',
              duration: '4 hours',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to proficiency assessment
                  Navigator.of(context).pushNamed('/proficiency-assessment');
                },
                child: const Text('Update Proficiency Level'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String duration;

  const _RecommendationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.neonCyan.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              duration,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.neonCyan,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

