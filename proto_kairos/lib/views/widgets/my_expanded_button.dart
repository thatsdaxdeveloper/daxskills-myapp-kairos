import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';

class MyExpandedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double opacity;

  const MyExpandedButton({
    super.key,
    required this.text,
    this.onTap,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext _context) {
    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        splashColor: ThemeApp.eerieBlack.withValues(alpha: 0.3),
        highlightColor: ThemeApp.eerieBlack.withValues(alpha: 0.1),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: 1.sw / 1.3,
          height: 40.h,
          decoration: BoxDecoration(
            color: Theme.of(_context).primaryColor.withValues(alpha:
              opacity,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text(
              text,
              style: Theme.of(_context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: onTap != null ? Colors.white : Colors.white.withValues(alpha: opacity + 0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
