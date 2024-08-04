import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:flutter_week_view_example/theme/app_theme.dart';
import 'package:flutter_week_view_example/util/event_utils.dart';
import 'package:flutter_week_view_example/util/utils.dart';
import 'package:intl/intl.dart';

class DynamicDayView extends StatefulWidget {
  @override
  State<DynamicDayView> createState() => _DynamicDayViewState();
}

class _DynamicDayViewState extends State<DynamicDayView> {
  List<FlutterWeekViewEvent> events = [];
  DayViewController? dayViewController;

  void _initEvents() {
    events.addAll([
      FlutterWeekViewEvent(
        padding: EdgeInsets.only(left: 2, right: 2),
        title: '周迭代需求评审',
        description: '张三的预定',
        eventTextBuilder: meetingEventTextBuilder,
        start: HourMinute(hour: 7).atDate(DateTime.now()),
        end: HourMinute(hour: 8).atDate(DateTime.now()),
        decoration: () => meetingEventDecoration(context),
        onTap: (event) => debugPrint('Event 1 has been tapped !'),
      ),
      FlutterWeekViewEvent(
        padding: EdgeInsets.only(left: 2, right: 2),
        title: '富文本技术分享讨论会',
        description: '李四的预定',
        eventTextBuilder: meetingEventTextBuilder,
        start: HourMinute(hour: 8).atDate(DateTime.now()),
        end: HourMinute(hour: 10).atDate(DateTime.now()),
        decoration: () => meetingEventDecoration(context),
        onTap: (event) => debugPrint('Event 2 has been tapped !'),
      ),
      FlutterWeekViewEvent(
        padding: EdgeInsets.only(left: 2, right: 2),
        title: '研发流程管理会',
        description: '王五的预定',
        eventTextBuilder: meetingEventTextBuilder,
        start: HourMinute(hour: 12).atDate(DateTime.now()),
        end: HourMinute(hour: 13).atDate(DateTime.now()),
        decoration: () => meetingEventDecoration(context),
        onTap: (event) => debugPrint('Event 3 has been tapped !'),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    if (events.isEmpty) {
      _initEvents();
    }
    return Scaffold(
      appBar: _getAppBar(),
      body: DayView(
        date: now,
        initialTime: const HourMinute(hour: 6),
        userZoomable: false,
        showTimeRangeText: true,
        events: events,
        style: DayViewStyle(
            backgroundColor: Theme.of(context).twColors.primaryBackgroundColor,
            hourRowHeight: 60,
            headerSize: 0,
            backgroundRulesColor:
                Theme.of(context).twColors.dividerBackgroundColor,
            currentTimeRuleColor: Theme.of(context).twColors.primary,
            currentTimeCircleColor: Theme.of(context).twColors.primary,
            currentTimeCircleRadius: 5,
            currentTimeRuleHeight: 1,
            currentTimeCirclePosition: CurrentTimeCirclePosition.left,
            currentTimeTextStyle: TextStyle(
                color: Theme.of(context).twColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5)),
        hoursColumnStyle: HoursColumnStyle(
          width: 55,
          color: Theme.of(context).twColors.primaryBackgroundColor,
          textAlignment: Alignment.center,
          textStyle: TextStyle(
              color: Theme.of(context).twColors.secondTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5),
          timeRangeTextStyle: TextStyle(
              color: Theme.of(context).twColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5),
          interval: const Duration(hours: 1),
        ),
        dragAndDropOptions: DragAndDropOptions(
          startingGesture: isMobilePlatform()
              ? DragStartingGesture.longPress
              : DragStartingGesture.tap,
          onEventDragged: (FlutterWeekViewEvent event, DateTime newStartTime) {
            DateTime roundedTime = roundTimeToFitGrid(newStartTime,
                gridGranularity: const Duration(minutes: 15));
            event.shiftEventTo(roundedTime);
          },
        ),
        resizeEventOptions: ResizeEventOptions(
          minimumEventDuration: const Duration(minutes: 30),
          onEventResizedUp:
              (FlutterWeekViewEvent event, DateTime newStartTime) {
            debugPrint(
                '+++++++++++++++onEventResizedUp:start:${event.start},newStartTime:${newStartTime}');
            event.start = newStartTime;
          },
          onEventResizeUpUpdate:
              (FlutterWeekViewEvent event, DateTime newStartTime) {
            debugPrint(
                '+++++++++++++++onEventResizeUpUpdate:start:${event.start},newStartTime:${newStartTime}');
            event.start = newStartTime;
          },
          onEventResizedDown:
              (FlutterWeekViewEvent event, DateTime newEndTime) {
            debugPrint(
                '+++++++++++++++onEventResized:end:${event.end},newEndTime:${newEndTime}');
            event.end = newEndTime;
          },
          onEventResizeDownUpdate:
              (FlutterWeekViewEvent event, DateTime newEndTime) {
            debugPrint(
                '+++++++++++++++onEventResizeUpdate:end:${event.end},newEndTime:${newEndTime}');
            event.end = newEndTime;
          },
        ),
        dragPredicate: (event) {
          return event.isNewEvent;
        },
        resizePredicate: (event) {
          return event.isNewEvent;
        },
        onBackgroundTappedDown: (DateTime dateTime) {
          dateTime = roundTimeToFitGrid(dateTime,
              gridGranularity: const Duration(minutes: 15));
          setState(() {
            events.removeWhere((element) => element.isNewEvent);
            events.add(FlutterWeekViewEvent(
                title: NEW_EVENT_TEXT,
                description: NEW_EVENT_TEXT,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: () => newEventDecoration(context),
                eventTextBuilder: createEventTextBuilder,
                start: dateTime,
                end: dateTime.add(const Duration(minutes: 30)),
                isNewEvent: true,
                onTap: (event) {
                  print('+++++++++++++++++++++FlutterWeekViewEvent onTap');
                }));
          });
        },
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      elevation: 0.1,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "9楼光明顶会议室",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).twColors.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${DateFormat('M月d日(E)').format(DateTime.now())}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).twColors.primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
