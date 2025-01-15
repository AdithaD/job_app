import 'package:flutter/material.dart';

class LargeElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String label;

  const LargeElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
