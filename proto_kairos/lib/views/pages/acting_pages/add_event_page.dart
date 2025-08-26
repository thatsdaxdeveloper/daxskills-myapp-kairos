import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/controllers/date_picker_control.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => context.pop(),
            child: Center(child: svgIcon(path: Assets.arrowToLeftSvgrepoCom)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nouvel événement", style: textTheme.headlineMedium),
            Text("Créez un nouveau compte à rebours", style: textTheme.labelMedium),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
        child: Column(
          children: [
            // Champs pour la date
            DatePickerControl(),

            // Champs pour le titre

            // Bouton de soumission
          ],
        ),
      ),
    );
  }
}
