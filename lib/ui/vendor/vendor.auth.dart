import 'package:ecom_one/ui/auth/signup.ui.dart';
import 'package:ecom_one/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class VendorAuthActivity extends StatelessWidget {
  const VendorAuthActivity({super.key});
  static const routeName = '/vendor_auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            darkLightButton('back', () {
              Navigator.push(
                context,
                PageTransition(
                  child: SignupActivity(),
                  childCurrent: VendorAuthActivity(),
                  type: PageTransitionType.topToBottomJoined,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
