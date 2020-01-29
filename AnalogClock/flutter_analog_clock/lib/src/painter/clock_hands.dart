import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/src/painter/hours_hand_painter.dart';
import 'package:flutter_analog_clock/src/painter/minutes_hand_painter.dart';
import 'package:flutter_analog_clock/src/painter/seconds_hand_painter.dart';

class ClockHands extends StatelessWidget {
  final DateTime dateTime;

  ClockHands({this.dateTime});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child:  Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomPaint(
              painter: HourHandPainter(
                hours: dateTime.hour,
                minutes: dateTime.minute,
              ),
            ),
            CustomPaint(
              painter: MinuteHandPainter(
                  minutes: dateTime.minute, seconds: dateTime.second),
            ),
            CustomPaint(
              painter: SecondHandPainter(
                  seconds: dateTime.second, milliseconds: dateTime.millisecond),
            ),
          ],
        ),
      ),
    );
  }
}
