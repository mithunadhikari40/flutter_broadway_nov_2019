import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/src/clock_face.dart';

typedef TimeProducer = DateTime Function();

class Clock extends StatefulWidget {
  final TimeProducer getCurrentTime;
  final Duration updateDuration;
  final ThemeData customTheme;

  const Clock(
      {this.getCurrentTime = getSystemTime,
        this.updateDuration = const Duration(milliseconds: 25), this.customTheme});

  static DateTime getSystemTime() {
    return DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  Timer _timer;
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    _timer = Timer.periodic(widget.updateDuration, setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  buildClockCircle(context);
  }

  Container buildClockCircle(BuildContext context) {
    return   Container(
      width: double.infinity,
      decoration:   BoxDecoration(
        shape: BoxShape.circle,
        color: widget.customTheme.backgroundColor,
        boxShadow: [
          const BoxShadow(
            offset: const Offset(0.0, 5.0),
            blurRadius: 5.0,
          )
        ],
      ),
      child: ClockFace(
          dateTime: dateTime,
       ),
    );
  }
}
