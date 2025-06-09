import 'package:flutter/material.dart';

class TestModeBanner extends StatelessWidget {
  final Widget child;
  final bool show;

  const TestModeBanner({required this.child, this.show = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      if (show)
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            color: Colors.red.withAlpha(51),
            padding: const EdgeInsets.all(4),
            child: const Text(
              'TEST MODE',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ]);
  }
}
