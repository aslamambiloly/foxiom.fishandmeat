import 'package:ecom_one/ui/auth/login.ui.dart';
import 'package:ecom_one/ui/auth/signup.ui.dart';
import 'package:ecom_one/ui/vendor/vendor.auth.dart';
import 'package:ecom_one/ui/auth/verify.ui.dart';
import 'package:ecom_one/services/country_code/country_code.dart';
import 'package:ecom_one/utils/toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ecom_one/services/api/auth.api.dart';

class SignupController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final Rx<CountryCode?> selectedCountryCode = Rx<CountryCode?>(null);
  final selectedDialCode = '+91'.obs;

  String? countryInitialCode;
  String? dialInitialCode;

  var isLoading = false.obs;
  var isAnimated = false.obs;
  var showContent = false.obs;
  var isSlidingActivated = true.obs;

  var emailText = ''.obs;
  var phoneText = ''.obs;
  var nameText = ''.obs;
  var isEmailValid = false.obs;
  var isPhoneValid = false.obs;
  var isNameValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    email.addListener(validateEmail);
    phone.addListener(validatePhone);
    name.addListener(validateName);
  }

  void validateEmail() {
    emailText.value = email.text;
    isEmailValid.value = EmailValidator.validate(email.text);
  }

  String get fullPhoneNumber {
    final dial = selectedCountryCode.value?.dialCode ?? '';
    return '$dial${phone.text.trim()}';
  }

  void validatePhone() {
    phoneText.value = phone.text;
    if (phoneText.value.length == 10) {
      isPhoneValid.value = true;
    } else {
      isPhoneValid.value = false;
    }
  }

  void validateName() {
    nameText.value = name.text;
    if (nameText.value.length > 2 && nameText.value.length <= 15) {
      isNameValid.value = true;
    } else {
      isNameValid.value = false;
    }
  }

  void toggleSlideActivation() {
    isSlidingActivated.value = !isSlidingActivated.value;
  }

  @override
  void onClose() {
    email.removeListener(validateEmail);
    phone.removeListener(validatePhone);
    name.removeListener(validateName);
    email.dispose();
    phone.dispose();
    name.dispose();
    super.onClose();
  }

  void toggleCard() {
    if (!isAnimated.value) {
      isAnimated.value = true;

      Future.delayed(Duration(seconds: 1), () {
        showContent.value = true;
      });
    } else {
      showContent.value = false;

      Future.delayed(Duration(milliseconds: 300), () {
        isAnimated.value = false;
      });
    }
  }

  void toggleLoading() {
    Future.delayed(Duration(seconds: 1, milliseconds: 200), () {
      isLoading.value = !isLoading.value;
    });
  }

  void validateCredentialsAndSignup(context, {VoidCallback? onSuccess}) async {
    if (name.text.isEmpty) {
      ToastHelper.showErrorToast(
        context,
        'Invalid Credentials',
        'Enter a username to continue',
      );
      return;
    } else if (name.text.length < 3 || name.text.length > 15) {
      ToastHelper.showErrorToast(
        context,
        'Invalid Credentials',
        'Enter a username with atleast 3-15 letters to continue',
      );
      return;
    } else if (email.text.isEmpty) {
      ToastHelper.showErrorToast(
        context,
        'Invalid Credentials',
        'Enter a mail address to continue',
      );
      return;
    } else if (!EmailValidator.validate(email.text)) {
      ToastHelper.showErrorToast(
        context,
        'Invalid Credentials',
        'Enter a valid mail address to continue',
      );
      return;
    } else if (phone.text.isEmpty || phone.text.length < 10) {
      ToastHelper.showErrorToast(
        context,
        'Invalid Phone',
        'Enter a phone number not less than 10 to continue',
      );
      return;
    }

    if (onSuccess != null) onSuccess();

    final response = await AuthApi().register(
      username: name.text,
      email: email.text,
      mobile: fullPhoneNumber,
    );

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
        'Registration Failed',
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
          childCurrent: SignupActivity(),
          type: PageTransitionType.bottomToTopJoined,
          duration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  void navigateLogin(context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        PageTransition(
          child: LoginActivity(),
          childCurrent: SignupActivity(),
          type: PageTransitionType.leftToRightJoined,
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
        childCurrent: SignupActivity(),
        type: PageTransitionType.rightToLeftJoined,
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}
