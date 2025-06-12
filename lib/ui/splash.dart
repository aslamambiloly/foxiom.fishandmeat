import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:get/get.dart';
import 'package:ecom_one/controllers/splash.controller.dart';

class SplashActivity extends StatelessWidget {
  const SplashActivity({super.key});
  static const routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Image.asset(
          'assets/images/foxiom_white.png',
          width: 70,
          height: 70,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cubeSize = min(constraints.maxWidth, constraints.maxHeight);

          return Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: cubeSize,
              height: cubeSize,
              child: Cube(
                onSceneCreated: (scene) {
                  controller.toggle3dAnimation();
                  controller.scene = scene;
                  scene.camera.zoom = 10;
                  scene.camera.target.setFrom(Vector3(0, 0, 0));
                  scene.light.position.setFrom(Vector3(0, 5, 10));
                  controller.obj = Object(
                    fileName: 'assets/models/wolf/Wolf.obj',
                    lighting: true,
                    position: Vector3(0, 0, 0),
                    rotation: Vector3(270, 0, 0),
                  );
                  scene.world.add(controller.obj);
                  scene.update();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
