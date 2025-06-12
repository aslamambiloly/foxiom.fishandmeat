import 'dart:math';

import 'package:ecom_one/controllers/bottom.sheet.controller.dart';
import 'package:ecom_one/utils/blurred.bubble.childable.dark.dart';
import 'package:ecom_one/utils/blurred.bubble.dart';
import 'package:ecom_one/widgets/reviews.card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ecom_one/utils/colors.dart';
import 'package:ecom_one/utils/widgets.dart';

void showProductBottomSheet(BuildContext context, String productId) {
  final ctrl = Get.put(BottomSheetController(productId));
  final colors = [
    AppColors.gradient2,
    AppColors.gradient3,
    AppColors.gradient4,
    AppColors.gradient5,
  ];
  final rnd = Random();
  final base = colors[rnd.nextInt(colors.length)];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    backgroundColor: Colors.transparent,
    builder:
        (_) => DraggableScrollableSheet(
          expand: false,
          builder: (ctx, scrollCtrl) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [base.withAlpha(255), Colors.black.withAlpha(255)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              //margin: EdgeInsets.all(16),
              child: FutureBuilder<Map<String, dynamic>>(
                future: ctrl.fetchDetails(),
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    // exactly your shimmer loader
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[800]!,
                        highlightColor: Colors.grey[700]!,
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (snap.hasError ||
                      snap.data == null ||
                      snap.data!['success'] != true) {
                    return Center(
                      child: Text(
                        'Failed to load details',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final data = snap.data!['data'] as Map<String, dynamic>;
                  final p = data['product'] as Map<String, dynamic>;
                  final shop = data['shopname'] as String;
                  final rating = (data['rating'] as num).toDouble();
                  final imageUrl = Uri.encodeFull(
                    'https://fishandmeatapp.onrender.com/uploads/${p['image']}',
                  );

                  return ListView(
                    controller: scrollCtrl,
                    children: [
                      // product image
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 35.0,
                          top: 35.0,
                          right: 35.0,
                        ),
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.network(
                                  imageUrl,
                                  height: 150,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, error, stack) {
                                    return Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.white54,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  height: 150,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withAlpha(160),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: BlurredBubble(
                                    text: '${p['stock']} pieces left',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Row(
                          children: [
                            Text(
                              p['title'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Sora-Bold',
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.shopping_bag_rounded,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 4),
                            Text(
                              shop,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Sora',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Row(
                          children: [
                            Text(
                              '₹${p['price']}',
                              style: TextStyle(
                                color: AppColors.primaryColour,
                                fontSize: 18,
                                fontFamily: 'Sora-Bold',
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.stars_rounded,
                              size: 16,
                              color: Colors.amberAccent,
                            ),
                            SizedBox(width: 2),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sora-SemiBold',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sora-Bold',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Text(
                          p['description'] ?? '',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Sora',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Text(
                          'Check availability by PIN code',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sora-Bold',
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Row(
                          children: [
                            BlurredBubbleChildableDark(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                        onSubmitted: (_) {
                                          ctrl.checkPincode();
                                        },
                                        controller: ctrl.pincode,
                                        keyboardType: TextInputType.number,
                                        //maxLength: 6,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Sora-SemiBold',
                                          fontSize: 12,
                                        ),
                                        decoration: const InputDecoration(
                                          filled: false,
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintText: 'Enter Pincode',
                                          hintStyle: TextStyle(
                                            //color: Colors.white54,
                                            fontFamily: 'Sora-SemiBold',
                                            fontSize: 12,
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              return ctrl.isChecking.value
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    child: SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColour,
                                      ),
                                    ),
                                  )
                                  : IconButton(
                                    icon: Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: AppColors.primaryColour,
                                      size: 20,
                                    ),
                                    onPressed: ctrl.checkPincode,
                                  );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Obx(() {
                          final avail = ctrl.pinAvailable.value;
                          if (avail == null) return SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              avail
                                  ? 'Delivery available at your location'
                                  : 'Oops! Delivery not available',
                              style: TextStyle(
                                color:
                                    avail
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                fontFamily: 'Sora',
                                fontSize: 12,
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      Builder(
                        builder: (ctx) {
                          final rawReviews =
                              (p['reviews'] as List?)
                                  ?.cast<Map<String, dynamic>>() ??
                              [];
                          if (rawReviews.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reviews',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Sora-Bold',
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No reviews yet',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: 'Sora',
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            );
                          }
                          // shuffle & take up to 3
                          final sample = List<Map<String, dynamic>>.from(
                            rawReviews,
                          )..shuffle();
                          final display = sample.take(2).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Reviews',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Sora-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: ctrl.seeMoreReviews.toggle,
                                      child: Obx(() {
                                        final open = ctrl.seeMoreReviews.value;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                open ? 'Hide' : 'See more',
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              open
                                                  ? Icons
                                                      .arrow_back_ios_new_rounded
                                                  : Icons
                                                      .arrow_forward_ios_rounded,
                                              size: 10,
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              for (var rev in display) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0,
                                  ),
                                  child: Row(
                                    children: [
                                      starOpacity(rev['rating'], 14),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          rev['review'] ?? '',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'Sora',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6),
                              ],
                              SizedBox(height: 8),
                              Obx(() {
                                if (!ctrl.seeMoreReviews.value) {
                                  return SizedBox.shrink();
                                }
                                return SizedBox(
                                  height: 140,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: sample.length,
                                    separatorBuilder:
                                        (_, __) => SizedBox(width: 0),
                                    itemBuilder: (_, i) {
                                      final rev = sample[i];
                                      return ReviewCard(
                                        review: rev,
                                        controller: ctrl,
                                      );
                                    },
                                  ),
                                );
                              }),
                              SizedBox(height: 20),
                            ],
                          );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: blueLightButton('Add to cart', () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: darkLightButton('Rate this product', () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (sheetCtx) {
                              // ensure text input is above keyboard
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                  bottom:
                                      MediaQuery.of(
                                        sheetCtx,
                                      ).viewInsets.bottom +
                                      20,
                                ),
                                child: Obx(
                                  () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Rate the product',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Sora-Bold',
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      BlurredBubbleChildableDark(
                                        child: TextField(
                                          controller: ctrl.reviewText,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Sora',
                                            fontSize: 12,
                                          ),
                                          decoration: const InputDecoration(
                                            filled: false,
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: 'Write your review..',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Sora-SemiBold',
                                              fontSize: 12,
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      BlurredBubbleChildableDark(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SliderTheme(
                                                data: SliderTheme.of(
                                                  context,
                                                ).copyWith(
                                                  thumbColor:
                                                      AppColors.secondaryColor,
                                                  trackHeight: 30,
                                                  thumbShape:
                                                      RoundSliderThumbShape(
                                                        enabledThumbRadius: 12,
                                                      ),
                                                  overlayShape:
                                                      RoundSliderOverlayShape(
                                                        overlayRadius: 20,
                                                      ),
                                                ),
                                                child: Slider(
                                                  value:
                                                      ctrl.dialogRating.value,
                                                  min: 0,
                                                  max: 5,
                                                  divisions: 50,
                                                  onChanged:
                                                      (v) =>
                                                          ctrl
                                                              .dialogRating
                                                              .value = v,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  starOpacity(
                                                    ctrl.dialogRating.value,
                                                    20,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    ctrl.dialogRating.value
                                                        .toStringAsFixed(1),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Sora-Bold',
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: darkLightButton(
                                              'Cancel',
                                              () {
                                                Navigator.pop(sheetCtx);
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: blueLightButton(
                                              'Submit',
                                              () async {
                                                await ctrl.submitRating(
                                                  context,
                                                );
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(sheetCtx);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
  ).whenComplete(() {
    Get.delete<BottomSheetController>();
  });
}
