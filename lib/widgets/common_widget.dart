import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




Widget textWidget(String string, TextStyle style) {
  return Text(
    string,
    style: style,
  );
}

Widget sizedBoxWidget(int width, int height) {
  return SizedBox(
    width: width.w,
    height: height.h,
  );
}

Widget sizedBoxWithChild(int width, int height, Widget child) {
  return SizedBox(
    width: width.w,
    height: height.h,
    child: child,
  );
}
