import 'package:ecom_one/animations/rotator.dart';
import 'package:ecom_one/controllers/auth/signup.controller.dart';
import 'package:ecom_one/services/country_code/country_code_picker.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupActivity extends StatelessWidget {
  SignupActivity({super.key});
  static const routeName = '/signup';

  final GlobalKey<RotatorState> signupRotatorKey = GlobalKey<RotatorState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
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
              screenHeading('sign', 'UP', MainAxisAlignment.center),
              SizedBox(height: 30),
              TextField(
                autocorrect: false,
                cursorColor: Colors.white,
                keyboardType: TextInputType.name,
                style: TextStyle(fontSize: 12, fontFamily: 'Sora-SemiBold'),
                controller: controller.name,
                decoration: InputDecoration(
                  suffixIcon: Obx(
                    () => Icon(
                      Icons.check_circle,
                      color:
                          controller.isNameValid.value
                              ? Colors.white
                              : Colors.grey[600],
                      size: 12,
                    ),
                  ),
                  labelText: 'username',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                autocorrect: false,
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 12, fontFamily: 'Sora-SemiBold'),
                obscureText: false,
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
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Obx(
                    () => Material(
                      color: Color(0xFF2F2F2F),
                      borderRadius: BorderRadius.circular(15),

                      child: CountryCodePicker(
                        initialSelection:
                            controller.selectedCountryCode.value?.code,
                        favorite: ['+91', 'IN'],
                        showFlag: true,
                        onChanged:
                            (cc) => controller.selectedCountryCode.value = cc,
                      ).paddingOnly(left: 8, right: 8),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        if (val.length == 10) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      autocorrect: false,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Sora-SemiBold',
                      ),
                      obscureText: false,
                      controller: controller.phone,
                      decoration: InputDecoration(
                        suffixIcon: Obx(
                          () => Icon(
                            Icons.check_circle,
                            color:
                                controller.isPhoneValid.value
                                    ? Colors.white
                                    : Colors.grey[600],
                            size: 12,
                          ),
                        ),
                        labelText: 'phone',
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: darkLightButton('LOGIN', () {
                      FocusScope.of(context).unfocus();
                      signupRotatorKey.currentState?.toggleRotate();
                      controller.navigateLogin(context);
                    }),
                  ),
                  const SizedBox(width: 15),
                  Rotator(key: signupRotatorKey),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ekdhamDarkYellowButton('SIGNUP', () {
                      FocusScope.of(context).unfocus();
                      controller.validateCredentialsAndSignup(
                        context,
                        onSuccess: () {
                          Future.delayed(Duration(milliseconds: 100), () {
                            signupRotatorKey.currentState?.toggleRotate();
                          });
                        },
                      );
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
                  signupRotatorKey.currentState?.toggleRotate();
                }, Icons.keyboard_arrow_down_rounded),
              )
              : SizedBox.shrink(),
    );
  }
}

