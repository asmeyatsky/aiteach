import 'package:flutter/material.dart';

class AnimatedSnackbar extends StatefulWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration duration;

  const AnimatedSnackbar({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start animation
    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info,
                color: widget.textColor ?? Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension method to show animated snackbar
extension AnimatedSnackbarExtension on BuildContext {
  void showAnimatedSnackbar(String message,
      {Color? backgroundColor, Color? textColor, Duration? duration}) {
    final overlay = Overlay.of(this);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedSnackbar(
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
          duration: duration ?? const Duration(seconds: 4),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove after duration + animation time
    Future.delayed(
        (duration ?? const Duration(seconds: 4)) + const Duration(milliseconds: 300),
        () {
      if (!overlayEntry.mounted) return;
      overlayEntry.remove();
    });
  }
}