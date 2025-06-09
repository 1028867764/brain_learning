import 'package:flutter/material.dart';
import 'package:brain_learning/main.dart';

class ProgressBarPainter extends CustomPainter {
  final double progress;

  ProgressBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint =
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.fill;

    Paint progressPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [kBilibiliPink, kBilibiliPink],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(
            Rect.fromLTWH(0, 0, size.width * progress, size.height),
          );

    // 绘制背景
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // 绘制进度
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // 不需要重绘
  }
}
