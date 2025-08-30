import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/pages/home_page.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';

class ScaffoldControl extends StatefulWidget {
  const ScaffoldControl({super.key});

  @override
  State<ScaffoldControl> createState() => _ScaffoldControlState();
}

class _ScaffoldControlState extends State<ScaffoldControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(1.sw, 30.h),
        child: Align(
          alignment: Alignment(0.9, 0.6),
          child: GestureDetector(
            onTap: () => context.push('/home/add'),
            child: Text(
              "Ajouter un événement",
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: ThemeApp.tropicalIndigo, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: HomePage(),
      // floatingActionButton: _buildFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFloatingActionButton() {
    return InkWell(
      onTap: () => context.push('/home/add'),
      borderRadius: BorderRadius.circular(20.r),
      splashColor: ThemeApp.eerieBlack.withValues(alpha: 0.3),
      highlightColor: ThemeApp.eerieBlack.withValues(alpha: 0.1),
      child: Ink(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
          color: ThemeApp.trueWhite.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(child: svgIcon(path: Assets.plusSvgrepoCom, size: 32)),
      ),
    );
  }
}
