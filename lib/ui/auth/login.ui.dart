import 'package:ecom_one/animations/rotator.dart';
import 'package:ecom_one/controllers/auth/login.controller.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginActivity extends StatelessWidget {
  LoginActivity({super.key});
  static const routeName = '/login';

  final GlobalKey<RotatorState> loginRotatorKey = GlobalKey<RotatorState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final mdqry = MediaQuery.of(context);
    final isLandscape = mdqry.orientation == Orientation.landscape;
    final availableHt = mdqry.size.height - mdqry.viewInsets.bottom;
    final paddingWt = mdqry.size.height * (isLandscape ? 0.4 : 0.05);

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: availableHt,
          padding: EdgeInsets.symmetric(horizontal: paddingWt),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              screenHeading('log', 'IN', MainAxisAlignment.center),
              const SizedBox(height: 30),
              TextField(
                autocorrect: true,
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 12, fontFamily: 'Sora'),
                controller: controller.email,
                decoration: InputDecoration(
                  suffixIcon: Obx(
                    () => Icon(
                      Icons.check_circle,
                      color:
                          controller.isEmailValid.value
                              ? Colors.white
                              : Colors.grey[600],
                      size: 12,
                    ),
                  ),
                  labelText: 'email',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: darkLightButton('SIGNUP', () {
                      loginRotatorKey.currentState?.toggleRotate();
                      controller.navigateSignup(context);
                    }),
                  ),
                  const SizedBox(width: 15),
                  Rotator(key: loginRotatorKey),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ekdhamDarkYellowButton('LOGIN', () {
                      controller.attemptLogin(context);
                      if (controller.isLoading.value) {
                        loginRotatorKey.currentState?.rotateOn();
                      } else {
                        loginRotatorKey.currentState?.rotateOff();
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          !isLandscape
              ? Padding(
                padding: EdgeInsets.all(paddingWt),
                child: darkLightVendorButton('Are you a vendor?', () {
                  controller.navigateVendor(context);
                  loginRotatorKey.currentState?.toggleRotate();
                }, Icons.keyboard_arrow_down_rounded),
              )
              : SizedBox.shrink(),
    );
  }
}
