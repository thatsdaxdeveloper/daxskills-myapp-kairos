import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:proto_kairos/controllers/providers/countdown_provider.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';
import 'package:proto_kairos/views/components/show_my_toastification.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';
import 'package:proto_kairos/views/widgets/my_expanded_button.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wheel_picker/wheel_picker.dart';

class EditEventControl extends StatefulWidget {
  final CountdownEntity countdown;

  const EditEventControl({super.key, required this.countdown});

  @override
  State<EditEventControl> createState() => _EditEventControlState();
}

class _EditEventControlState extends State<EditEventControl> {
  late final WheelPickerController _hoursWheel;
  late final WheelPickerController _minutesWheel;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final PageController _pageController = PageController();

  DateTime? selectedDate;
  DateTime? focusedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _titleFocusNode.requestFocus();
      }
    });

    // Initialiser avec les valeurs du compteur existant
    selectedDate = widget.countdown.targetDate;
    focusedDate = widget.countdown.targetDate;
    selectedTime = TimeOfDay.fromDateTime(widget.countdown.targetDate);

    // Initialiser les contrôleurs avec les valeurs existantes
    _hoursWheel = WheelPickerController(itemCount: 24, initialIndex: selectedTime!.hour);

    _minutesWheel = WheelPickerController(itemCount: 60, initialIndex: selectedTime!.minute, mounts: [_hoursWheel]);

    _pageController.addListener(() {
      if (mounted) setState(() {});
    });

    initializeDateFormatting('fr_FR', null);
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    titleController.dispose();
    contentController.dispose();
    _contentFocusNode.dispose();
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
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [_buildPickDate(), _buildPickTime()],
            onPageChanged: (index) {
              setState(() {});
            },
          ),
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
          textCapitalization: TextCapitalization.sentences,
          style: textTheme.headlineLarge,
          cursorColor: ThemeApp.trueWhite,
          decoration: InputDecoration(
            hintText: widget.countdown.title,
            hintStyle: textTheme.headlineLarge!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.1)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            isDense: true,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_contentFocusNode);
          },
        ),

        // Champ de contenu
        TextFormField(
          controller: contentController,
          focusNode: _contentFocusNode,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: ThemeApp.trueWhite,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.countdown.description!.isNotEmpty
                ? widget.countdown.description
                : "Mettre à jour la description",
            hintStyle: textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.1)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
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
        locale: "fr_FR",
        firstDay: now,
        lastDay: now.add(const Duration(days: 365 * 5)),
        focusedDay: focusedDate ?? now,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekHeight: 32.h,
        rowHeight: 40.h,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) {
            final monthName = DateFormat.MMMM('fr_FR').format(date);
            return '${monthName[0].toUpperCase()}${monthName.substring(1)} ${date.year}';
          },
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
          disabledTextStyle: textTheme.bodyMedium!.copyWith(color: ThemeApp.eerieBlack),
          disabledDecoration: BoxDecoration(color: ThemeApp.eerieBlack),
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
          if (!isSameDay(selectedDate, selectedDay)) {
            setState(() {
              selectedDate = selectedDay;
              focusedDate = focusedDay;
            });
          }
        },

        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
      ),
    );
  }

  Widget _buildPickTime() {
    final textTheme = Theme.of(context).textTheme;
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
            onIndexChanged: (index, interactionType) => setState(() {}),
          ),
        ),
    ];
    timeWheels.insert(1, Text(":", style: textTheme.headlineLarge?.copyWith(color: ThemeApp.trueWhite)));

    // Vérifier s'il y a eu des changements
    final bool hasChanges =
        titleController.text.trim().isNotEmpty ||
        contentController.text.trim().isNotEmpty ||
        selectedDate != null && !isSameDay(selectedDate, widget.countdown.targetDate) ||
        _hoursWheel.selected != widget.countdown.targetDate.hour ||
        _minutesWheel.selected != widget.countdown.targetDate.minute;

    return Column(
      children: [
        SizedBox(height: 30.h),
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
                  child: Row(children: [...timeWheels]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 50.h),
        MyExpandedButton(
          text: "Modifier",
          onTap: hasChanges
              ? () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  _updateEvent();
                }
              : null,
          opacity: hasChanges ? 1.0 : 0.2,
        ),
      ],
    );
  }

  void _updateEvent() {
    try {
      FocusScope.of(context).unfocus();

      final date = selectedDate ?? DateTime.now();

      final updatedDate = DateTime(
        date.year,
        date.month,
        date.day,
        _hoursWheel.selected,
        _minutesWheel.selected,
      );

      final updatedCountdown = widget.countdown.copyWith(
        title: titleController.text.trim().isNotEmpty ? titleController.text.trim() : widget.countdown.title,
        description: contentController.text.trim().isNotEmpty
            ? contentController.text.trim()
            : widget.countdown.description,
        targetDate: updatedDate,
        updatedAt: DateTime.now(),
      );

      context.read<CountdownProvider>().updateCountdown(updatedCountdown);
      showMyToastification(context: context, message: "Événement modifié");

      context.pop();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur dans _addEvent: $e");
      }
      if (mounted) {
        showMyToastification(context: context, message: "Erreur: ${e.toString()}", isError: true);
      }
    }
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
              Text(isFirstIndex ? "Nouvelle date" : "Reprogrammer l'heure", style: textTheme.titleMedium),
              Text(
                isFirstIndex ? "Quand souhaitez-vous déplacer l'événement ?" : "Définissez le nouvel horaire",
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
