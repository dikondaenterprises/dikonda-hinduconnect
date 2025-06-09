import 'package:flutter/material.dart';

/// Simple loading spinner centered
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.size = 24.0, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: size, height: size, child: const CircularProgressIndicator()));
  }
}

/// Displays a standard error message
class ErrorText extends StatelessWidget {
  const ErrorText(this.message, {this.padding = const EdgeInsets.all(16), super.key});
  final String message;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
