import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:proto_kairos/controllers/providers/countdown_provider.dart";
import "package:proto_kairos/models/data/generated/assets.dart";
import "package:proto_kairos/views/themes/theme_app.dart";
import "package:proto_kairos/views/utils/svg_util.dart";
import "package:provider/provider.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Consumer<CountdownProvider>(
      builder: (context, countdownProvider, _) {
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 0.h, horizontal: 10.w),
          child: _buildListTileByMonth(),
        );
      },
    );
  }

  Widget _buildListTileByMonth() {
    return Consumer<CountdownProvider>(
      builder: (context, countdownProvider, _) {
        if (countdownProvider.countdowns.isEmpty) {
          return Center(child: Text("Aucun événement programmé", style: Theme.of(context).textTheme.titleMedium));
        }

        // Grouper les événements par mois/année
        final Map<String, List<dynamic>> eventsByMonth = {};

        for (var event in countdownProvider.countdowns) {
          final date = event.targetDate;
          final key = "${date.year}-${date.month.toString().padLeft(2, "0")}";
          if (!eventsByMonth.containsKey(key)) {
            eventsByMonth[key] = [];
          }
          eventsByMonth[key]!.add(event);
        }

        // Trier les clés (mois/année) par ordre chronologique
        final sortedKeys = eventsByMonth.keys.toList()..sort((a, b) => a.compareTo(b));

        return ListView.builder(
          itemCount: sortedKeys.length,
          itemBuilder: (context, monthIndex) {
            final key = sortedKeys[monthIndex];
            final events = eventsByMonth[key]!;
            final firstEvent = events.first;
            final date = firstEvent.targetDate;
            final monthName = _getMonthName(date.month);

            final filteredAndSortedEvents = events.where((event) => event.targetDate.month == date.month).toList()
              ..sort((a, b) => a.targetDate.compareTo(b.targetDate));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du mois/année
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      monthName,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 48.sp,
                        color: ThemeApp.trueWhite.withValues(alpha: 0.1),
                      ),
                    ),
                    Text(
                      date.year.toString(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.1)),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Liste des événements du mois
                ...filteredAndSortedEvents.map(
                  (event) => _buildCountdownTile(
                    title: event.title,
                    day: event.targetDate.day.toString().padLeft(2, "0"),
                    hour: event.targetDate.hour.toString().padLeft(2, "0"),
                    minute: event.targetDate.minute.toString().padLeft(2, "0"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "Mai",
      "Juin",
      "Juillet",
      "Août",
      "Septembre",
      "Octobre",
      "Novembre",
      "Décembre",
    ];
    return monthNames[month - 1];
  }

  Widget _buildCountdownTile({
    required String title,
    required String day,
    required String hour,
    required String minute,
  }) {
    return Consumer<CountdownProvider>(
      builder: (context, countdownProvider, _) {
        final textTheme = Theme.of(context).textTheme;

        return GestureDetector(
          child: Container(
            width: 1.sw,
            margin: EdgeInsets.only(bottom: 20.h),
            child: Row(
              children: [
                // Jour
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    day,
                    style: textTheme.displayLarge!.copyWith(fontSize: 100, height: 0.8, letterSpacing: -2),
                  ),
                ),

                IntrinsicHeight(
                  child: Row(
                    children: [
                      // Diviser
                      VerticalDivider(
                        width: 30.w,
                        color: ThemeApp.trueWhite,
                        thickness: 1.8.w,
                        indent: 0,
                        endIndent: 0,
                      ),

                      // Informations
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.w,
                            height: 32.h,
                            child: Text(
                              title,
                              style: textTheme.titleSmall,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ),
                          Text("$hour:$minute UTC", style: textTheme.titleLarge),
                          SizedBox(height: 4.h),
                          Container(width: 180.w, height: 4.h, color: ThemeApp.tropicalIndigo),
                        ],
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Bouton
                svgIcon(path: Assets.chevronRightSvgrepoCom, color: ThemeApp.tropicalIndigo),
              ],
            ),
          ),
        );
      },
    );
  }
}
