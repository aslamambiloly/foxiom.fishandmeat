import 'package:ecom_one/controllers/dashboard/home.controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_one/controllers/dashboard/network.controller.dart';
import 'package:ecom_one/controllers/products/categories.controller.dart';
import 'package:ecom_one/controllers/products/todays.picks.controller.dart';
import 'package:ecom_one/ui/dashboard/search.ui.dart';
import 'package:ecom_one/ui/products/affordables.ui.dart';
import 'package:ecom_one/ui/products/todays.picks.ui.dart';
import 'package:ecom_one/utils/blurred.bubble.childable.dark.dart';
import 'package:ecom_one/utils/blurred.bubble.childable.dart';
import 'package:ecom_one/utils/blurred.bubble.dart';
import 'package:ecom_one/utils/colors.dart';
import 'package:ecom_one/utils/shimmer.categories.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:ecom_one/widgets/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final NetworkController net = Get.find<NetworkController>();
    final RefreshController refreshCtrl = RefreshController(
      initialRefresh: false,
    );
    final TodaysPicksController productsCtrl = Get.put(TodaysPicksController());
    final reloadKey = 0.obs;
    final mdqry = MediaQuery.of(context);
    //final screenHt = mdqry.size.height;
    final screenWt = mdqry.size.width;



    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child:
                !net.isConnected.value
                    ? OfflineActivity(onTap: net.retry)
                    : SmartRefresher(
                      controller: refreshCtrl,
                      header: WaterDropHeader(
                        waterDropColor: AppColors.secondaryColor,
                        idleIcon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        refresh: CircularProgressIndicator.adaptive(),
                        complete: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 3),
                            Text(
                              'hoorray!',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sora',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        failed: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Failed',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        completeDuration: Duration(seconds: 1),
                      ),
                      physics: AlwaysScrollableScrollPhysics(),
                      onRefresh: () async {
                        HapticFeedback.selectionClick();
                        await controller.refreshData();
                        reloadKey.value++;
                        refreshCtrl.refreshCompleted();
                        HapticFeedback.lightImpact();

                      },
                      
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
      
                        children: [
                          SizedBox(height: screenWt * 0.28),
      
                          greetingSearchBar(controller, context),
                          SizedBox(height: 10),
                          carousel(controller, context),
                          SizedBox(height: 15),
                          headerWithMore(
                            'Categories',
                            'See all',
                            () => Get.toNamed('/search'),
                          ),
                          SizedBox(height: 10),
                          categoryChips(),
                          SizedBox(height: 10),
                          headerWithMore(
                            'Today\'s Picks',
                            'See all',
                            () => Get.toNamed('/search'),
                          ),
                          SizedBox(height: 10),
                          Obx(
                            () => RandomProductsCarousel(
                              key: ValueKey('todays_picks_${reloadKey.value}'),
                              controller: productsCtrl,
                              count: 5,
                            ),
                          ),
                          SizedBox(height: 10),
                          headerWithMore(
                            'Affordables',
                            'See all',
                            () => Get.toNamed('/search'),
                          ),
                          SizedBox(height: 10),
                          Obx(
                            () => AffordableProductsCarousel(
                              key: ValueKey('affordables_${reloadKey.value}'),
                              count: 5,
                            ),
                          ),
                          SizedBox(height: 10),
                          headerWithMore(
                            'Delivery Time Table',
                            'Learn More',
                            () {},
                          ),
                          SizedBox(height: 10),
                          deliveryTimeTable(controller),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Widget categoryChips() {
    return FutureBuilder<List<String>>(
      future: CategoriesController().fetchAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
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
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Sora',
                  fontSize: 12,
                ),
              ),
            ),
          );
        }
        final cats = snapshot.data!;
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: cats.length,
            separatorBuilder: (_, __) => SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final name = cats[i];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(SearchActivity.routeName, arguments: name);
                },
                child: Chip(
                  label: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sora-SemiBold',
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: colors[i % colors.length],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget timeTable(dynamic context, Widget children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlurredBubbleChildable(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Sora-SemiBold',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: 'Order',
                              style: TextStyle(color: AppColors.primaryColour),
                            ),
                            TextSpan(text: ' Between'),
                          ],
                        ),
                      ),
                    ),
                    Text('&', style: TextStyle(fontFamily: 'Sora-SemiBold')),
                    BlurredBubbleChildable(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Sora-SemiBold',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: 'Get',
                              style: TextStyle(color: AppColors.primaryColour),
                            ),
                            TextSpan(text: ' Between'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timeTableItem(
    context, {
    required String orderStartTime,
    required String orderEndTime,
    required String getStartTime,
    required String getEndTime,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: BlurredBubbleChildableDark(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Sora-SemiBold',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(text: orderStartTime),
                    TextSpan(
                      text: '\nto\n',
                      style: TextStyle(
                        fontFamily: 'Sora-SemiBold',
                        fontSize: 10,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(text: orderEndTime),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Sora-SemiBold',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(text: getStartTime),
                    TextSpan(
                      text: '\nto\n',
                      style: TextStyle(
                        fontFamily: 'Sora-SemiBold',
                        fontSize: 10,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(text: getEndTime),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timeTableItemLive(
    context, {
    required String orderStartTime,
    required String orderEndTime,
    required String getStartTime,
    required String getEndTime,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: carousalPlaceholder(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Sora-SemiBold',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(text: orderStartTime),
                    TextSpan(
                      text: '\nto\n',
                      style: TextStyle(
                        fontFamily: 'Sora-SemiBold',
                        fontSize: 10,
                        color: AppColors.primaryColour,
                      ),
                    ),
                    TextSpan(text: orderEndTime),
                  ],
                ),
              ),
              Image.asset('assets/images/live.gif', width: 10, height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Sora-SemiBold',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(text: getStartTime),
                    TextSpan(
                      text: '\nto\n',
                      style: TextStyle(
                        fontFamily: 'Sora-SemiBold',
                        fontSize: 10,
                        color: AppColors.primaryColour,
                      ),
                    ),
                    TextSpan(text: getEndTime),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget greetingSearchBar(HomeController controller, dynamic context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Obx(() {
        return InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => Get.toNamed('/search'),
          child: AnimatedCrossFade(
            firstChild: squareContainer(
              widthPercent: 100,
              context: context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 10,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: controller.greeting.value,
                            style: TextStyle(fontFamily: 'Sora-Bold'),
                          ),
                          TextSpan(
                            text:
                                controller.greeting.value == 'Good night'
                                    ? ', See you the other day buddy'
                                    : ', How are you doing today?',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: squareContainer(
              widthPercent: 100,
              context: context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: 20),
                  const SizedBox(width: 2),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: ' Tap here to '),
                        TextSpan(
                          text: 'Search',
                          style: TextStyle(fontFamily: 'Sora-Bold'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState:
                controller.showSearchPrompt.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        );
      }),
    );
  }

  Widget carousel(HomeController controller, dynamic context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        items: [
          carousalPlaceholder(
            Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlurredBubble(text: 'Order your items within'),
                  SizedBox(height: 5),
                  Text(
                    controller.countdown.value,
                    style: TextStyle(
                      fontFamily: 'Sora-ExtraBold',
                      fontSize: 35,
                      color: AppColors.primaryColour,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'and get yours between',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        BlurredBubble(
                          text: controller.time1.value,
                          textStyle: TextStyle(
                            fontFamily: 'Sora-Bold',
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '&',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: BlurredBubble(
                            text: controller.time2.value,
                            textStyle: TextStyle(
                              fontFamily: 'Sora-Bold',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
          carousalPlaceholder(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlurredBubble(
                      text: 'free',
                      textStyle: TextStyle(
                        fontFamily: 'Sora-ExtraBold',
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'delivery :)',
                      style: TextStyle(
                        fontFamily: 'Sora-Bold',
                        fontSize: 25,
                        color: AppColors.primaryColour,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'for first',
                      style: TextStyle(fontFamily: 'Sora', fontSize: 12),
                    ),
                    SizedBox(width: 5),
                    BlurredBubble(
                      text: '5',
                      textStyle: TextStyle(
                        fontFamily: 'Sora-ExtraBold',
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'orders!',
                      style: TextStyle(fontFamily: 'Sora', fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          carousalPlaceholder(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 10, color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'Your',
                        style: TextStyle(fontFamily: 'Sora'),
                      ),
                      TextSpan(
                        text: ' feedback',
                        style: TextStyle(
                          fontFamily: 'Sora-Bold',
                          color: AppColors.primaryColour,
                        ),
                      ),
                      TextSpan(
                        text: ' is valuable to us!',
                        style: TextStyle(fontFamily: 'Sora'),
                      ),
                      TextSpan(
                        text:
                            '\nWrite to us and feel free to convey your concerns.',
                        style: TextStyle(fontFamily: 'Sora'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/foxiom_qr_white.png',
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.white.withAlpha(50),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        controller.openChat(context);
                      },
                      child: BlurredBubble(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        textStyle: TextStyle(
                          fontFamily: 'Sora-SemiBold',
                          fontSize: 8,
                        ),
                        text: 'Click here',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerWithMore(String title, String more, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Sora-Bold',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    more,
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 8,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget deliveryTimeTable(HomeController controller) {
    return StreamBuilder<DateTime>(
      stream: controller.timeStream,
      builder: (context, snap) {
        final now = snap.data ?? DateTime.now();

        final slots = <List<String>>[
          ['08:00', '10:00', '11:00', '11:30'],
          ['10:00', '12:00', '13:00', '13:30'],
          ['12:00', '14:00', '15:00', '15:30'],
          ['14:00', '16:00', '17:00', '17:30'],
          ['16:00', '18:00', '19:00', '19:30'],
        ];

        DateTime at(String hhmm) {
          final parts = hhmm.split(':').map(int.parse).toList();
          return DateTime(now.year, now.month, now.day, parts[0], parts[1]);
        }

        // compute which slot is live, or -1 for none
        int liveIndex = -1;
        for (var i = 0; i < slots.length; i++) {
          final start = at(slots[i][0]);
          final end = at(slots[i][1]);
          if (!now.isBefore(start) && now.isBefore(end)) {
            liveIndex = i;
            break;
          }
        }

        return timeTable(
          context,
          Column(
            children: List.generate(slots.length, (i) {
              final slot = slots[i];
              final isLive = (i == liveIndex);
              return isLive
                  ? timeTableItemLive(
                    context,
                    orderStartTime: slot[0],
                    orderEndTime: slot[1],
                    getStartTime: slot[2],
                    getEndTime: slot[3],
                  )
                  : timeTableItem(
                    context,
                    orderStartTime: slot[0],
                    orderEndTime: slot[1],
                    getStartTime: slot[2],
                    getEndTime: slot[3],
                  );
            }),
          ),
        );
      },
    );
  }
}
