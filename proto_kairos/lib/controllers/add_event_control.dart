import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:proto_kairos/models/data/generated/assets.dart";
import "package:proto_kairos/views/themes/theme_app.dart";
import "package:proto_kairos/views/utils/svg_util.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:table_calendar/table_calendar.dart";

class AddEventControl extends StatefulWidget {
  const AddEventControl({super.key});

  @override
  State<AddEventControl> createState() => _AddEventControlState();
}

class _AddEventControlState extends State<AddEventControl> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final PageController _pageController = PageController();

  DateTime? selectedDate;
  DateTime? focusedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleFocusNode.dispose(); // N"oubliez pas de libérer la mémoire
    titleController.dispose();
    contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      height: 1.sh,
      child: Column(
        children: [
          // Formulaire de texte
          _buildForm(),

          SizedBox(height: 30.h),

          // Formulaire d"ajout d"un evenement
          _buildIndicator(),
          SizedBox(height: 6.h),
          Expanded(
              child: PageView(
                controller: _pageController,
                  children: [
                    _buildPickDate(),
                    _buildPickTime()
                  ],
              )
          ),

        ],
      ),
    );
  }

  Widget _buildForm() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          ),
          maxLines: 1,
        ),

        // Champ de contenu
        Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: ThemeApp.trueWhite.withValues(alpha: 0.008),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: TextFormField(
            controller: contentController,
            cursorColor: ThemeApp.trueWhite,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: "Ajoutez des détails utiles (lieu, contacts, notes...)",
              hintStyle: textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.1)),
              border: InputBorder.none,
            ),
            maxLines: null,
            expands: true,
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

  Widget _buildPickTime() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
      ],
    );
  }

  Widget _buildIndicator() {
    final textTheme = Theme.of(context).textTheme;
    final isFirstIndex = _pageController.hasClients
        ? (_pageController.page ?? 0).round() == 0
        : 0 == 0;
    return Row(
      children: [
        Expanded(  // Pour que la colonne prenne tout l'espace disponible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Alignement à gauche
            children: [
              Text(isFirstIndex ? "Jour de l'événement" : "Moment précis", style: textTheme.titleMedium),
              Text(isFirstIndex ? "Quel jour souhaitez-vous compter ?" : "Précisez l'heure du compte à rebours", style: textTheme.bodySmall!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.8))),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(2, (index) {
            final isActive = _pageController.hasClients
                ? (_pageController.page ?? 0).round() == index
                : index == 0;

            return GestureDetector(
              onTap: () => _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: index == 0
                    ? svgIcon(
                  path: Assets.calendar1SvgrepoCom,
                  color: isActive
                      ? ThemeApp.tropicalIndigo
                      : ThemeApp.trueWhite.withValues(alpha: 0.4),
                  size: isActive ? 24 : 18,
                )
                    : svgIcon(
                  path: Assets.timeSvgrepoCom,
                  color: isActive
                      ? ThemeApp.tropicalIndigo
                      : ThemeApp.trueWhite.withValues(alpha: 0.4),
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
