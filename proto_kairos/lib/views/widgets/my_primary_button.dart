import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPrimaryButton extends StatelessWidget {
  final String text;
  const MyPrimaryButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
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
