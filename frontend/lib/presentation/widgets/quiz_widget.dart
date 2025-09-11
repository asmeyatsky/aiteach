import 'package:flutter/material.dart';
import 'dart:convert';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
    );
  }
}

class QuizData {
  final String title;
  final List<QuizQuestion> questions;

  QuizData({
    required this.title,
    required this.questions,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    var questionsList = json['questions'] as List;
    List<QuizQuestion> questions = questionsList
        .map((question) => QuizQuestion.fromJson(question as Map<String, dynamic>))
        .toList();

    return QuizData(
      title: json['title'] as String,
      questions: questions,
    );
  }
}

class QuizWidget extends StatefulWidget {
  final String quizDataJson;

  const QuizWidget({super.key, required this.quizDataJson});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  late QuizData quizData;
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool showResult = false;
  bool isCorrect = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    try {
      final jsonMap = jsonDecode(widget.quizDataJson);
      quizData = QuizData.fromJson(jsonMap);
    } catch (e) {
      // Handle invalid JSON
      quizData = QuizData(
        title: 'Invalid Quiz Data',
        questions: [],
      );
    }
  }

  void selectOption(int optionIndex) {
    setState(() {
      selectedOptionIndex = optionIndex;
      showResult = true;
      isCorrect = optionIndex == quizData.questions[currentQuestionIndex].correctAnswerIndex;
      if (isCorrect) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < quizData.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        showResult = false;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedOptionIndex = null;
      showResult = false;
      isCorrect = false;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizData.questions.isEmpty) {
      return const Center(
        child: Text('Invalid quiz data'),
      );
    }

    final question = quizData.questions[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quizData.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / quizData.questions.length,
        ),
        const SizedBox(height: 10),
        Text(
          'Question ${currentQuestionIndex + 1} of ${quizData.questions.length}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Text(
          question.question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Column(
          children: question.options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            bool isSelected = selectedOptionIndex == index;
            bool isCorrectOption = index == question.correctAnswerIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: showResult
                    ? null
                    : () => selectOption(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? (showResult
                          ? (isCorrectOption ? Colors.green : Colors.red)
                          : Theme.of(context).primaryColor)
                      : null,
                  foregroundColor: isSelected && showResult
                      ? Colors.white
                      : null,
                  side: isSelected && !showResult
                      ? BorderSide(color: Theme.of(context).primaryColor)
                      : null,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (showResult
                                ? (isCorrectOption ? Colors.green : Colors.red)
                                : Theme.of(context).primaryColor)
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (showResult && isCorrectOption)
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    else if (showResult && isSelected && !isCorrectOption)
                      const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (showResult) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isCorrect
                        ? 'Correct! Well done.'
                        : 'Incorrect. The correct answer is ${String.fromCharCode(65 + question.correctAnswerIndex)}.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isCorrect ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (currentQuestionIndex < quizData.questions.length - 1)
            Center(
              child: ElevatedButton(
                onPressed: nextQuestion,
                child: const Text('Next Question'),
              ),
            )
          else
            Center(
              child: Column(
                children: [
                  Text(
                    'Quiz Completed! Your score: $score/${quizData.questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: restartQuiz,
                    child: const Text('Restart Quiz'),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}