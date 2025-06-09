import 'package:flutter/material.dart';

/// 自定义 Widget，封装 CustomPaint
class TextHighlightWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double highlightHeight;
  final Color highlightColor;

  const TextHighlightWidget({
    super.key,
    required this.text,
    required this.textStyle,
    this.highlightHeight = 8,
    this.highlightColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _TextHighlightPainter(
            text: text,
            textStyle: textStyle,
            highlightColor: highlightColor,
            highlightHeight: highlightHeight,
            maxWidth: constraints.maxWidth, // 自动换行
          ),
          child: SelectableText(text, style: textStyle),
        );
      },
    );
  }
}

/// 自定义 Painter，计算文字位置并绘制背景
class _TextHighlightPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final Color highlightColor;
  final double highlightHeight;
  final double maxWidth;

  const _TextHighlightPainter({
    required this.text,
    required this.textStyle,
    required this.highlightColor,
    required this.highlightHeight,
    required this.maxWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 100, // 允许换行
    )..layout(maxWidth: maxWidth);

    // 绘制每行文字的背景
    for (final line in textPainter.computeLineMetrics()) {
      final lineRect = Rect.fromLTWH(
        0, // 从左侧开始
        line.baseline - textStyle.fontSize! * 0.3, // 调整基线位置（控制填充起始点）
        line.width, // 行宽度
        highlightHeight, // 填充高度
      );

      final paint = Paint()..color = highlightColor;
      canvas.drawRect(lineRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
