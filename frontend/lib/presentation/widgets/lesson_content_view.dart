import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/presentation/widgets/quiz_widget.dart';

class LessonContentView extends StatelessWidget {
  final String contentType;
  final String contentData;

  const LessonContentView({
    super.key,
    required this.contentType,
    required this.contentData,
  });

  @override
  Widget build(BuildContext context) {
    switch (contentType.toLowerCase()) {
      case 'text':
      case 'markdown':
        return _buildTextContent(contentData);
      case 'video':
        return _buildVideoContent(contentData);
      case 'quiz':
        return _buildQuizContent(contentData);
      default:
        return _buildTextContent(contentData);
    }
  }

  Widget _buildTextContent(String content) {
    return MarkdownBody(
      data: content,
      onTapLink: (text, href, title) async {
        if (href != null) {
          final uri = Uri.parse(href);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
    );
  }

  Widget _buildVideoContent(String content) {
    // For video content, we expect a URL to a video
    // This could be a YouTube URL, Vimeo URL, or direct video file URL
    try {
      final uri = Uri.parse(content);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Video Lesson',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.textPrimary,
                    size: 60,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Watch Video',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    uri.host,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SelectableText(
            'Video URL: $content',
            style: TextStyle(fontSize: 12, color: AppColors.neonCyan),
          ),
        ],
      );
    } catch (e) {
      return Text('Invalid video URL: $content');
    }
  }

  Widget _buildQuizContent(String content) {
    return QuizWidget(quizDataJson: content);
  }
}