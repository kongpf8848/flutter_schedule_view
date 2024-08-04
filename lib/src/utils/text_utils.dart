import 'package:flutter/material.dart';

class TextUtils {
  static Size getTextSize(
    String text,
    TextStyle style,
  ) {
    TextSpan span = TextSpan(text: text, style: style);
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    return tp.size;
  }

  static void drawText(
    Canvas canvas,
    String text,
    TextStyle style,
    double x,
    double y,
  ) {
    TextSpan span = TextSpan(text: text, style: style);
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    canvas.save();
    canvas.translate(x - tp.width / 2.0, y-tp.height/2);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }
}
