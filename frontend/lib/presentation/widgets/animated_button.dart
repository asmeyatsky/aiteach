import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final EdgeInsets? padding;
  final OutlinedBorder? shape;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.shape,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = theme.elevatedButtonTheme.style ?? ElevatedButton.styleFrom();

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: buttonStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll<Color?>(widget.backgroundColor ?? buttonStyle.backgroundColor),
            foregroundColor: WidgetStatePropertyAll<Color?>(widget.foregroundColor ?? buttonStyle.foregroundColor),
            elevation: WidgetStatePropertyAll<double?>(widget.elevation ?? buttonStyle.elevation?.resolve({})),
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(widget.padding ?? buttonStyle.padding),
            shape: WidgetStatePropertyAll<OutlinedBorder?>(widget.shape ?? buttonStyle.shape),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}