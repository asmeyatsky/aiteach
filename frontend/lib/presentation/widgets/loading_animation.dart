import 'package:flutter/material.dart';
import 'package:frontend/presentation/animations/animations.dart';

class LoadingAnimation extends StatelessWidget {
  final String message;

  const LoadingAnimation({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ScaleInAnimation(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}