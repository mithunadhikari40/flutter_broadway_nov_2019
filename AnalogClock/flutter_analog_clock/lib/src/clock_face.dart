import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/src/painter/clock_dial_painter.dart';
import 'package:flutter_analog_clock/src/painter/clock_hands.dart';

class ClockFace extends StatelessWidget {
  final DateTime dateTime;

  ClockFace({this.dateTime });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          shape:   BoxShape.circle,
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            //dial and numbers
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: CustomPaint(
                  painter: ClockDialPainter(),
                ),
              ),
            ),

            //centerpoint
             Center(
              child:   Container(
                width: 15.0,
                height: 15.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),

            ClockHands(dateTime: dateTime),
          ],
        ),
      ),
    );
  }
}
