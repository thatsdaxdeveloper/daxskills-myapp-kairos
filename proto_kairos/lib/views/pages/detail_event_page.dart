import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/controllers/providers/countdown_provider.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';
import 'package:provider/provider.dart';

class DetailEventPage extends StatelessWidget {
  final String eventId;
  const DetailEventPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<CountdownProvider>(
      builder: (context, countdownProvider, _) {
        final event = countdownProvider.countdowns.firstWhere((element) => element.id == eventId);
        return Scaffold(
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
              Text("Détails de l'événement", style: textTheme.headlineMedium),
              Text("Visualisez et gérez votre compte à rebours", style: textTheme.labelMedium),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => context.push('/home/detail/edit', extra: {"eventId": eventId}),
              child: Center(child: svgIcon(path: Assets.editSvgrepoCom)),
            ),
            SizedBox(width: 20.w),
          ],
        ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: textTheme.headlineLarge,),
                  SizedBox(height: 20.h),

                  _buildSectionTitle(context, "Informations complémentaires"),
                  Text(
                    event.description?.isNotEmpty == true
                        ? event.description!
                        : "Aucune description disponible",
                    style: textTheme.bodySmall?.copyWith(
                      color: event.description?.isNotEmpty == true
                          ? ThemeApp.trueWhite
                          : ThemeApp.trueWhite.withValues(alpha: 0.4),
                    ),
                    textAlign: TextAlign.start,
                  ),

                  _buildSectionTitle(context, "Jour prévu"),
                  Text(event.targetDate.toString(), style: textTheme.headlineSmall,),

                  _buildSectionTitle(context, "Horaire précis"),
                  Row(
                    children: [
                      Text(event.targetDate.hour.toString().padLeft(2, "0"), style: textTheme.headlineSmall,),
                      Text(" : ", style: textTheme.headlineSmall,),
                      Text(event.targetDate.hour.toString().padLeft(2, "0"), style: textTheme.headlineSmall,),
                    ],
                  ),
                ],
              ),
            ),
          ),
      );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(title, style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
