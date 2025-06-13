import 'dart:ui';

import 'package:ecom_one/animations/icon.button.dart';
import 'package:ecom_one/ui/dashboard/cart.dart';
import 'package:ecom_one/ui/dashboard/home.ui.dart';
import 'package:ecom_one/ui/dashboard/orders.dart';
import 'package:ecom_one/ui/dashboard/settings.dart';
import 'package:ecom_one/services/location/location.dart';
import 'package:ecom_one/utils/colors.dart';
import 'package:ecom_one/utils/toast.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var username = ''.obs;
  var address = 'Fetch Location'.obs;
  var contentScrollOffset = 0.0.obs;
  final pageController = PageController();
  var isScrollingDown = false.obs;

  final pages = [
    HomeActivity(),
    CartActivity(),
    OrdersActivity(),
    SettingsActivity(),
  ];

  @override
  void onInit() {
    super.onInit();
    getUsername();
    getLocationPref();
  }

  Future<void> showMyLocation(context) async {
    try {
      Position pos = await LocationService.getCurrentLocation();
      ToastHelper.showSuccessToast(
        context,
        'Location Fetched Successfully',
        'Latitude: ${pos.latitude}, Longitude: ${pos.longitude}',
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final p = placemarks.first;
      address.value = '${p.street}, ${p.locality}, ${p.country}';

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('location', address.value);
    } catch (e) {
      ToastHelper.showErrorToast(context, 'Location Fetching Failed', '$e');
    }
  }

  Future<void> getLocationPref() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('location');
    if (location != null) {
      address.value = location;
    } else {
      address.value = 'Fetch Location';
    }
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    username.value = name!;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class DashboardActivity extends StatelessWidget {
  static const routeName = '/dashboard';
  final DashboardController controller = Get.put(DashboardController());

  DashboardActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final mdqry = MediaQuery.of(context);
    final screenHt = mdqry.size.height;
    final screenWt = mdqry.size.width;

    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notif) {
          if (notif is ScrollUpdateNotification) {
            controller.isScrollingDown.value = notif.scrollDelta! > 0;
          }
          return false;
        },
        child: Stack(
          children: [
            
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: BouncingScrollPhysics(),
              children: controller.pages,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
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
            ),
            
            Positioned(
              left: screenWt * 0.05,
              right: screenWt * 0.05,
              bottom: screenHt * 0.03,
              child: Obx(
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _navItem(0, Icons.home, 'Orders', controller),
                          SizedBox(width: 5),
                          _navItem(1, Icons.shopping_cart, 'Cart', controller),
                          SizedBox(width: 5),
                          _navItem(
                            2,
                            Icons.shopping_bag_rounded,
                            'Orders',
                            controller,
                          ),
                          SizedBox(width: 5),
                          _navItem(3, Icons.settings, 'Settings', controller),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
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
            ),
    
            Positioned(
              left: 20,
              top: screenHt * 0.07,
              child: Obx(() {
                return AnimatedOpacity(
                  opacity: controller.isScrollingDown.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.person,
                                        color: AppColors.primaryColour,
                                      ),
                                      SizedBox(width: 5),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'hello ',
                                              style: TextStyle(
                                                fontFamily: 'Sora',
                                                //color: Color(0xFFffea00)
                                              ),
                                            ),
                                            TextSpan(
                                              text: controller.username.value,
                                              style: TextStyle(
                                                fontFamily: 'Sora-Bold',
                                                fontSize: 15,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => controller.showMyLocation(context),
                                child: Text(
                                  controller.address.value,
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            Positioned(
              top: screenHt * 0.07,
              right: 20,
              child: Column(
                children: [
                  AnimatedIconButton(
                    icon: Icons.menu_rounded,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ekdhamDarkIconRadioButton(
                          Icons.accessibility_new_rounded,
                          'todo',
                          () {},
                        ),
                        SizedBox(height: 10),
                        ekdhamDarkIconRadioButton(
                          Icons.accessibility_new_rounded,
                          'todo',
                          () {},
                        ),
                        SizedBox(height: 10),
                        ekdhamDarkIconRadioButton(
                          Icons.accessibility_new_rounded,
                          'todo',
                          () {},
                        ),
                        SizedBox(height: 10),
                        ekdhamDarkIconRadioButton(
                          Icons.accessibility_new_rounded,
                          'todo',
                          () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    int pos,
    IconData iconData,
    String title,
    DashboardController controller,
  ) {
    final selected = controller.selectedIndex.value == pos;
    return GestureDetector(
      onTap: () => controller.changeIndex(pos),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Icon(
              iconData,
              size: 25,
              color: selected ? AppColors.foxiomOriginalBlue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
