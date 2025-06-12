import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredBubble extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final double blurSigma;
  final Color borderColor;
  final double borderWidth;
  final TextStyle? textStyle;

  const BlurredBubble({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.blurSigma = 5.0,
    this.borderColor = Colors.white54,
    this.borderWidth = 1.5,
    this.textStyle,
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
            color: Colors.white.withAlpha((0.25 * 255).round()),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            style:
                textStyle ??
                TextStyle(
                  //color: Color(0xffffea00),
                  fontSize: 12,
                  fontFamily: 'Sora-SemiBold',
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
