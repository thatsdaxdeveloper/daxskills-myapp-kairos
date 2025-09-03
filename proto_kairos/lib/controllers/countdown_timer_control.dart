import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proto_kairos/views/themes/theme_app.dart';

class CountdownTimerControl extends StatefulWidget {
  final DateTime targetDate;

  const CountdownTimerControl({super.key, required this.targetDate});

  @override
  State<CountdownTimerControl> createState() => _CountdownTimerControlState();
}

class _CountdownTimerControlState extends State<CountdownTimerControl> {
  late Duration _timeLeft;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.targetDate.difference(DateTime.now());
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(widget.targetDate)) {
        _timer.cancel();
        setState(() {
          _timeLeft = Duration.zero;
        });
      } else {
        setState(() {
          _timeLeft = widget.targetDate.difference(now);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCountdownFinished = now.isAfter(widget.targetDate);

    if (isCountdownFinished) {
      return Container(
        height: 60.h,
        width: 1.sw,
        padding: EdgeInsets.all(10.w),
        color: ThemeApp.trueWhite,
        child: Center(
          child: Text(
            "L'événement est terminé !",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: ThemeApp.eerieBlack, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Container(
      height: 60.h,
      width: 1.sw,
      padding: EdgeInsets.all(10.w),
      color: ThemeApp.trueWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCountdownContent(context, days, "JOURS"),
          _buildCountdownContent(context, hours, "HRS"),
          _buildCountdownContent(context, minutes, "MIN"),
          _buildCountdownContent(context, seconds, "SEC"),
        ],
      ),
    );
  }

  Widget _buildCountdownContent(BuildContext context, int value, String title) {
    return Container(
      height: 1.sh,
      width: 1.sw / 5,
      color: ThemeApp.eerieBlack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            value.toString().padLeft(2, '0'),
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: ThemeApp.trueWhite, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Container(
            height: 70.h,
            width: 20.w,
            color: ThemeApp.tropicalIndigo.withValues(alpha: 0.8),
            child: Center(
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: ThemeApp.trueWhite, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
