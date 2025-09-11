import 'package:flutter/material.dart';
import 'package:frontend/models/user_proficiency.dart';

class ProficiencySelectionDialog extends StatefulWidget {
  final ProficiencyLevel? initialLevel;

  const ProficiencySelectionDialog({super.key, this.initialLevel});

  @override
  State<ProficiencySelectionDialog> createState() => _ProficiencySelectionDialogState();
}

class _ProficiencySelectionDialogState extends State<ProficiencySelectionDialog> {
  ProficiencyLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Your Proficiency Level'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose the level that best matches your current AI/ML knowledge and experience.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _ProficiencyOption(
              level: ProficiencyLevel.beginner,
              title: 'Beginner',
              description: 'New to AI/ML. No prior experience needed.',
              isSelected: _selectedLevel == ProficiencyLevel.beginner,
              onTap: () => setState(() => _selectedLevel = ProficiencyLevel.beginner),
            ),
            const SizedBox(height: 12),
            _ProficiencyOption(
              level: ProficiencyLevel.intermediate,
              title: 'Intermediate',
              description: 'Some programming and math background.',
              isSelected: _selectedLevel == ProficiencyLevel.intermediate,
              onTap: () => setState(() => _selectedLevel = ProficiencyLevel.intermediate),
            ),
            const SizedBox(height: 12),
            _ProficiencyOption(
              level: ProficiencyLevel.advanced,
              title: 'Advanced',
              description: 'Experienced practitioner or researcher.',
              isSelected: _selectedLevel == ProficiencyLevel.advanced,
              onTap: () => setState(() => _selectedLevel = ProficiencyLevel.advanced),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedLevel != null
              ? () => Navigator.of(context).pop(_selectedLevel)
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ProficiencyOption extends StatelessWidget {
  final ProficiencyLevel level;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProficiencyOption({
    required this.level,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}