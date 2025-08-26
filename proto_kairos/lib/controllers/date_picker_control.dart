import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';

class DatePickerControl extends StatefulWidget {
  const DatePickerControl({super.key});

  @override
  State<DatePickerControl> createState() => _DatePickerControlState();
}

class _DatePickerControlState extends State<DatePickerControl> {
  final Map<DateTime, int> _events = {};
  final Map<DateTime, bool> selectedDates = {};

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDates[date] = !(selectedDates[date] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color primaryColor = Theme.of(context).primaryColor;
    return CustomCalendar(selectedDates: selectedDates, onDateSelected: _onDateSelected);
  }
}

class CustomCalendar extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final Map<DateTime, bool> selectedDates;

  const CustomCalendar({super.key, this.onDateSelected, required this.selectedDates});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;
  final List<String> _weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    var first = DateTime(month.year, month.month, 1);
    var last = DateTime(month.year, month.month + 1, 0);
    var days = <DateTime>[];

    // Ajouter les jours vides du mois précédent
    for (var i = 0; i < first.weekday - 1; i++) {
      days.add(DateTime(first.year, first.month, 0 - i));
    }
    days = days.reversed.toList();

    // Ajouter les jours du mois
    for (var i = 1; i <= last.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Ajouter les jours du mois suivant
    while (days.length % 7 != 0) {
      days.add(DateTime(last.year, last.month, last.day + (days.length % 7) + 1));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentMonth);
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // En-tête du mois
        _buildMonthHeader(),
        SizedBox(height: 6.h),

        // Jours de la semaine
        _buildWeekDays(),

        // Jours du mois
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.0),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isSelected = widget.selectedDates[date] ?? false;
            final now = DateTime.now();
            final isToday = date.year == now.year && 
                          date.month == now.month && 
                          date.day == now.day;

            return GestureDetector(
              onTap: () {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final selectedDate = DateTime(date.year, date.month, date.day);

                if (isCurrentMonth && !selectedDate.isBefore(today)) {
                  widget.onDateSelected?.call(date);
                }
              },
              child: Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  border: isToday ? Border.all(color: primaryColor, width: 2.w) : null,
                  color: isSelected
                      ? primaryColor
                      : isCurrentMonth
                      ? ThemeApp.trueWhite.withValues(alpha: 0.06)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(4.0.w),
                    child: Text(
                      date.day.toString(),
                      style: textTheme.bodySmall!.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: isSelected ? 16.sp : 12.sp,
                        color: isSelected
                            ? Colors.white
                            : isCurrentMonth
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                      )
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMonthHeader() {
    final monthYear = DateFormat('MMMM yyyy', 'fr_FR').format(_currentMonth);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
            },
            child: svgIcon(path: Assets.chevronLeftSquareSvgrepoCom),
          ),

          Text(
            "${monthYear[0].toUpperCase()}${monthYear.substring(1)}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          GestureDetector(
            onTap: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
            },
            child: svgIcon(path: Assets.chevronRightSquareSvgrepoCom),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            _weekDays[index],
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ThemeApp.trueWhite.withValues(alpha: 0.8)),
          ),
        );
      },
    );
  }
}
