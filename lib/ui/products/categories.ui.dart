import 'package:ecom_one/controllers/products/categories.controller.dart';
import 'package:ecom_one/utils/shimmer.categories.dart';
import 'package:flutter/material.dart';
import 'package:ecom_one/utils/colors.dart';

class CategoriesList extends StatelessWidget {
  final CategoriesController controller;
  final int shimmerCount;

  const CategoriesList({
    super.key,
    required this.controller,
    this.shimmerCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: controller.fetchAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: shimmerCount,
              itemBuilder: (_, __) => const CategoryChipShimmer(),
            ),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return SizedBox(
            height: 50,
            child: Center(
              child: Text(
                snapshot.hasError
                    ? 'Failed to load categories'
                    : 'No categories found',
              ),
            ),
          );
        }

        final categories = snapshot.data!;
        final colors = [
          AppColors.gradient1,
          AppColors.gradient2,
          AppColors.gradient3,
          AppColors.gradient4,
          AppColors.gradient5,
          AppColors.gradient6,
        ];
        return SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final name = categories[index];
              return Chip(
                label: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sora-SemiBold',
                    fontSize: 12,
                  ),
                ),
                backgroundColor: colors[index % colors.length],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
