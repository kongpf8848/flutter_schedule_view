import 'package:flutter/material.dart';
import 'package:flutter_schedule_view/flutter_schedule_view.dart';
import 'package:flutter_schedule_view_example/theme/app_theme.dart';
import 'package:flutter_schedule_view_example/util/utils.dart';

import '../theme/tw_colors.dart';

const NEW_EVENT_TEXT = "flutter_week_event";

extension FlutterEventExtension on FlutterWeekViewEvent {
  bool get isNewEvent =>
      title == NEW_EVENT_TEXT && description == NEW_EVENT_TEXT;
}

BoxDecoration meetingEventDecoration(BuildContext context) {
  return BoxDecoration(
      color: isLight(context)
          ? Theme.of(context).twColors.primary!.withOpacity(0.25)
          : TWColors.blue.shade600.withOpacity(0.25),
      border: Border.all(
          color: Theme.of(context).twColors.primaryBackgroundColor!,
          width: 0.5));
}

BoxDecoration newEventDecoration(BuildContext context) {
  return BoxDecoration(
    color: isLight(context)
        ? Theme.of(context).twColors.primary!.withOpacity(0.25)
        : TWColors.blue.shade600.withOpacity(0.25),
    border: Border.all(
      color: Theme.of(context).twColors.primary!,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(4),
  );
}

Widget meetingEventTextBuilder(FlutterWeekViewEvent event, BuildContext context,
    DayView dayView, double height, double width) {
  print(
      '++++++++++++++++++++++++++DayView,meetingEventTextBuilder,height:${height}, width: ${width}');
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              event.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).twColors.primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            event.description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).twColors.primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ));
}

Widget createEventTextBuilder(FlutterWeekViewEvent event, BuildContext context,
    DayView dayView, double height, double width) {
  print(
      '++++++++++++++++++++++++++DayView,createEventTextBuilder,height:${height}, width: ${width}');
  var row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(
      "预定会议室",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Theme.of(context).twColors.primary!,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        //height: 1.5,
      ),
    ),
  ]);

  return Container(
      width: width,
      height: height,
//margin: event.margin,
//padding: event.padding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          row,
          OverflowBox(
            alignment: FractionalOffset(0.5, -6 / (height - 10)),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).twColors.primary!, width: 1)),
            ),
          ),
          OverflowBox(
            alignment: FractionalOffset(0.5, (height - 5) / (height - 10)),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).twColors.primary!, width: 1)),
            ),
          ),
        ],
      ));
}

DateTime adjustDateTime(DateTime dateTime) {
  var newDateTime = roundTimeToFitGrid(dateTime,
      gridGranularity: const Duration(minutes: 15));
  if (dateTime.isAfter(DateTime.now()) &&
      !newDateTime.isAfter(DateTime.now())) {
    newDateTime = newDateTime.add(const Duration(minutes: 15));
  }
  return newDateTime;
}

List<DateTime> pickNewTime(DateTime dateTime) {
  List<DateTime> list = [];

  bool canUse(DateTime newDateTime, DateTime preDateTime) {
    if (preDateTime.isAfter(DateTime.now())) {
      return DateUtils.isSameDay(preDateTime, newDateTime) &&
          !preDateTime.isBefore(DateUtils.dateOnly(newDateTime));
    }
    return false;
  }

  var newDateTime = adjustDateTime(dateTime);
  debugPrint(
      '++++++++++++++++++newEvent 11,onTap:pickNewTime,newDateTime:${newDateTime}');
  list.add(newDateTime);

  var d1 = newDateTime.subtract(const Duration(minutes: 15));
  if (canUse(newDateTime, d1)) {
    list.add(d1);
  }
  if (newDateTime.isAfter(dateTime)) {
    var d2 = newDateTime.subtract(const Duration(minutes: 30));
    if (canUse(newDateTime, d2)) {
      list.add(d2);
    }
  }
  print('+++++++++++++++++++++pickNewTime,list:$list');
  return list;
}
