import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flutter_cube/flutter_cube.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late Scene scene;
  late Object obj;
  late AnimationController _anim;
  final is3dAnimated = false.obs;
  final double _radius = 10.0;
  final double _height = 1.0;

  @override
  void onInit() {
    super.onInit();
    animationInit();
    checkUser();
  }

  void animationInit() {
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(updateCamera);

    ever<bool>(is3dAnimated, (animate) {
      if (animate) {
        _anim.repeat();
      } else {
        _anim.stop();
      }
    });
  }

  void toggle3dAnimation() {
    is3dAnimated.value = !is3dAnimated.value;
  }

  void updateCamera() {
    final angle = _anim.value * 2 * math.pi;
    final x = _radius * math.cos(angle);
    final z = _radius * math.sin(angle);
    scene.camera.position.setValues(x, _height, z);
    scene.camera.target.setValues(0, 0, 0);
    scene.update();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      navigateHome();
    } else {
      navigateLogin();
    }
  }

  void navigateLogin() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed('/login');
    });
  }

  void navigateHome() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed('/dashboard');
    });
  }

  @override
  void onClose() {
    _anim.dispose();
    super.onClose();
  }
}
