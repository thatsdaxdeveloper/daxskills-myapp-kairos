import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
      child: Center(child: Text("Home")),
    );
  }
}
