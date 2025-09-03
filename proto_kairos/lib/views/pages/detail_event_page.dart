import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:proto_kairos/controllers/countdown_timer_control.dart';
import 'package:proto_kairos/controllers/providers/countdown_provider.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/formatted_date_util.dart';
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
              SizedBox(width: 10.w),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(event.title, style: textTheme.headlineLarge)),
                  SizedBox(height: 20.h),
                  CountdownTimerControl(targetDate: event.targetDate),
                  SizedBox(height: 20.h),

                  _buildSectionTitle(context, "Informations complémentaires"),
                  Text(
                    event.description?.isNotEmpty == true ? event.description! : "Aucune description disponible",
                    style: textTheme.bodySmall?.copyWith(
                      color: event.description?.isNotEmpty == true
                          ? ThemeApp.trueWhite
                          : ThemeApp.trueWhite.withValues(alpha: 0.4),
                    ),
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 30.h),

                  _buildDivider(context),
                  Row(
                    children: [
                      svgIcon(path: Assets.calendar1SvgrepoCom, size: 14),
                      SizedBox(width: 10.w),
                      _buildSectionTitle(context, "Jour prévu"),
                    ],
                  ),
                  _buildDate(context, event.targetDate),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      svgIcon(path: Assets.timeSvgrepoCom, size: 14),
                      SizedBox(width: 10.w),
                      _buildSectionTitle(context, "Horaire précis"),
                    ],
                  ),
                  _buildTime(
                    context,
                    event.targetDate.hour.toString().padLeft(2, "0"),
                    event.targetDate.minute.toString().padLeft(2, "0"),
                  ),

                  SizedBox(height: 38.h),
                  _buildLastUpdate(context, event.updatedAt),
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

  Widget _buildDate(BuildContext context, DateTime date) {
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('yMMMMEEEEd', 'fr_FR');
    final formattedDate = dateFormat.format(date);

    return Text(formattedDate.toUpperCase(), style: textTheme.displayLarge);
  }

  Widget _buildLastUpdate(BuildContext context, DateTime? date) {
    final textTheme = Theme.of(context).textTheme;
    final hour = date?.hour.toString().padLeft(2, "0");
    final minute = date?.minute.toString().padLeft(2, "0");
    return date == null
        ? Container()
        : Center(
            child: RichText(
              text: TextSpan(
                text: "Dernière mise à jour le ",
                style: textTheme.labelSmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.6)),
                children: [
                  TextSpan(
                    text: formattedDateUtil(date),
                    style: textTheme.labelSmall!.copyWith(
                      color: ThemeApp.trueWhite.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " à "),
                  TextSpan(
                    text: "$hour:$minute",
                    style: textTheme.labelSmall!.copyWith(
                      color: ThemeApp.trueWhite.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildTime(BuildContext context, String hour, String minute) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Column(
          children: [
            Text(hour, style: textTheme.displayLarge),
            Text("Heures", style: textTheme.labelMedium!.copyWith(color: ThemeApp.trueWhite)),
          ],
        ),
        Column(
          children: [
            Text(":", style: textTheme.displayLarge),
            SizedBox(height: 20.h),
          ],
        ),
        Column(
          children: [
            Text(minute, style: textTheme.displayLarge),
            Text("Minutes", style: textTheme.labelMedium!.copyWith(color: ThemeApp.trueWhite)),
          ],
        ),
        Column(
          children: [
            Text(" UTC", style: textTheme.displayLarge),
            SizedBox(height: 10.h),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 20.h, thickness: 8, color: ThemeApp.tropicalIndigo.withValues(alpha: 0.8));
  }
}
