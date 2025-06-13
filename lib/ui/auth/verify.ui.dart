import 'package:ecom_one/animations/rotator.dart';
import 'package:ecom_one/controllers/auth/verify.controller.dart';
import 'package:ecom_one/utils/otp.field.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyUserActivity extends StatelessWidget {
  final String email;
  VerifyUserActivity({super.key, this.email = ''});
  static const routeName = '/verify';

  final GlobalKey<RotatorState> verifyRotatorKey = GlobalKey<RotatorState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyController());
    final mdqry = MediaQuery.of(context);
    final isLandscape = mdqry.orientation == Orientation.landscape;
    final availableHt = mdqry.size.height - mdqry.viewInsets.bottom;
    final paddingWt = mdqry.size.height * (isLandscape ? 0.4 : 0.05);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: availableHt,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              screenHeading('verify', 'OTP', MainAxisAlignment.center),
              SizedBox(height: 30),
              OtpInput(
                onCompleted: (code) async {
                  verifyRotatorKey.currentState?.toggleRotate();

                  final success = await controller.verifyOtp(
                    context: context,
                    email: email,
                    otp: code,
                  );

                  if (!success) {
                    verifyRotatorKey.currentState?.toggleRotate();
                  }
                },
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingWt),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: darkLightButton('BACK', () {
                        verifyRotatorKey.currentState?.toggleRotate();
                        controller.navigateSignup(context);
                      }),
                    ),
                    SizedBox(width: 15),
                    Rotator(key: verifyRotatorKey),
                    SizedBox(width: 15),
                    Expanded(
                      child: Obx(() {
                        if (controller.isTimerOn.value) {
                          return ekdhamDarkTimerButton(
                            '00:${controller.secondsRemaining.value}',
                          );
                        } else {
                          return ekdhamDarkYellowButton('RESEND', () async {
                            controller.startResendTimer();
                            await controller.resendOtp(
                              context: context,
                              email: email,
                            );
                          });
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(40.0),
        child: darkLightVendorButton('Didn\'t recieved OTP?', () {
          verifyRotatorKey.currentState?.toggleRotate();
        }, Icons.keyboard_arrow_down_rounded),
      ),
    );
  }
}
