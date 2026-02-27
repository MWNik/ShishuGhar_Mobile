
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StrockColorCirclePainter extends CustomPainter {
  double? weight_for_age;
  double? weight_for_height;
  double? height_for_age;
  double? mdical_condition;

  StrockColorCirclePainter(
      this.weight_for_age,
      this.weight_for_height,
      this.mdical_condition,
      this.height_for_age,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke // Stroke only (no fill)
      ..strokeWidth = 2.0; // Set the stroke width

    // Define the center and radius of the circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Define angles for each segment (90 degrees each) with spacing
    final totalSegments = 3;
    final totalAngle = 2 * pi; // Full circle
    final gapAngle = 0.1; // Gap between segments (in radians)
    final availableAngle = totalAngle - (gapAngle * totalSegments);
    final segmentAngle = availableAngle / totalSegments; // Each segment angle

    // Start angle
    double startAngle = -pi / 2; // Start from top (-90 degrees)

    // First color stroke segment (Red)  weight_for_age  SUW
    paint.color = weight_for_age==3.0?Color(0xff8BF649):weight_for_age! ==2.0?Color(0xffF4B81D):weight_for_age! ==1.0?Color(0xffF35858):Color(0xffffffff);
    // paint.color = Color(0xffF35858);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),  startAngle,
        segmentAngle, false, paint);

    startAngle += segmentAngle + gapAngle;
    // Second color stroke segment (Green)  weight_for_height Sam
    paint.color = weight_for_height==3.0?Color(0xff8BF649):weight_for_height ==2.0?Color(0xffF4B81D):weight_for_height ==1.0?Color(0xffF35858):Color(0xffffffff);
    // paint.color = Color(0xffF35858);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),  startAngle,
        segmentAngle, false, paint);

    startAngle += segmentAngle + gapAngle;

    // Third color stroke segment (Blue)
    paint.color = height_for_age==3.0?Color(0xff8BF649):height_for_age ! ==2.0?Color(0xffF4B81D):height_for_age ==1.0?Color(0xffF35858):Color(0xffffffff);
    // paint.color = Color(0xffF4B81D);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),  startAngle,
        segmentAngle, false, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Change to true if you want to repaint on state change
  }

  Color iteColor(double? colorD) {
    Color itemC = Color(0xffffffff);
    if (colorD == 0.0) {
      itemC = Color(0xffAAAAAA); // Gray
    } else if (colorD == 1.0) {
      itemC = Color(0xffF35858); // Red
    } else if (colorD == 2.0) {
      itemC = Color(0xffF4B81D); // Yellow
    } else if (colorD == 3.0) {
      itemC = Color(0xff8BF649); // Green
    } else if (colorD == 4.0) {
      itemC = Color(0xff3498DB); // Blue
    }
    return itemC;
  }
}

