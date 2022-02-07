import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livq/theme/colors.dart';

class splashWidget extends StatefulWidget {
  const splashWidget({Key? key}) : super(key: key);

  @override
  _splashWidgetState createState() => _splashWidgetState();
}

class _splashWidgetState extends State<splashWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/splash_page/LiveQ_logo.gif"),
          SvgPicture.asset(
            "assets/splash_page/splash_text.svg",
            color: AppColors.primaryColor,
            height: 30.h,
            // width: 5.w,
          ),
        ],
      ),
    );
  }
}
