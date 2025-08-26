import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';

class MyPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const MyPrimaryButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      splashColor: ThemeApp.eerieBlack.withValues(alpha: 0.3),
      highlightColor: ThemeApp.eerieBlack.withValues(alpha: 0.1),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        height: 40.h,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(text, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
