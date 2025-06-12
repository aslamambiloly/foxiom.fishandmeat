import 'dart:ui';
import 'package:ecom_one/animations/searchbar.dart';
import 'package:ecom_one/controllers/dashboard/network.controller.dart';
import 'package:ecom_one/controllers/dashboard/search.controller.dart';
import 'package:ecom_one/ui/bottom.sheet.ui.dart';
import 'package:ecom_one/ui/products/products.card.ui.dart';
import 'package:ecom_one/utils/blurred.bubble.childable.dark.dart';
import 'package:ecom_one/utils/colors.dart';
import 'package:ecom_one/utils/shimmer.dart';
import 'package:ecom_one/widgets/offline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SearchActivity extends StatelessWidget {
  const SearchActivity({super.key});
  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    final net = Get.find<NetworkController>();
    final ctrl = Get.put(SearchActivityController());
    final searchBarCtrl = Get.put(AnimatedSearchBarController());

    return Scaffold(
      body: Stack(
        children: [
          topShade(),
          bottomShade(),
          Obx(
            () => AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child:
                  !net.isConnected.value
                      ? OfflineActivity(onTap: net.retry)
                      : Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                          ),
                          backButton(context),
                          SizedBox(height: 20),
                          searchBar(ctrl, searchBarCtrl),
                          SizedBox(height: 10),
                          categoryChips(ctrl),
                          SizedBox(height: 10),
                          //sortBy(ctrl),
                          showingResultsCount(ctrl),
                          resultList2(ctrl),
                        ],
                      ),
            ),
          ),
          // bottomShade(),
        ],
      ),
    );
  }

  Widget searchBar(
    SearchActivityController ctrl,
    AnimatedSearchBarController searchBarCtrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AnimatedSearchBar(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                BlurredBubbleChildableDark(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          onSubmitted: (_) {
                            ctrl.doSearch();
                            searchBarCtrl.toggle();
                          },
                          controller: ctrl.search,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sora',
                            fontSize: 12,
                          ),
                          decoration: const InputDecoration(
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Search want you want',
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
                      const SizedBox(width: 5),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: ctrl.doSearch,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.primaryColour,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // inStock toggle
                SizedBox(
                  height: 20,
                  child: Obx(
                    () => Row(
                      children: [
                        Checkbox(
                          side: BorderSide(width: 0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: ctrl.inStockOnly.value,
                          onChanged: (v) {
                            ctrl.inStockOnly.value = v!;
                            ctrl.applyFilters();
                          },
                        ),
                        Text(
                          'Show available items only',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:
                                ctrl.inStockOnly.value ? 'Sora-Bold' : 'Sora',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter by Rating toggle
                Obx(
                  () => Row(
                    children: [
                      Checkbox(
                        side: BorderSide(width: 0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: ctrl.enableRatingFilter.value,
                        onChanged: (v) {
                          ctrl.enableRatingFilter.value = v!;
                          if (!v) {
                            ctrl.minRating.value = 0.0;
                            ctrl.applyFilters();
                          }
                        },
                      ),
                      Text(
                        'Filter by rating',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily:
                              ctrl.enableRatingFilter.value
                                  ? 'Sora-Bold'
                                  : 'Sora',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: ctrl.enableRatingFilter.value ? 1.0 : 0.3,
                    child: AbsorbPointer(
                      absorbing: !ctrl.enableRatingFilter.value,
                      child: BlurredBubbleChildableDark(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Slider(
                              value: ctrl.minRating.value,
                              min: 0,
                              max: 5,
                              divisions: 5,
                              onChanged: (v) => ctrl.minRating.value = v,
                              onChangeEnd: (_) => ctrl.applyFilters(),
                            ),
                            // Display current rating threshold
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stars_rounded,
                                  color: Colors.amberAccent,
                                  size: 20,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  ctrl.minRating.value.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Sora-Bold',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12,
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  Text(
                    'Submit',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                onSubmitted: (_) => ctrl.doSearch(),
                controller: ctrl.search,
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sora',
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Search want you want',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Sora-SemiBold',
                    fontSize: 12,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget backButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              'back',
              style: TextStyle(fontFamily: 'Sora-Bold', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomShade() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 150,
      child: ClipRect(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
              stops: [0.0, 1.0],
            ).createShader(bounds);
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withAlpha((1.0 * 255).round()),
            ),
          ),
        ),
      ),
    );
  }

  Widget topShade() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 200,
      child: ClipRect(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
              stops: [0.0, 1.0],
            ).createShader(bounds);
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withAlpha((1.0 * 255).round()),
            ),
          ),
        ),
      ),
    );
  }

  Widget resultList(SearchActivityController ctrl) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 6,
              itemBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: const ProductCardShimmer(),
                  ),
            );
          }

          final list = ctrl.filteredProducts;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'Oops.. No items found :(',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Sora',
                  fontSize: 12,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final item = list[i];
              final url = Uri.encodeFull(
                'https://fishandmeatapp.onrender.com/uploads/${item['image']}',
              );
              return ProductCard(
                imageUrl: url,
                title: item['title'] ?? '',
                price: item['price'] ?? 0,
                stock: item['stock'] ?? 0,
                rating: (item['avgRating'] as double?) ?? 0.0,

                onTap: () {
                  // navigate to details, etc.
                },
              );
            },
          );
        }),
      ),
    );
  }

  Widget resultList2(SearchActivityController ctrl) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return GridView.builder(
              //padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 200 / 170,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => const ProductCardShimmer(),
            );
          }
          final list = ctrl.filteredProducts;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'Oops… No items found :(',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Sora',
                  fontSize: 12,
                ),
              ),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 280 / 170,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final item = list[i];
              final productId = item['id'] as String;
              final imageUrl = Uri.encodeFull(
                'https://fishandmeatapp.onrender.com/uploads/${item['image']}',
              );
              return InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  showProductBottomSheet(context, productId);
                },
                child: ProductCard(
                  imageUrl: imageUrl,
                  title: item['title'] ?? '',
                  price: item['price'] ?? 0,
                  stock: item['stock'] ?? 0,
                  rating: (item['avgRating'] as double?) ?? 0.0,
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget categoryChips(SearchActivityController ctrl) {
    final colors = [
      AppColors.gradient1,
      AppColors.gradient2,
      AppColors.gradient3,
      AppColors.gradient4,
      AppColors.gradient5,
      AppColors.gradient6,
    ];
    return Obx(() {
      if (ctrl.isLoading.value) {
        return SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 25),
                for (var i = 0; i < 6; i++) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 20),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        height: 40,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              sortBy(ctrl),
              for (var i = 0; i < ctrl.allCategories.length; i++)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(
                      ctrl.allCategories[i],
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            ctrl.selectedCategories.contains(
                                  ctrl.allCategories[i],
                                )
                                ? 'Sora-SemiBold'
                                : 'Sora',
                        fontSize: 12,
                      ),
                    ),
                    selected: ctrl.selectedCategories.contains(
                      ctrl.allCategories[i],
                    ),

                    backgroundColor: colors[i % colors.length].withAlpha(80),
                    selectedColor: colors[i % colors.length].withAlpha(255),
                    onSelected: (yes) {
                      if (yes) {
                        ctrl.selectedCategories.add(ctrl.allCategories[i]);
                      } else {
                        ctrl.selectedCategories.remove(ctrl.allCategories[i]);
                      }
                      ctrl.applyFilters();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget sortBy(SearchActivityController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Obx(
        () => AnimatedSize(
          duration: const Duration(milliseconds: 100),
          child: MenuAnchor(
            style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black87),
              elevation: WidgetStateProperty.all(6),
              shadowColor: WidgetStateProperty.all(Colors.black45),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            builder: (context, controller, child) {
              final label =
                  {
                    SortMode.priceAsc: 'Price Low to High',
                    SortMode.priceDesc: 'Price High to Low',
                    SortMode.ratingDesc: 'Rating High to Low',
                    SortMode.alpha: 'Alphabetical Order',
                  }[ctrl.sortMode.value]!;

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: controller.open,
                child: BlurredBubbleChildableDark(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Sora',
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            menuChildren:
                SortMode.values.map((m) {
                  final text =
                      {
                        SortMode.priceAsc: 'Price Low to High',
                        SortMode.priceDesc: 'Price High to Low',
                        SortMode.ratingDesc: 'Rating High to Low',
                        SortMode.alpha: 'Alphabetical Order',
                      }[m]!;
                  final selected = m == ctrl.sortMode.value;

                  return MenuItemButton(
                    onPressed: () {
                      ctrl.sortMode.value = m;
                      ctrl.applySort();
                    },
                    leadingIcon:
                        selected
                            ? Icon(Icons.check, color: Colors.white)
                            : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected
                                  ? Colors.white.withAlpha((0.15 * 255).round())
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: selected ? 'Sora-SemiBold' : 'Sora',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget showingResultsCount(SearchActivityController ctrl) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Obx(() {
      if (ctrl.isLoading.value) {
        return SizedBox.shrink();
      }
      final count = ctrl.filteredProducts.length;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Showing $count result${count == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Sora',
              fontSize: 12,
            ),
          ),
        ),
      );
    }),
  );
}
