import 'dart:async';
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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: ctrl.toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
            child: Obx(() {
              final expanded = ctrl.isAnimated.value;
              final show = ctrl.showContent.value;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: double.maxFinite,
                height: expanded ? 300 : 20,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // label
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: expanded ? 0.0 : 1.0,
                      curve: Curves.easeInOut,
                      child: label,
                    ),

                    // body content
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: show ? 1.0 : 0.0,
                      curve: Curves.easeInOut,
                      child: body,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
