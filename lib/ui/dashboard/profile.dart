import 'package:flutter/material.dart';

class ProfileActivity extends StatelessWidget {
  const ProfileActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.amber,
            height: 7900,
            child: Text('unda'),
          ),
        ),
      ),
    );
  }
}
