import 'package:ecom_one/ui/auth/login.ui.dart';
import 'package:ecom_one/ui/auth/signup.ui.dart';
import 'package:ecom_one/ui/vendor/vendor.auth.dart';
import 'package:ecom_one/ui/auth/verify.ui.dart';
import 'package:ecom_one/services/api/auth.api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ecom_one/utils/toast.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  var isLoading = false.obs;
  final emailText = ''.obs;
  final isEmailValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    email.addListener(validateEmail);
  }

  void validateEmail() {
    emailText.value = email.text;
    isEmailValid.value = EmailValidator.validate(email.text);
  }

  @override
  void onClose() {
    email.removeListener(validateEmail);
    email.dispose();
    super.onClose();
  }

  void attemptLogin(context) async {
    if (email.text.isEmpty || !EmailValidator.validate(email.text)) {
      ToastHelper.showErrorToast(
        context,
        'Invalid Credentials',
        'Please enter a valid email to continue',
      );
      return;
    }
    isLoading.value = true;
    final response = await AuthApi().login(email: email.text);
    isLoading.value = false;

    if (response['success'] == true) {
      ToastHelper.showSuccessToast(
        context,
        'Success',
        response['message'] ?? 'OTP sent successfully',
      );
      navigateVerifyUser(context);
    } else {
      ToastHelper.showErrorToast(
        context,
        'Login Failed',
        response['message'] ?? 'Unknown error occurred',
      );
    }
  }

  void navigateVendor(context) {
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.push(
        context,
        PageTransition(
          child: VendorAuthActivity(),
          childCurrent: LoginActivity(),
          type: PageTransitionType.bottomToTopJoined,
          duration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  void navigateSignup(context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        PageTransition(
          child: SignupActivity(),
          childCurrent: LoginActivity(),
          type: PageTransitionType.rightToLeftJoined,
          duration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  void navigateVerifyUser(context) {
    Navigator.push(
      context,
      PageTransition(
        child: VerifyUserActivity(email: email.text),
        childCurrent: LoginActivity(),
        type: PageTransitionType.rightToLeftJoined,
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}
