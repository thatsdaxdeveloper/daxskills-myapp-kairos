import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgImage({required String path, double height = 180}) {
  return SvgPicture.asset(path, height: height.h, fit: BoxFit.cover);
}

Widget svgIcon({required String path, double size = 24, Color color = Colors.white}) {
  return SvgPicture.asset(path, height: size.h, width: size.h, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
}
