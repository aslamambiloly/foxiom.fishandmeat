import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ecom_one/utils/colors.dart';

Row screenHeading(
  String mainText,
  String subText,
  MainAxisAlignment alignment,
) {
  return Row(
    mainAxisAlignment: alignment,
    children: [
      Text(mainText, style: TextStyle(fontSize: 22, fontFamily: 'Sora-Bold')),
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2, right: 4, left: 4),
          child: Text(
            subText,
            style: TextStyle(
              color: AppColors.primaryColour,
              fontFamily: 'Sora-SemiBold',
            ),
          ),
        ),
      ),
    ],
  );
}

Card darkYellowButton(String text, VoidCallback onTap, {double fontSize = 12}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    child: Material(
      color: Color(0xFF2F2F2F),
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Sora-Bold',
              color: AppColors.primaryColour,
            ),
          ),
        ),
      ),
    ),
  );
}

Card ekdhamDarkYellowButton(
  String label,
  VoidCallback onTap, {
  double fontSize = 12,
  IconData? icon,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Sora-Bold',
                  color: AppColors.primaryColour,
                ),
              ),
              if (icon != null) ...[
                Icon(icon, size: 20, color: Color(0XFFFEFFFE)),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

Card ekdhamDarkTimerButton(
  String label, {
  double fontSize = 12,
  IconData? icon,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Sora-Bold',
                color: AppColors.primaryColour,
              ),
            ),
            icon != null
                ? Icon(icon, size: 20, color: Color(0XFFFEFFFE))
                : SizedBox(width: 0.0001),
          ],
        ),
      ),
    ),
  );
}

Card lightDarkButton(String text, VoidCallback onTap, {double fontSize = 12}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      color: Color(0xFFFEFFFE),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Sora-Bold',
              color: Color(0xFF2F2F2F),
            ),
          ),
        ),
      ),
    ),
  );
}

Card blueLightButton(
  String text,
  VoidCallback onTap, {
  double fontSize = 12,
  IconData? icon,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      color: AppColors.foxiomOriginalBlue,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Sora-Bold',
                  color: AppColors.greenishWhite,
                ),
              ),
              icon != null
                  ? Icon(icon, size: 20, color: Color(0xFF2F2F2F))
                  : SizedBox(width: 0.0001),
            ],
          ),
        ),
      ),
    ),
  );
}

Card blueLightIconButton(VoidCallback onTap, {required IconData icon}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      color: AppColors.foxiomOriginalBlue,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Icon(icon, size: 20, color: Color(0xFF2F2F2F)),
        ),
      ),
    ),
  );
}

Card darkLightButton(
  String text,
  VoidCallback onTap, {
  double fontSize = 12,
  IconData? icon,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      color: Color(0xFF2F2F2F),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Sora-Bold',
                  color: Color(0XFFFEFFFE),
                ),
              ),
              icon != null
                  ? Icon(icon, size: 20, color: Color(0XFFFEFFFE))
                  : SizedBox(width: 0.0001),
            ],
          ),
        ),
      ),
    ),
  );
}

Card darkLightVendorButton(
  String text,
  VoidCallback onTap,
  IconData? icon, {
  double fontSize = 12,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Material(
      color: Color(0xFF2F2F2F),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 12.0, 30.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Sora-Bold',
                  color: Color(0XFFFEFFFE),
                ),
              ),
              Icon(icon, size: 20, color: Color(0XFFFEFFFE)),
            ],
          ),
        ),
      ),
    ),
  );
}

Card ekdhamDarkIconButton(
  IconData icon,
  String label,
  VoidCallback onTap, {
  double fontSize = 12,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Material(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Icon(icon, color: Color(0xff58abdb)),
              SizedBox(width: 5),
              Text(label, style: TextStyle(fontSize: 12)),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    ),
  );
}

Card ekdhamDarkIconRadioButton(
  IconData icon,
  String label,
  VoidCallback onTap, {
  bool isSelected = false,
  double fontSize = 12,
}) {
  return Card(
    elevation: isSelected ? 8 : 2,
    color: isSelected ? Color(0xff58abdb) : Color(0xFF141218),
    shadowColor: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Material(
      color: isSelected ? Color(0xff58abdb) : Color(0xFF141218),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Icon(icon, color: isSelected ? Colors.black : Color(0xff58abdb)),
              SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isSelected ? Colors.black : Color(0xfffefffe),
                  fontFamily: isSelected ? 'Sora-Bold' : 'Sora',
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    ),
  );
}

AnimatedBuilder rotator(
  AnimationController controller,
  BuildContext context,
  Widget? widget,
) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, widget) {
      return Transform.rotate(
        angle: controller.value * 2.0 * 3.141,
        child: widget,
      );
    },
    child: widget,
  );
}

Widget carousalPlaceholder(Widget child) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        width: 500,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blue.withAlpha(50), Colors.white.withAlpha(10)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: child,
      ),
    ),
  );
}

Widget squareContainer({
  Color color = Colors.transparent,
  required BuildContext context,
  required Widget child,
  double widthPercent = 25,
  double heightPercent = 10,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * widthPercent / 100,
        height: MediaQuery.of(context).size.width * heightPercent / 100,
        child: Padding(padding: EdgeInsets.all(10.0), child: child),
      ),
    ),
  );
}

Widget blueSquareContainer({
  Color color = AppColors.secondaryColor,
  required BuildContext context,
  required Widget child,
  double widthPercent = 25,
  double heightPercent = 10,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * widthPercent / 100,
        height: MediaQuery.of(context).size.width * heightPercent / 100,
        child: Padding(padding: EdgeInsets.all(10.0), child: child),
      ),
    ),
  );
}

Widget imageButton(VoidCallback onTap, Image image) {
  return Card(
    elevation: 4,
    color: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    child: InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40,
            height: 40,
            color: Colors.white.withAlpha((0.1 * 255).round()),
            child: Center(child: image),
          ),
        ),
      ),
    ),
  );
}

Widget starOpacity(avgRating, double size) {
  if (avgRating <= 1) {
    return Icon(
      Icons.stars_rounded,
      size: size,
      color: Colors.grey.withAlpha(250),
    );
  } else if (avgRating <= 2.5) {
    return Icon(
      Icons.stars_rounded,
      size: size,
      color: Colors.amberAccent.withAlpha(100),
    );
  } else if (avgRating <= 3.5) {
    return Icon(
      Icons.stars_rounded,
      size: size,
      color: Colors.amberAccent.withAlpha(150),
    );
  } else if (avgRating <= 4.5) {
    return Icon(
      Icons.stars_rounded,
      size: size,
      color: Colors.amberAccent.withAlpha(200),
    );
  } else {
    return Icon(
      Icons.stars_rounded,
      size: size,
      color: Colors.amberAccent.withAlpha(255),
    );
  }
}
