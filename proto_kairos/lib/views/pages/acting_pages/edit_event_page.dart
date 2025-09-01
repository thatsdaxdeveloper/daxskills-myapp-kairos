import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/controllers/edit_event_control.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';

class EditEventPage extends StatelessWidget {
  const EditEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () => context.pop(),
              child: Center(child: svgIcon(path: Assets.arrowToLeftSvgrepoCom)),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Modifier l'événemen", style: textTheme.headlineMedium),
              Text("Ajustez les détails de votre compte à rebours", style: textTheme.labelMedium),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
          child: SingleChildScrollView(child: EditEventControl()),
        ),
      ),
    );
  }
}
