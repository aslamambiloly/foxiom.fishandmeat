import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      height: 148,
      width: 140,
      margin: EdgeInsets.only(right: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
