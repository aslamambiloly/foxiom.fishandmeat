import 'package:ecom_one/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpInput extends StatelessWidget {
  final Function(String) onCompleted;

  const OtpInput({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: 6,
      borderColor: Colors.transparent,
      focusedBorderColor: AppColors.secondaryColor,
      showCursor: false,
      showFieldAsBox: true,
      borderRadius: BorderRadius.circular(15),
      fieldWidth: 45,
      filled: true,
      fillColor: Color(0xFF2F2F2F),
      enabledBorderColor: Color(0xFF2F2F2F),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'Sora-SemiBold',
      ),
      onSubmit: onCompleted,
    );
  }
}
