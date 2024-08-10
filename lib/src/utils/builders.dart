import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_schedule_view/src/event.dart';
import 'package:flutter_schedule_view/src/styles/day_view.dart';
import 'package:flutter_schedule_view/src/styles/hours_column.dart';
import 'package:flutter_schedule_view/src/utils/hour_minute.dart';
import 'package:flutter_schedule_view/src/utils/text_utils.dart';
import 'package:flutter_schedule_view/src/utils/utils.dart';
import 'package:flutter_schedule_view/src/widgets/day_view.dart';
import 'package:flutter_schedule_view/src/widgets/zoomable_header_widget.dart';

/// Contains default builders and formatters.
class DefaultBuilders {
  /// Formats a day in YYYY-MM-DD format, e.g., 2020-01-15.
  static String defaultDateFormatter(int year, int month, int day) => '$year-${Utils.addLeadingZero(month)}-${Utils.addLeadingZero(day)}';

  /// Formats a hour in 24-hour HH:MM format, e.g., 15:00.
  static String defaultTimeFormatter(HourMinute time) => '${Utils.addLeadingZero(time.hour)}:${Utils.addLeadingZero(time.minute)}';

  /// Allows to calculate a top offset according to the specified hour row height.
  static double defaultTopOffsetCalculator(HourMinute time, {HourMinute minimumTime = HourMinute.min, double hourRowHeight = 60, double paddingTop = 0}) {
    HourMinute relative = time.subtract(minimumTime);
    return (relative.hour + (relative.minute / 60)) * hourRowHeight + paddingTop;
  }

  /// Builds an event text widget in order to put it in an event widget.
  static Widget defaultEventTextBuilder(FlutterWeekViewEvent event, BuildContext context, DayView dayView, double height, double width) {
    List<TextSpan> text = [
      TextSpan(
        text: event.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text:
            ' ${dayView.hoursColumnStyle.timeFormatter(HourMinute.fromDateTime(dateTime: event.start))} - ${dayView.hoursColumnStyle.timeFormatter(HourMinute.fromDateTime(dateTime: event.end))}\n\n',
      ),
      TextSpan(
        text: event.description,
      ),
    ];

    bool? exceedHeight;
    while (exceedHeight ?? true) {
      exceedHeight = _exceedHeight(text, event.textStyle?.call(), height, width);
      if (exceedHeight == null || !exceedHeight) {
        if (exceedHeight == null) {
          text.clear();
        }
        break;
      }

      if (!_ellipsize(text)) {
        break;
      }
    }

    return RichText(
      text: TextSpan(
        children: text,
        style: event.textStyle?.call(),
      ),
    );
  }

  /// Builds a date according to a list.
  static DateTime defaultDateCreator(List<DateTime> dates, int index) => dates[index];

  /// Builds the current time indicator builder.
  static Widget defaultCurrentTimeIndicatorBuilder(DayViewStyle dayViewStyle, TopOffsetCalculator topOffsetCalculator, HoursColumnStyle hoursColumnStyle, bool isRtl, ValueNotifier<int> currentTimeNotifier) {
    // List<Widget> children = [
    //   if (dayViewStyle.currentTimeRuleHeight > 0 && dayViewStyle.currentTimeRuleColor != null)
    //     Expanded(
    //       child: Container(
    //         height: dayViewStyle.currentTimeRuleHeight,
    //         color: dayViewStyle.currentTimeRuleColor,
    //       ),
    //     ),
    //   if (dayViewStyle.currentTimeCircleRadius > 0 && dayViewStyle.currentTimeCircleColor != null)
    //     Container(
    //       height: dayViewStyle.currentTimeCircleRadius * 2,
    //       width: dayViewStyle.currentTimeCircleRadius * 2,
    //       decoration: BoxDecoration(
    //         color: dayViewStyle.currentTimeCircleColor,
    //         shape: BoxShape.circle,
    //       ),
    //     ),
    // ];
    //
    // final timeIndicatorHight = math.max(
    //   dayViewStyle.currentTimeRuleHeight,
    //   dayViewStyle.currentTimeCircleRadius * 2,
    // );
    //
    // if (dayViewStyle.currentTimeCirclePosition == CurrentTimeCirclePosition.left) {
    //   children = children.reversed.toList();
    // }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: RepaintBoundary(
         child: CustomPaint(
         painter: _CurrentTimeIndicator(
           dayViewStyle,
           topOffsetCalculator,
           hoursColumnStyle,
           isRtl,
           currentTimeNotifier
         ),
    ))
    );
  }

  /// Builds the time displayed on the side border.
  static Widget defaultHoursColumnTimeBuilder(HoursColumnStyle hoursColumnStyle, HourMinute time) {
    return Text(
      hoursColumnStyle.timeFormatter(time),
      style: hoursColumnStyle.textStyle,
    );
  }

  /// The default day view style builder.
  static DayViewStyle defaultDayViewStyleBuilder(DateTime date) => DayViewStyle.fromDate(date: date);

  /// Returns whether this input exceeds the specified height.
  static bool? _exceedHeight(List<TextSpan> input, TextStyle? textStyle, double height, double width) {
    double fontSize = textStyle?.fontSize ?? 14;
    int maxLines = height ~/ ((textStyle?.height ?? 1.2) * fontSize);
    if (maxLines == 0) {
      return null;
    }

    TextPainter painter = TextPainter(
      text: TextSpan(
        children: input,
        style: textStyle,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: width);
    return painter.didExceedMaxLines;
  }

  /// Ellipsizes the input.
  static bool _ellipsize(List<TextSpan> input, [String ellipse = '…']) {
    if (input.isEmpty) {
      return false;
    }

    TextSpan last = input.last;
    String? text = last.text;
    if (text == null || text.isEmpty || text == ellipse) {
      input.removeLast();

      if (text == ellipse) {
        _ellipsize(input, ellipse);
      }
      return true;
    }

    String truncatedText;
    if (text.endsWith('\n')) {
      truncatedText = text.substring(0, text.length - 1) + ellipse;
    } else {
      truncatedText = Utils.removeLastWord(text);
      truncatedText = truncatedText.substring(0, math.max(0, truncatedText.length - 2)) + ellipse;
    }

    input[input.length - 1] = TextSpan(
      text: truncatedText,
      style: last.style,
    );

    return true;
  }
}

class _CurrentTimeIndicator extends CustomPainter {
  final DayViewStyle dayViewStyle;
  final TopOffsetCalculator topOffsetCalculator;
  final HoursColumnStyle hoursColumnStyle;
  final bool isRtl;
  final ValueNotifier<int> repaintNotifier;
  final Paint _paint;
  _CurrentTimeIndicator(
      this.dayViewStyle,
      this.topOffsetCalculator,
      this.hoursColumnStyle,
      this.isRtl,
      this.repaintNotifier)
       :_paint=Paint()..color=
        dayViewStyle.currentTimeCircleColor??Colors.blue
          ..strokeWidth=dayViewStyle.currentTimeRuleHeight
          ..style=PaintingStyle.fill,
        super(repaint: repaintNotifier);

  @override
  void paint(Canvas canvas, Size size) {
    final startYPosition=topOffsetCalculator(HourMinute.now());
    if(dayViewStyle.showCurrentTimeText){
      final currentTime=hoursColumnStyle.timeFormatter(HourMinute.now());
      TextUtils.drawText(canvas,currentTime,dayViewStyle.currentTimeTextStyle??hoursColumnStyle.textStyle,hoursColumnStyle.width/2, startYPosition);
    }
    if(dayViewStyle.currentTimeCircleRadius>0) {
      final double startXPosition=hoursColumnStyle.width+(dayViewStyle.currentTimeCirclePosition==CurrentTimeCirclePosition.left?dayViewStyle.currentTimeCircleRadius:size.width-dayViewStyle.currentTimeCircleRadius);
      canvas.drawCircle(
          Offset(startXPosition, startYPosition), dayViewStyle.currentTimeCircleRadius,
          _paint);
    }
    if(dayViewStyle.currentTimeRuleHeight>0) {
      canvas.drawLine(
          Offset(hoursColumnStyle.width, startYPosition), Offset(size.width, startYPosition),
          _paint);
    }
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
