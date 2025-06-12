import 'dart:async';
import 'package:get/get.dart';
import 'package:ecom_one/utils/colors.dart';
import 'package:flutter/material.dart';

class AnimatedButtonController extends GetxController {
  // reactive state
  final isAnimated = false.obs;
  final showContent = false.obs;

  void toggle() {
    if (!isAnimated.value) {
      isAnimated.value = true;

      // after the container expands, show the inner content
      Timer(const Duration(seconds: 1), () {
        showContent.value = true;
      });
    } else {
      // hide the content first
      showContent.value = false;

      // then collapse after a short delay
      Timer(const Duration(milliseconds: 300), () {
        isAnimated.value = false;
      });
    }
  }
}

class AnimatedButton extends StatelessWidget {
  final Column body;
  final String label;

  const AnimatedButton({super.key, required this.body, required this.label});

  @override
  Widget build(BuildContext context) {
    // Put the controller in this widget’s scope
    final ctrl = Get.put(AnimatedButtonController());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: ctrl.toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
            // reacts to both isAnimated & showContent
            child: Obx(() {
              final expanded = ctrl.isAnimated.value;
              final show = ctrl.showContent.value;

              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                width: expanded ? 200 : 60,
                height: expanded ? 200 : 20,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // label
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: expanded ? 0.0 : 1.0,
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Sora-Bold',
                          color: AppColors.primaryColour,
                        ),
                      ),
                    ),

                    // body content
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: show ? 1.0 : 0.0,
                      child: SingleChildScrollView(child: body),
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
