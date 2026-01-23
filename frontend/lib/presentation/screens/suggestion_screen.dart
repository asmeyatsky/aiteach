import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/suggestion_model.dart';

class SuggestionScreen extends ConsumerStatefulWidget {
  const SuggestionScreen({super.key});

  @override
  ConsumerState<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends ConsumerState<SuggestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _commentController = TextEditingController();
  String _selectedTrack = 'user'; // default value

  bool _isSubmitting = false;

  @override
  void dispose() {
    _urlController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitSuggestion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final suggestion = SuggestedContentCreate(
        url: _urlController.text.trim(),
        comment: _commentController.text.trim(),
        suggestedTrack: _selectedTrack,
      );

      await ref.read(createSuggestionProvider(suggestion).future);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content suggestion submitted successfully!')),
      );

      // Clear the form
      _urlController.clear();
      _commentController.clear();
      setState(() {
        _selectedTrack = 'user';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting suggestion: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggest Content'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Suggest Learning Resources',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Help us improve the platform by suggesting valuable AI/ML learning resources.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Resource URL',
                  hintText: 'https://example.com/ai-tutorial',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  // Basic URL validation
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'URL must start with http:// or https://';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTrack,
                decoration: const InputDecoration(
                  labelText: 'Suggested Track',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'user',
                    child: Text('AI User'),
                  ),
                  DropdownMenuItem(
                    value: 'builder',
                    child: Text('AI Builder'),
                  ),
                  DropdownMenuItem(
                    value: 'innovator',
                    child: Text('AI Innovator'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTrack = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Additional Comments (Optional)',
                  hintText: 'Why do you think this resource is valuable?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitSuggestion,
                  child: _isSubmitting
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Submitting...'),
                          ],
                        )
                      : const Text('Submit Suggestion'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your suggestions help us curate the best learning resources for the community. Thank you for contributing!',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}