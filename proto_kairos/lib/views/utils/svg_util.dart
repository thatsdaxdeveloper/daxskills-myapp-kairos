import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';

Widget svgImage({required String path}) {
  return SvgPicture.asset(path, height: 180.h, fit: BoxFit.cover);
}

Widget svgIcon({required String path, double size = 24, Color color = Colors.white}) {
  return SvgPicture.asset(path, height: size.h, width: size.h, colorFilter: ColorFilter.mode(color, BlendMode.srcIn),);
}