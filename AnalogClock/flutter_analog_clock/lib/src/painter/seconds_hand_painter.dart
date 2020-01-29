import 'dart:math';

import 'package:flutter/material.dart';

class SecondHandPainter extends CustomPainter {
  final Paint secondHandPaint;
  final Paint secondHandPointsPaint;

  final int seconds;
  final int milliseconds;

  SecondHandPainter({this.seconds, this.milliseconds})
      : secondHandPaint = Paint(),
        secondHandPointsPaint = Paint() {
    secondHandPaint.color = Colors.red;
    secondHandPaint.style = PaintingStyle.stroke;
    secondHandPaint.strokeWidth = 2.0;

    secondHandPointsPaint.color = Colors.red;
    secondHandPointsPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);
    var rotation =
        2 * pi * (((this.seconds * 1000 + this.milliseconds) / 1000)) / 60;
    var degree = rotation * 180 / pi;

    canvas.rotate(2 * pi * ((this.seconds + (this.milliseconds / 1000)) / 60));

//    canvas.rotate(2*pi*(seconds )/60);

    Path path1 = Path();
    Path path2 = Path();
    path1.moveTo(0.0, -radius);
    path1.lineTo(0.0, radius / 6);

    path2.addOval(
        Rect.fromCircle(radius: 5.0, center: Offset(0.0, -radius * .95)));
    path2.addOval(Rect.fromCircle(radius: 5.0, center: Offset(0.0, 0.0)));

    canvas.drawPath(path1, secondHandPaint);
    canvas.drawPath(path2, secondHandPointsPaint);

//    canvas.drawShadow(path2, Colors.black, 4.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SecondHandPainter oldDelegate) {
    return this.seconds != oldDelegate.seconds;
  }
}
