import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class CubeViewer extends StatefulWidget {
  const CubeViewer({super.key});

  @override
  State<CubeViewer> createState() => _CubeViewerState();
}

class _CubeViewerState extends State<CubeViewer>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  late Object _obj;
  late AnimationController _anim;

  // radius of your “orbit”
  final double _radius = 10.0;
  // height of the camera above the model
  final double _height = 2.0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(_updateCamera)
     ..repeat();
  }

  void _updateCamera() {
    if (!mounted) return;

    // calculate current angle (0 → 2π)
    final angle = _anim.value * 2 * math.pi;
    // position the camera on a horizontal circle
    final x = _radius * math.cos(angle);
    final z = _radius * math.sin(angle);

    // update scene’s camera
    _scene.camera.position.setValues(x, _height, z);
    // always look back at the origin (0,0,0)
    _scene.camera.target.setValues(0, 0, 0);
    _scene.update(); // tell flutter_cube to redraw
  }

  @override
  Widget build(BuildContext context) {
    return Cube(
      onSceneCreated: (scene) {
        _scene = scene;
        scene.camera.zoom = 3;
        scene.light
          .position.setFrom(Vector3(0, 5, 10));
        _obj = Object(
          fileName: 'assets/models/jellyfish.obj',
          lighting: true,
        );
        scene.world.add(_obj);

        // position camera initially
        _updateCamera();
      },
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }
}
