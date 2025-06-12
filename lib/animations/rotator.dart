import 'package:flutter/material.dart';

// TO USE THIS OBJECT DO THE BELOW THINGS - @aslamambiloly
// Define a GlobalKey for Rotator : final GlobalKey<RotatorState> rotatorKey = GlobalKey<RotatorState>();
// Use the GlobalKey to call toggleRotate on the Rotator widget : rotatorKey.currentState?.toggleRotate();
// Create a Rotator widget and pass it the GlobalKey : Rotator(key: rotatorKey),

class Rotator extends StatefulWidget {
  const Rotator({super.key});

  @override
  State<Rotator> createState() => RotatorState();
}

class RotatorState extends State<Rotator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isRotate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleRotate() {
    setState(() {
      isRotate = !isRotate;
    });
  }

  void rotateOn() {
    setState(() {
      isRotate = true;
    });
  }

  void rotateOff() {
    setState(() {
      isRotate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isRotate
        ? AnimatedBuilder(
          animation: _controller,
          builder: (context, widget) {
            return Transform.rotate(
              angle: _controller.value * 2.0 * 3.141,
              child: widget,
            );
          },
          child: Icon(Icons.autorenew_sharp, size: 14, color: Colors.grey),
        )
        : Icon(Icons.autorenew_sharp, size: 14, color: Colors.grey);
  }
}
