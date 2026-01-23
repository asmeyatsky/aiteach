import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaygroundScreen extends ConsumerStatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  ConsumerState<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends ConsumerState<PlaygroundScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    if (_promptController.text.trim().isEmpty) return;

    final prompt = _promptController.text.trim();
    _promptController.clear();

    // Add user message to history
    ref.read(chatHistoryProvider.notifier).state = [
      ...ref.read(chatHistoryProvider),
      {'role': 'user', 'content': prompt}
    ];

    // Show loading indicator
    ref.read(isChatLoadingProvider.notifier).state = true;

    try {
      // Call the AI API
      final response = await ref.read(chatWithAiProvider(prompt).future);
      final aiResponse = response['response'] as String?;

      // Add AI response to history
      if (aiResponse != null) {
        ref.read(chatHistoryProvider.notifier).state = [
          ...ref.read(chatHistoryProvider),
          {'role': 'assistant', 'content': aiResponse}
        ];
      }
    } catch (e) {
      // Add error message to history
      ref.read(chatHistoryProvider.notifier).state = [
        ...ref.read(chatHistoryProvider),
        {'role': 'error', 'content': 'Error: ${e.toString()}'}
      ];
    } finally {
      ref.read(isChatLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatHistory = ref.watch(chatHistoryProvider);
    final isLoading = ref.watch(isChatLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Playground'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: chatHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'Start a conversation with the AI assistant!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        final message = chatHistory[index];
                        final role = message['role'];
                        final content = message['content'];

                        Color bgColor = Colors.grey.shade100;
                        Alignment alignment = Alignment.centerLeft;

                        if (role == 'user') {
                          bgColor = Colors.blue.shade100;
                          alignment = Alignment.centerRight;
                        } else if (role == 'assistant') {
                          bgColor = Colors.green.shade50;
                        } else if (role == 'error') {
                          bgColor = Colors.red.shade50;
                        }

                        return Align(
                          alignment: alignment,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              content ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: 'Ask anything...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}