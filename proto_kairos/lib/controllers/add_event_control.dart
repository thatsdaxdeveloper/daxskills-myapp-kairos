import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:intl/intl.dart";
import "package:proto_kairos/models/data/generated/assets.dart";
import "package:proto_kairos/views/themes/theme_app.dart";
import "package:proto_kairos/views/utils/svg_util.dart";
import "package:table_calendar/table_calendar.dart";
import "package:wheel_picker/wheel_picker.dart";

class AddEventControl extends StatefulWidget {
  const AddEventControl({super.key});

  @override
  State<AddEventControl> createState() => _AddEventControlState();
}

class _AddEventControlState extends State<AddEventControl> {
  late final WheelPickerController _hoursWheel;
  late final WheelPickerController _minutesWheel;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final PageController _pageController = PageController();

  DateTime? selectedDate;
  DateTime? focusedDate;

  @override
  void initState() {
    super.initState();
    focusedDate = DateTime.now();

    _pageController.addListener(() {
      if (mounted) setState(() {});
    });

    // Mettre le focus sur le champ de titre après le premier rendu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _titleFocusNode.requestFocus();
      }
    });

    final now = TimeOfDay.now();
    _hoursWheel = WheelPickerController(itemCount: 24, initialIndex: now.hour % 12,);
    _minutesWheel = WheelPickerController(itemCount: 60, initialIndex: now.minute, mounts: [_hoursWheel]);

    initializeDateFormatting('fr_FR', null);
  }

  @override
  void dispose() {
    _titleFocusNode.dispose(); // N"oubliez pas de libérer la mémoire
    titleController.dispose();
    contentController.dispose();
    _pageController.dispose();
    _hoursWheel.dispose();
    _minutesWheel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Formulaire de texte
        _buildForm(),

        SizedBox(height: 60.h),

        // Formulaire d"ajout d"un evenement
        _buildIndicator(),
        SizedBox(height: 20.h),
        SizedBox(
          height: 360.h,
          child: PageView(controller: _pageController, children: [_buildPickDate(), _buildPickTime()]),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Champ de titre
        TextFormField(
          controller: titleController,
          focusNode: _titleFocusNode,
          style: textTheme.headlineLarge,
          cursorColor: ThemeApp.trueWhite,
          decoration: InputDecoration(
            hintText: "Quel est cet événement ?",
            hintStyle: textTheme.headlineLarge!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.1)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            isDense: true,
          ),
          maxLines: null,
          // Permet plusieurs lignes
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            // Passe au champ suivant (contenu) quand on appuie sur entrée
            FocusScope.of(context).nextFocus();
          },
        ),

        // Champ de contenu
        SizedBox(
          height: 40.h,
          child: TextFormField(
            controller: contentController,
            cursorColor: ThemeApp.trueWhite,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: "Ajoutez des détails utiles (lieu, contacts, notes...)",
              hintStyle: textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.1)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
      ],
    );
  }

  Widget _buildPickDate() {
    final now = DateTime.now();
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: TableCalendar(
        firstDay: now.subtract(const Duration(days: 365 * 5)),
        // 5 ans en arrière
        lastDay: now.add(const Duration(days: 365 * 5)),
        // 5 ans en avant
        focusedDay: focusedDate ?? now,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekHeight: 32.h,
        rowHeight: 40.h,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: textTheme.titleMedium!.copyWith(color: ThemeApp.trueWhite, fontWeight: FontWeight.bold),
          leftChevronIcon: svgIcon(path: Assets.chevronLeftSquareSvgrepoCom),
          rightChevronIcon: svgIcon(path: Assets.chevronRightSquareSvgrepoCom),
        ),

        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            border: Border.all(color: primaryColor.withValues(alpha: 0.5), width: 2.w),
            shape: BoxShape.rectangle,
          ),
          selectedDecoration: BoxDecoration(color: primaryColor, shape: BoxShape.rectangle),
          weekendTextStyle: textTheme.bodyMedium!,
          defaultTextStyle: textTheme.bodyMedium!,
          outsideDaysVisible: true,
          outsideTextStyle: textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.2)),
          selectedTextStyle: textTheme.titleLarge!,
          defaultDecoration: BoxDecoration(color: ThemeApp.trueWhite.withValues(alpha: 0.03)),
          weekendDecoration: BoxDecoration(color: ThemeApp.trueWhite.withValues(alpha: 0.03)),
        ),

        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            // Liste des noms des jours en français (abréviations)
            const days = ["L", "M", "M", "J", "V", "S", "D"];
            return days[date.weekday - 1];
          },
          weekdayStyle: textTheme.bodySmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
          weekendStyle: textTheme.bodySmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
        ),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDate = selectedDay;
            focusedDate = focusedDay;
            // Vous pouvez ajouter ici la logique pour gérer la sélection
          });
        },

        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
      ),
    );
  }

  String _getFormattedTime() {
    final hours = _hoursWheel.selected.toString().padLeft(2, '0');
    final minutes = _minutesWheel.selected.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Map<String, String> _getDateComponents() {
    final date = selectedDate ?? focusedDate ?? DateTime.now();
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();
    return {
      "weekDay": capitalize(DateFormat('EEEE', 'fr_FR').format(date)),
      "day": date.day.toString(),
      "month": capitalize(DateFormat('MMMM', 'fr_FR').format(date)),
      "year": date.year.toString(),
    };
  }

  Widget _buildPickTime() {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final now = TimeOfDay.now();

    final wheelStyle = WheelPickerStyle(
      itemExtent: textTheme.headlineLarge!.fontSize! * textTheme.headlineLarge!.height!,
      // Text height
      squeeze: 1.15,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    Widget itemBuilder(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textTheme.headlineLarge?.copyWith(color: ThemeApp.trueWhite));
    }

    final timeWheels = <Widget>[
      for (final wheelController in [_hoursWheel, _minutesWheel])
        Expanded(
          child: WheelPicker(
            builder: itemBuilder,
            controller: wheelController,
            looping: wheelController == _hoursWheel || wheelController == _minutesWheel,
            style: wheelStyle,
            selectedIndexColor: ThemeApp.tropicalIndigo,
          ),
        ),
    ];
    timeWheels.insert(1, Text(":", style: textTheme.headlineLarge?.copyWith(color: ThemeApp.trueWhite)));

    final dateComponents = _getDateComponents();

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 200.0.h,
            height: 200.0.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _centerBar(context),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                  child: Row(children: [...timeWheels,]),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Momento Kairos", style: textTheme.titleSmall),
          ],
        ),
        SizedBox(height: 10.h),
        _buildDate(
          weekDay: dateComponents["weekDay"]!,
          day: dateComponents["day"]!,
          month: dateComponents["month"]!,
          year: dateComponents["year"]!,
        ),
      ],
    );
  }

  Widget _buildDate({required String weekDay, required String day, required String month,required String year}) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Date
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jour
              Text(weekDay,
                  style: textTheme.bodyMedium!.copyWith(
                      color: ThemeApp.trueWhite.withValues(alpha: 0.4),
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(day, style: textTheme.displayLarge!.copyWith(fontSize: 80, height: 0.9)),

                  SizedBox(width: 10.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(month, style: textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10.h),

                      Text(year, style: textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              )
            ],
          ),

          VerticalDivider(
            color: ThemeApp.trueWhite.withValues(alpha: 0.2),
            thickness: 2.w,
            width: 50.w,
          ),

          // Heure
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Text("UTC", style: textTheme.bodySmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.4), fontWeight: FontWeight.bold),),
              Text("23:59", style: textTheme.displayMedium)
            ],
          )
        ],
      ),
    );
  }

  Widget _centerBar(BuildContext context) {
    return Center(
      child: Container(
        height: 30.0.h,
        decoration: BoxDecoration(
          color: ThemeApp.trueWhite.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8.0.r),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    final textTheme = Theme.of(context).textTheme;
    final isFirstIndex = _pageController.hasClients ? (_pageController.page ?? 0).round() == 0 : 0 == 0;
    return Row(
      children: [
        Expanded(
          // Pour que la colonne prenne tout l'espace disponible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
            children: [
              Text(isFirstIndex ? "Jour de l'événement" : "Moment précis", style: textTheme.titleMedium),
              Text(
                isFirstIndex ? "Quel jour souhaitez-vous compter ?" : "Précisez l'heure du compte à rebours",
                style: textTheme.bodySmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(2, (index) {
            final isActive = _pageController.hasClients ? (_pageController.page ?? 0).round() == index : index == 0;

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: index == 0
                    ? svgIcon(
                        path: Assets.calendar1SvgrepoCom,
                        color: isActive ? ThemeApp.tropicalIndigo : ThemeApp.trueWhite.withValues(alpha: 0.4),
                        size: isActive ? 24 : 18,
                      )
                    : svgIcon(
                        path: Assets.timeSvgrepoCom,
                        color: isActive ? ThemeApp.tropicalIndigo : ThemeApp.trueWhite.withValues(alpha: 0.4),
                        size: isActive ? 24 : 18,
                      ),
              ),
            );
          }),
        ),
        SizedBox(width: 10.w),
      ],
    );
  }
}
