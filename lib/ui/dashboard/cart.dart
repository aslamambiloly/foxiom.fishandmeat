import 'package:ecom_one/controllers/dashboard/network.controller.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartActivity extends StatelessWidget {
  const CartActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final net = Get.find<NetworkController>();
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child:
                !net.isConnected.value
                    ? Center(
                      key: ValueKey('offline'),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Oops! It seems like you are offline',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          blueLightButton('retry', () {
                            net.retry();
                          }),
                        ],
                      ),
                    )
                    : Center(
                      key: ValueKey('online'),

                      child: Text(
                        'Cart activity is under development',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
