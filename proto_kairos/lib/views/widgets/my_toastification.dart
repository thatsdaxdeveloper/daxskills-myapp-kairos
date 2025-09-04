import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';

class MyToastification extends StatelessWidget {
  final bool isSuccess;
  final bool isError;
  final String message;

  const MyToastification({super.key, this.isSuccess = false, this.isError = false, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IntrinsicWidth(
        child: Container(
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Row(
              children: [
                isSuccess || isError
                    ? svgIcon(path: isError ? Assets.infoCircleSvgrepoCom : Assets.checkCircleSvgrepoCom, size: 16)
                    : SizedBox.shrink(),
                if (isSuccess || isError) SizedBox(width: 8.w),
                Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(color: ThemeApp.trueWhite, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
