import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/presentation/widgets/quiz_widget.dart';
import 'package:frontend/presentation/widgets/youtube_video_widget.dart';
import 'package:frontend/presentation/widgets/lab_widget.dart';
import 'package:frontend/presentation/widgets/external_link_widget.dart';

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
        return YouTubeVideoWidget(contentDataJson: contentData);
      case 'quiz':
        return QuizWidget(quizDataJson: contentData);
      case 'lab':
        return LabWidget(contentDataJson: contentData);
      case 'external':
        return ExternalLinkWidget(contentDataJson: contentData);
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
}