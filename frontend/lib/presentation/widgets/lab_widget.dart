import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class _LabTool {
  final String name;
  final String url;

  _LabTool({required this.name, required this.url});

  factory _LabTool.fromJson(Map<String, dynamic> json) {
    return _LabTool(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

class _LabStep {
  final String title;
  final String instructions;
  final String hint;

  _LabStep({required this.title, required this.instructions, required this.hint});

  factory _LabStep.fromJson(Map<String, dynamic> json) {
    return _LabStep(
      title: json['title'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
    );
  }
}

class LabWidget extends StatefulWidget {
  final String contentDataJson;

  const LabWidget({super.key, required this.contentDataJson});

  @override
  State<LabWidget> createState() => _LabWidgetState();
}

class _LabWidgetState extends State<LabWidget> {
  String _title = '';
  String _description = '';
  String _difficulty = '';
  int _estimatedMinutes = 0;
  List<_LabTool> _tools = [];
  List<String> _objectives = [];
  List<_LabStep> _steps = [];
  String _solution = '';
  bool _hasError = false;

  late List<bool> _objectiveChecked;
  late List<bool> _stepExpanded;
  late List<bool> _hintShown;
  bool _solutionShown = false;

  @override
  void initState() {
    super.initState();
    try {
      final data = jsonDecode(widget.contentDataJson) as Map<String, dynamic>;
      _title = data['title'] as String? ?? '';
      _description = data['description'] as String? ?? '';
      _difficulty = data['difficulty'] as String? ?? '';
      _estimatedMinutes = data['estimated_minutes'] as int? ?? 0;
      _tools = (data['tools'] as List?)
              ?.map((t) => _LabTool.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [];
      _objectives = (data['objectives'] as List?)
              ?.map((o) => o as String)
              .toList() ??
          [];
      _steps = (data['steps'] as List?)
              ?.map((s) => _LabStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [];
      _solution = data['solution'] as String? ?? '';

      _objectiveChecked = List.filled(_objectives.length, false);
      _stepExpanded = List.filled(_steps.length, false);
      _hintShown = List.filled(_steps.length, false);
    } catch (e) {
      _hasError = true;
      _objectiveChecked = [];
      _stepExpanded = [];
      _hintShown = [];
    }
  }

  Color _difficultyColor() {
    switch (_difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.neonGreen;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.neonPink;
      default:
        return AppColors.neonCyan;
    }
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
            'Unable to load lab content.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.science, color: AppColors.neonPurple, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Badges
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            if (_difficulty.isNotEmpty)
              _badge(_difficulty, _difficultyColor()),
            if (_estimatedMinutes > 0)
              _badge('$_estimatedMinutes min', AppColors.neonCyan),
          ],
        ),
        const SizedBox(height: 14),

        // Description
        if (_description.isNotEmpty) ...[
          Text(
            _description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Tools
        if (_tools.isNotEmpty) ...[
          const Text(
            'Tools',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tools.map((tool) {
              return OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(tool.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(tool.name),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.neonCyan,
                  side: const BorderSide(color: AppColors.neonCyan),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Objectives
        if (_objectives.isNotEmpty) ...[
          const Text(
            'Objectives',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_objectives.length, (i) {
            return CheckboxListTile(
              value: _objectiveChecked[i],
              onChanged: (v) => setState(() => _objectiveChecked[i] = v ?? false),
              title: Text(
                _objectives[i],
                style: TextStyle(
                  fontSize: 14,
                  color: _objectiveChecked[i]
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                  decoration: _objectiveChecked[i]
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              activeColor: AppColors.neonGreen,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }),
          const SizedBox(height: 16),
        ],

        // Steps
        if (_steps.isNotEmpty) ...[
          const Text(
            'Steps',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_steps.length, (i) {
            final step = _steps[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.neonPurple,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      step.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      _stepExpanded[i]
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () =>
                        setState(() => _stepExpanded[i] = !_stepExpanded[i]),
                  ),
                  if (_stepExpanded[i]) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.instructions,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          if (step.hint.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _hintShown[i]
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      step.hint,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                  )
                                : TextButton.icon(
                                    onPressed: () => setState(
                                        () => _hintShown[i] = true),
                                    icon: const Icon(Icons.lightbulb_outline,
                                        size: 16),
                                    label: const Text('Show Hint'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.warning,
                                    ),
                                  ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        // Solution
        if (_solution.isNotEmpty) ...[
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.code, color: AppColors.neonGreen),
                  title: const Text(
                    'Solution',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    _solutionShown
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () =>
                      setState(() => _solutionShown = !_solutionShown),
                ),
                if (_solutionShown)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _solution,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
