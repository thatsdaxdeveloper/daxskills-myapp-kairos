
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgImage({required String path}) {
  return SvgPicture.asset(path, height: 180.h, fit: BoxFit.cover);
}