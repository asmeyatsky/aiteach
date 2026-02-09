import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ExternalLinkWidget extends StatelessWidget {
  final String contentDataJson;

  const ExternalLinkWidget({super.key, required this.contentDataJson});

  @override
  Widget build(BuildContext context) {
    try {
      final data = jsonDecode(contentDataJson) as Map<String, dynamic>;
      final title = data['title'] as String? ?? '';
      final provider = data['provider'] as String? ?? '';
      final url = data['url'] as String? ?? '';
      final description = data['description'] as String? ?? '';
      final estimatedMinutes = data['estimated_minutes'] as int? ?? 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Provider badge + duration
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (provider.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neonBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school,
                          size: 14, color: AppColors.neonBlue),
                      const SizedBox(width: 4),
                      Text(
                        provider,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.neonBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (estimatedMinutes > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.neonCyan),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(estimatedMinutes),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.neonCyan,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          if (description.isNotEmpty) ...[
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Open Course button
          if (url.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: Text('Open on $provider'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reminder note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.neonCyan.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: AppColors.neonCyan),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'After completing the external content, return here and mark as complete.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.neonCyan,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Unable to load external link content.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
  }

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '${h}h ${m}m' : '${h}h';
    }
    return '$minutes min';
  }
}
