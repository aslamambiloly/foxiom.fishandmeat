import 'package:ecom_one/controllers/dashboard/network.controller.dart';
import 'package:ecom_one/ui/dashboard.dart';
import 'package:ecom_one/ui/dashboard/home.ui.dart';
import 'package:ecom_one/ui/auth/login.ui.dart';
import 'package:ecom_one/ui/auth/signup.ui.dart';
import 'package:ecom_one/ui/dashboard/search.ui.dart';
import 'package:ecom_one/ui/splash.dart';
import 'package:ecom_one/ui/auth/verify.ui.dart';
import 'package:ecom_one/utils/theme.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<NetworkController>(NetworkController(), permanent: true);

  runApp(MainActivity());
  //debugPaintSizeEnabled = true;
}

class MainActivity extends StatelessWidget {
  const MainActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme,
      initialRoute: SplashActivity.routeName,
      getPages: [
        GetPage(name: SplashActivity.routeName, page: () => SplashActivity()),
        GetPage(
          name: LoginActivity.routeName,
          page: () => LoginActivity(),
          transition: Transition.rightToLeft,
          transitionDuration: Duration(milliseconds: 200),
        ),
        GetPage(name: SignupActivity.routeName, page: () => SignupActivity()),
        GetPage(
          name: HomeActivity.routeName,
          page: () => HomeActivity(),
          transition: Transition.rightToLeft,
          transitionDuration: Duration(milliseconds: 200),
        ),
        GetPage(
          name: DashboardActivity.routeName,
          page: () => DashboardActivity(),
          transition: Transition.rightToLeft,
          transitionDuration: Duration(milliseconds: 300),
        ),
        GetPage(
          name: VerifyUserActivity.routeName,
          page: () => VerifyUserActivity(),
        ),
        GetPage(name: SearchActivity.routeName, page: () => SearchActivity()),
      ],
    );
  }
}
