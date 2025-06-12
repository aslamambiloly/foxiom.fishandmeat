import 'package:ecom_one/controllers/bottom.sheet.controller.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final BottomSheetController controller;

  const ReviewCard({super.key, required this.review, required this.controller});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              starOpacity(review['rating'], 16),
              SizedBox(width: 3),
              Text(
                '${review['rating']} ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sora-SemiBold',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          // review text
          Expanded(
            child: Text(
              review['review'] ?? '',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Sora',
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 6),
          // username
          FutureBuilder<String>(
            future: controller.fetchUsername(review['userId'] as String),
            builder: (ctx, snap) {
              final name = snap.data ?? '…';
              return Text(
                '@$name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'Sora-SemiBold',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
