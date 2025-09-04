import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proto_kairos/views/widgets/my_toastification.dart';

void showMyToastification({
  required BuildContext context,
  required String message,
  bool isSuccess = false,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.none,
      margin: EdgeInsets.only(bottom: 1.sh / 1.3),
      content: MyToastification(
        message: message,
        isSuccess: isSuccess,
        isError: isError,
      ),
    ),
  );
}