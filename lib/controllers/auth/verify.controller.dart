import 'dart:async';
import 'package:ecom_one/ui/dashboard.dart';
import 'package:ecom_one/ui/auth/signup.ui.dart';
import 'package:ecom_one/ui/vendor/vendor.auth.dart';
import 'package:ecom_one/ui/auth/verify.ui.dart';
import 'package:ecom_one/services/api/auth.api.dart';
import 'package:ecom_one/utils/toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController otpField = TextEditingController();
  static const int _timeoutSeconds = 60;

  final isTimerOn = false.obs;
  final secondsRemaining = 0.obs;
  Timer? resendTimer;
  final otpText = ''.obs;
  final isOtpValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  @override
  void onClose() {
    resendTimer?.cancel();
    super.onClose();
  }

  void startResendTimer() {
    secondsRemaining.value = _timeoutSeconds;
    isTimerOn.value = true;

    //cancel any old timer
    resendTimer?.cancel();

    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 1) {
        timer.cancel();
        isTimerOn.value = false;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  Future<bool> verifyOtp({
    required context,
    required String email,
    required String otp,
  }) async {
    final response = await AuthApi().verify(email: email, otp: otp);

    if (response['success'] == true) {
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('username', data['username']);
        await prefs.setString('email', email);
      }
      ToastHelper.showSuccessToast(
        context,
        'Success',
        response['message'] ?? 'OTP verified successfully',
      );
      Get.offNamed('/dashboard');
      return true;
    } else {
      ToastHelper.showErrorToast(
        context,
        'Verification Failed',
        response['message'] ?? 'Unknown error occurred',
      );
      return false;
    }
  }

  Future<void> resendOtp({required context, required String email}) async {
    final response = await AuthApi().resend(email: email);
    if (response['success'] == true) {
      ToastHelper.showSuccessToast(
        context,
        'Success',
        response['message'] ?? 'OTP requested successfully',
      );
      return;
    } else {
      ToastHelper.showErrorToast(
        context,
        'Request Failed',
        response['message'] ?? 'Unknown error occurred',
      );
      return;
    }
  }

  void navigateHome(context) {
    Navigator.push(
      context,
      PageTransition(
        child: DashboardActivity(),
        childCurrent: VerifyUserActivity(),
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  void navigateVendor(context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        PageTransition(
          child: VendorAuthActivity(),
          childCurrent: VerifyUserActivity(),
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
          childCurrent: VerifyUserActivity(),
          type: PageTransitionType.leftToRightJoined,
          duration: Duration(milliseconds: 500),
        ),
      );
    });
  }
}
