import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIconButton extends StatefulWidget {
  final Column body;
  final IconData icon;
  final double buttonWidth;
  final double containerWidth;
  final double buttonHeight;
  final double containerHeight;
  const AnimatedIconButton({
    super.key,
    required this.body,
    required this.icon,
    this.buttonWidth = 40,
    this.buttonHeight = 40,
    this.containerHeight = 300,
    this.containerWidth = 200,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  bool isAnimated = false;
  bool showContent = false;
  bool isHovered = false;

  void toggleCard() {
    if (!isAnimated) {
      setState(() {
        isAnimated = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            showContent = true;
          });
        }
      });
    } else {
      setState(() {
        showContent = false;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            isAnimated = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          HapticFeedback.lightImpact();
          toggleCard();
        },
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          width: isAnimated ? widget.containerWidth : widget.buttonWidth,
          height: isAnimated ? widget.containerHeight : widget.buttonHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withAlpha((0.1 * 255).round()),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: isAnimated ? 0.0 : 1.0,
                        child: Icon(
                          widget.icon,
                          color:
                              isHovered ? Color(0xFF141218) : Color(0xfffefffe),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: showContent ? 1.0 : 0.0,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: widget.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
