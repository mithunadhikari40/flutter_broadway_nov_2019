import 'dart:math';

import 'package:flutter/material.dart';

class HourHandPainter extends CustomPainter {
  final Paint _hourHandPaint;
  int hours;
  int minutes;

  HourHandPainter({this.hours, this.minutes })
      : _hourHandPaint = new Paint() {
    _hourHandPaint.color = Colors.black87;
    _hourHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    // To draw hour hand
    canvas.save();

    canvas.translate(radius, radius);

    //checks if hour is greater than 12 before calculating rotation

    canvas.rotate(hours >= 12
        ? 2 * pi * ((hours - 12) / 12 + (minutes / 720))
        : 2 * pi * ((hours / 12) + (minutes / 720)));

    Path path = new Path();

    //hour hand stem
    path.moveTo(-1.5, -radius + radius / 4);
    path.lineTo(-5.0, -radius + radius / 2);
    path.lineTo(-2.0, 0.0);
    path.lineTo(2.0, 0.0);
    path.lineTo(5.0, (-radius + radius / 2));
    path.lineTo(1.5, -radius + radius / 4);

    path.close();

    canvas.drawPath(path, _hourHandPaint);
    canvas.drawShadow(path, Colors.black, 2.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandPainter oldDelegate) =>
      this.hours != oldDelegate.hours && this.minutes != oldDelegate.minutes;
}
