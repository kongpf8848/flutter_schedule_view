import 'package:flutter/material.dart';
import 'package:flutter_schedule_view/src/utils/hour_minute.dart';

/// Returns a string from a specified date.
typedef DateFormatter = String Function(int year, int month, int day);

/// Returns a string from a specified hour.
typedef TimeFormatter = String Function(HourMinute time);

/// Allows to builder a vertical divider according to the specified date.
typedef VerticalDividerBuilder = VerticalDivider Function(DateTime date);

/// Allows to style a zoomable header widget style.
class ZoomableHeaderWidgetStyle {

  /// Creates a new zoomable header widget style instance.
  const ZoomableHeaderWidgetStyle();
}
