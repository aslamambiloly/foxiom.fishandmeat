import 'package:ecom_one/controllers/products/todays.picks.controller.dart';
import 'package:ecom_one/ui/bottom.sheet.ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ecom_one/utils/colors.dart';
import 'package:ecom_one/utils/shimmer.dart';

class RandomProductsCarousel extends StatelessWidget {
  final int count;
  final TodaysPicksController controller;

  const RandomProductsCarousel({
    super.key,
    this.count = 5,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.fetchRandomProducts(count: count),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: count,
              itemBuilder: (_, __) => const ProductCardShimmer(),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return SizedBox(
            height: 200,
            child: Center(child: Text('Failed to load products')),
          );
        }

        final randoms = snapshot.data!;
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: randoms.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, i) {
              final item = randoms[i];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showProductBottomSheet(context, item['id']);
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: const EdgeInsets.all(0.9),
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
                                    'https://fishandmeatapp.onrender.com/uploads/${item['image']}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (ctx, child, progress) {
                                      if (progress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[800]!,
                                        highlightColor: Colors.grey[700]!,
                                        child: Container(
                                          color: Colors.grey[800],
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (_, __, ___) => const Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                  ),
                                  // Top gradient overlay
                                  Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.black.withAlpha(160),
                                          Colors.transparent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  // Bottom gradient overlay
                                  Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.black.withAlpha(200),
                                          Colors.transparent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  // Stock info
                                  Positioned(
                                    top: 5,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        Text(
                                          item['stock'].toString(),
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
                                  // Title and price
                                  Positioned(
                                    bottom: 5,
                                    left: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item['title'] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: 'Sora-SemiBold',
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 11,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '₹${item['price']}',
                                          style: const TextStyle(
                                            color: AppColors.primaryColour,
                                            fontFamily: 'Sora',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
