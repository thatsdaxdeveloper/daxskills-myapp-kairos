import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:proto_kairos/models/data/generated/assets.dart";
import "package:proto_kairos/views/themes/theme_app.dart";
import "package:proto_kairos/views/utils/svg_util.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";
import "package:table_calendar/table_calendar.dart";
import "package:wheel_picker/wheel_picker.dart";

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
    return Column(
      children: [
        // Formulaire de texte
        _buildForm(),

        SizedBox(height: 80.h),

        // Formulaire d"ajout d"un evenement
        _buildIndicator(),
        SizedBox(height: 6.h),
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
        TextFormField(
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

  // Widget _buildPickTime() {
  //   final textTheme = Theme.of(context).textTheme;
  //   final primaryColor = Theme.of(context).primaryColor;
  //
  //   // Heures de 0 à 23
  //   final hours = List.generate(24, (index) => index);
  //   // Minutes avec un pas de 5 (00, 05, 10, ..., 55)
  //   final minutes = List.generate(12, (index) => index * 5);
  //
  //   return Column(
  //     children: [
  //       // Affichage de l'heure sélectionnée
  //       Text(
  //         '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
  //         style: textTheme.headlineMedium?.copyWith(
  //           color: ThemeApp.trueWhite,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: 20.h),
  //
  //       // Sélecteur d'heure
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Sélecteur d'heures
  //           SizedBox(
  //             width: 80.w,
  //             child: WheelPicker(
  //               itemSize: 50,
  //               children: hours.map((hour) {
  //                 return Text(
  //                   hour.toString().padLeft(2, '0'),
  //                   style: textTheme.titleLarge?.copyWith(
  //                     color: _selectedHour == hour
  //                         ? primaryColor
  //                         : ThemeApp.trueWhite.withOpacity(0.6),
  //                     fontWeight: _selectedHour == hour
  //                         ? FontWeight.bold
  //                         : FontWeight.normal,
  //                   ),
  //                 );
  //               }).toList(),
  //               onIndexChanged: (index) {
  //                 setState(() {
  //                   _selectedHour = hours[index];
  //                 });
  //               },
  //               looping: true,
  //               perspective: 0.01,
  //               size: 200,
  //               squeeze: 1.2,
  //               diameterRatio: 1.2,
  //               itemExtent: 50,
  //               physics: const FixedExtentScrollPhysics(),
  //             ),
  //           ),
  //
  //           // Deux-points
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 8.w),
  //             child: Text(
  //               ':',
  //               style: textTheme.headlineMedium?.copyWith(
  //                 color: ThemeApp.trueWhite,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //
  //           // Sélecteur de minutes
  //           SizedBox(
  //             width: 80.w,
  //             child: WheelPicker(
  //               // itemSize: 50,
  //               builder: ,
  //               children: minutes.map((minute) {
  //                 return Text(
  //                   minute.toString().padLeft(2, '0'),
  //                   style: textTheme.titleLarge?.copyWith(
  //                     color: _selectedMinute == minute
  //                         ? primaryColor
  //                         : ThemeApp.trueWhite.withOpacity(0.6),
  //                     fontWeight: _selectedMinute == minute
  //                         ? FontWeight.bold
  //                         : FontWeight.normal,
  //                   ),
  //                 );
  //               }).toList(),
  //               onIndexChanged: (index) {
  //                 setState(() {
  //                   _selectedMinute = minutes[index];
  //                 });
  //               },
  //               looping: true,
  //               perspective: 0.01,
  //               size: 200,
  //               squeeze: 1.2,
  //               diameterRatio: 1.2,
  //               itemExtent: 50,
  //               physics: const FixedExtentScrollPhysics(),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
