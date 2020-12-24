import 'dart:math';

import 'package:flutter/material.dart';

class ThemePainer extends CustomPainter {
  final Color primary;
  final Color background;
  final Color accent;
  final painter = Paint();
  ThemePainer(this.primary, this.background, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = primary;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      pi,
      pi,
      true,
      painter,
    );
    painter.color = background;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      pi / 2,
      pi / 2,
      true,
      painter,
    );

    painter.color = accent;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      pi / 2,
      -pi / 2,
      true,
      painter,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
