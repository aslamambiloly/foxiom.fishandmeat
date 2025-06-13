import 'dart:async';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AnimatedSearchBarController extends GetxController {
  final isAnimated = false.obs;
  final showContent = false.obs;

  void toggle() {
    if (!isAnimated.value) {
      isAnimated.value = true;

      Timer(const Duration(milliseconds: 500), () {
        showContent.value = true;
      });
    } else {
      showContent.value = false;

      Timer(const Duration(milliseconds: 300), () {
        isAnimated.value = false;
      });
    }
  }
}

class AnimatedSearchBar extends StatelessWidget {
  final Widget body;
  final Widget label;

  const AnimatedSearchBar({super.key, required this.body, required this.label});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AnimatedSearchBarController());

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Card(
          elevation: 4,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: ctrl.toggle,
              child: Obx(() {
                final expanded = ctrl.isAnimated.value;
                final showBody = ctrl.showContent.value;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: expanded ? 300 : 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // collapsed label
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: expanded ? 0 : 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          child: label,
                        ),
                      ),

                      // expanded body
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: showBody ? 1 : 0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                          child: body,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
