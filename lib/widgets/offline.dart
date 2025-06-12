import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';

class OfflineActivity extends StatelessWidget {
  final VoidCallback onTap;
  const OfflineActivity({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: ValueKey('offline'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Oops! It seems like you are offline',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          blueLightButton('retry', onTap),
        ],
      ),
    );
  }
}
