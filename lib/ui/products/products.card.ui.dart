import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ecom_one/utils/colors.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final num price;
  final int stock;
  final double rating;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.stock,
    required this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 100,
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(color: Colors.grey[800]),
                            );
                          },
                          errorBuilder:
                              (_, __, ___) =>
                                  const Center(child: Icon(Icons.broken_image)),
                        ),
                        // Top gradient
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(160),
                                Colors.transparent,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        // Bottom gradient
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(200),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        // Stock
                        Positioned(
                          top: 10,
                          left: 15,
                          child: Row(
                            children: [
                              Text(
                                stock.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sora-SemiBold',
                                  fontSize: 10,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                ' left',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sora',
                                  fontSize: 10,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // rating
                        Positioned(
                          top: 10,
                          right: 15,
                          child: Row(
                            children: [
                              starOpacity(rating, 12),
                              SizedBox(width: 2),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Sora-SemiBold',
                                    fontSize: 10,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black45,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  children: [TextSpan(text: '$rating')],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Title & price
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Sora-Bold',
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '₹$price',
                                style: const TextStyle(
                                  color: AppColors.primaryColour,
                                  fontFamily: 'Sora-SemiBold',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // arrow
                        Positioned(
                          bottom: 0,
                          top: 0,
                          right: 10,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
