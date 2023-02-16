import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livq/theme/colors.dart';

class splashWidget extends StatefulWidget {
  const splashWidget({Key? key}) : super(key: key);

  @override
  _splashWidgetState createState() => _splashWidgetState();
}

class _splashWidgetState extends State<splashWidget>
//with TickerProviderStateMixin
{
  // late FlutterGifController gifController;

  // @override
  // void initState() {
  //   gifController = FlutterGifController(vsync: this);

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   gifController.repeat(
    //     min: 0,
    //     max: 89,
    //     period: const Duration(milliseconds: 2300),
    //   );
    // });
    return Container(
      color: AppColors.primaryColor[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GifImage(
          //     image: AssetImage("assets/splash_page/LiveQ_logo.gif"),
          //     controller: gifController),
          SvgPicture.asset(
            "assets/liveQ_logo.svg",
            // color: AppColors.primaryColor,
            height: 100.h,
            // width: 5.w,
          ),
          SizedBox(
            height: 20.h,
          ),
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
