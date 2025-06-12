import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredBubbleChildableDark extends StatelessWidget {
  final EdgeInsets padding;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final Widget child;

  const BlurredBubbleChildableDark({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.blurSigma = 5.0,
    this.borderColor = Colors.white54,
    this.borderWidth = 1.5,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((0.25 * 255).round()),
            borderRadius: BorderRadius.circular(25),
          ),
          child: child,
        ),
      ),
    );
  }
}
