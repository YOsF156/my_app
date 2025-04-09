import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? textStyle; // Add textStyle parameter

  const GradientButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.textStyle, // Make textStyle optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFD56CFF), Color(0xFFF3B775)],
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: textStyle ?? Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 0.16,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}