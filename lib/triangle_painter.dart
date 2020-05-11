import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  Paint painter;
  Color c;

  TrianglePainter({@required this.c}) {
    painter = Paint()
      ..color = c
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
