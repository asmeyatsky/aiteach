import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
import 'dart:convert';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeVideoWidget extends StatefulWidget {
  final String contentDataJson;

  const YouTubeVideoWidget({super.key, required this.contentDataJson});

  @override
  State<YouTubeVideoWidget> createState() => _YouTubeVideoWidgetState();
}

class _YouTubeVideoWidgetState extends State<YouTubeVideoWidget> {
  late YoutubePlayerController _controller;
  String _title = '';
  String _description = '';
  int _durationMinutes = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    try {
      final data = jsonDecode(widget.contentDataJson) as Map<String, dynamic>;
      final youtubeId = data['youtube_id'] as String;
      _title = data['title'] as String? ?? '';
      _description = data['description'] as String? ?? '';
      _durationMinutes = data['duration_minutes'] as int? ?? 0;

      _controller = YoutubePlayerController.fromVideoId(
        videoId: youtubeId,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
          mute: false,
        ),
      );
    } catch (e) {
      _hasError = true;
      _controller = YoutubePlayerController();
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Unable to load video content.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(controller: _controller),
          ),
        ),
        const SizedBox(height: 12),
        if (_durationMinutes > 0 || _description.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_durationMinutes > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.neonCyan,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_durationMinutes min',
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
        if (_description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            _description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
