import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/proficiency_service.dart';
import 'package:frontend/models/user_proficiency.dart';

class ProficiencyAssessmentScreen extends ConsumerStatefulWidget {
  const ProficiencyAssessmentScreen({super.key});

  @override
  ConsumerState<ProficiencyAssessmentScreen> createState() => _ProficiencyAssessmentScreenState();
}

class _ProficiencyAssessmentScreenState extends ConsumerState<ProficiencyAssessmentScreen> {
  ProficiencyLevel? _selectedLevel;
  int _currentQuestionIndex = 0;
  List<bool> _answers = [];
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is your current programming experience?',
      'options': [
        'No programming experience',
        'Basic programming knowledge (variables, loops, functions)',
        'Intermediate programming skills (OOP, data structures)',
        'Advanced programming skills (design patterns, system architecture)'
      ]
    },
    {
      'question': 'Have you worked with data analysis or statistics?',
      'options': [
        'Never worked with data',
        'Basic understanding of statistics',
        'Experience with Excel or similar tools',
        'Experience with Python/R for data analysis'
      ]
    },
    {
      'question': 'What is your mathematical background?',
      'options': [
        'High school level math only',
        'Basic college math (algebra, calculus)',
        'Strong mathematical foundation (linear algebra, statistics)',
        'Advanced mathematics (multivariable calculus, probability theory)'
      ]
    },
    {
      'question': 'Do you have any experience with machine learning?',
      'options': [
        'Never heard of machine learning',
        'Basic understanding of concepts',
        'Completed online courses or tutorials',
        'Built ML models for projects or work'
      ]
    },
    {
      'question': 'What are your learning goals?',
      'options': [
        'Just curious about AI',
        'Want to learn for personal interest',
        'Looking to change careers to AI/ML',
        'Want to lead AI initiatives at work'
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, false);
  }

  void _selectLevel(ProficiencyLevel level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  void _selectAnswer(int index) {
    setState(() {
      _answers[_currentQuestionIndex] = true;
      // Auto-advance to next question after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
          });
        }
      });
    });
  }

  double _calculateScore() {
    // Calculate score based on answers (simplified)
    int correctAnswers = _answers.where((answer) => answer).length;
    return (correctAnswers / _answers.length) * 100;
  }

  Future<void> _submitAssessment() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final proficiencyService = ProficiencyService(ref.read(authServiceProvider));
      final score = _calculateScore();
      
      // Save user's selected level
      if (_selectedLevel != null) {
        await proficiencyService.setUserProficiency(userId, _selectedLevel!);
      }
      
      // Update assessment score
      await proficiencyService.updateAssessmentScore(userId, score);
      
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        
        // Navigate to course catalog with recommended courses
        Navigator.of(context).pushReplacementNamed('/courses');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save proficiency level. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Learning Path Assessment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Proficiency Level',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose the level that best describes your current knowledge and experience with AI and machine learning.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            if (_selectedLevel == null) ...[
              _buildLevelSelector(context),
            ] else ...[
              _buildAssessmentQuestions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSelector(BuildContext context) {
    return Column(
      children: [
        _ProficiencyLevelCard(
          level: ProficiencyLevel.beginner,
          title: 'Beginner',
          description: 'New to AI/ML. No prior experience needed.',
          features: [
            'Learn fundamental concepts',
            'Hands-on with simple projects',
            'No programming prerequisites'
          ],
          isSelected: _selectedLevel == ProficiencyLevel.beginner,
          onTap: () => _selectLevel(ProficiencyLevel.beginner),
        ),
        const SizedBox(height: 16),
        _ProficiencyLevelCard(
          level: ProficiencyLevel.intermediate,
          title: 'Intermediate',
          description: 'Some programming and math background.',
          features: [
            'Work with ML frameworks',
            'Build real-world models',
            'Apply algorithms to datasets'
          ],
          isSelected: _selectedLevel == ProficiencyLevel.intermediate,
          onTap: () => _selectLevel(ProficiencyLevel.intermediate),
        ),
        const SizedBox(height: 16),
        _ProficiencyLevelCard(
          level: ProficiencyLevel.advanced,
          title: 'Advanced',
          description: 'Experienced practitioner or researcher.',
          features: [
            'Explore cutting-edge research',
            'Lead AI initiatives',
            'Contribute to open source'
          ],
          isSelected: _selectedLevel == ProficiencyLevel.advanced,
          onTap: () => _selectLevel(ProficiencyLevel.advanced),
        ),
      ],
    );
  }

  Widget _buildAssessmentQuestions() {
    final question = _questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(width: 8),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          question['question'],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Column(
          children: List.generate(question['options'].length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _answers[_currentQuestionIndex] && index == _answers.indexOf(true) 
                        ? Colors.blue 
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: _answers[_currentQuestionIndex] 
                      ? null 
                      : () => _selectAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _answers[_currentQuestionIndex] && index == _answers.indexOf(true)
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                          child: Center(
                            child: _answers[_currentQuestionIndex] && index == _answers.indexOf(true)
                                ? const Icon(Icons.check, color: Colors.white, size: 20)
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: _answers[_currentQuestionIndex] && index == _answers.indexOf(true)
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            question['options'][index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const Spacer(),
        if (_currentQuestionIndex == _questions.length - 1)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitAssessment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        SizedBox(width: 16),
                        Text('Saving...', style: TextStyle(fontSize: 16)),
                      ],
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Complete Assessment', style: TextStyle(fontSize: 16)),
                      ],
                    ),
            ),
          ),
      ],
    );
  }
}

class _ProficiencyLevelCard extends StatelessWidget {
  final ProficiencyLevel level;
  final String title;
  final String description;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProficiencyLevelCard({
    required this.level,
    required this.title,
    required this.description,
    required this.features,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForLevel(level),
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.blue, size: 30),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'What you\'ll learn:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature)),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
                  ),
                  child: Text(
                    isSelected ? 'Selected' : 'Select Level',
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForLevel(ProficiencyLevel level) {
    switch (level) {
      case ProficiencyLevel.beginner:
        return Icons.school;
      case ProficiencyLevel.intermediate:
        return Icons.auto_graph;
      case ProficiencyLevel.advanced:
        return Icons.science;
    }
  }
}