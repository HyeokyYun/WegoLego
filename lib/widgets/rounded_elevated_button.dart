import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livq/theme/colors.dart';
import '../config.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({
    Key? key,
    @required this.title,
    @required this.onPressed,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String? title;
  final onPressed, padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(49),
      width: ScreenUtil().setWidth(287),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title!,
          style: TextStyle(
              //color: Colors.white,
              fontSize: Config.screenWidth! * 0.04),
        ),
        style: ElevatedButton.styleFrom(
          padding: padding,
          primary: AppColors.primaryColor[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
