import 'package:flutter/material.dart';
import 'package:flutter_schedule_view/flutter_schedule_view.dart';
import 'package:flutter_schedule_view_example/theme/app_theme.dart';
import 'package:flutter_schedule_view_example/util/event_utils.dart';
import 'package:flutter_schedule_view_example/util/utils.dart';
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
    if (events.isEmpty) {
      _initEvents();
    }
    return Scaffold(appBar: _getAppBar(), body: _getScheduleView());
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
            "桃花岛大会议室",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).twColors.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${DateFormat('yyyy年M月d日(E)').format(DateTime.now())}",
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

  Widget _getScheduleView() {
    return DayView(
      //显示日期
      date: DateTime.now(),
      initialTime: const HourMinute(hour: 6),
      userZoomable: false,
      showTimeRangeText: true,
      //事件列表
      events: events,
      //风格
      style: DayViewStyle(
        //背景颜色
        backgroundColor: Theme.of(context).twColors.primaryBackgroundColor,
        //每个小时行高度
        hourRowHeight: 60,
        headerSize: 0,
        //分割线颜色
        backgroundRulesColor: Theme.of(context).twColors.dividerBackgroundColor,
        currentTimeRuleColor: Theme.of(context).twColors.primary,
        currentTimeCircleColor: Theme.of(context).twColors.primary,
        currentTimeCircleRadius: 5,
        currentTimeRuleHeight: 1,
        currentTimeCirclePosition: CurrentTimeCirclePosition.left,
        currentTimeTextStyle: TextStyle(
          color: Theme.of(context).twColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
      //左侧时间文本风格
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
          height: 1.5,
        ),
        interval: const Duration(hours: 1),
      ),
      //拖放选项
      dragAndDropOptions: DragAndDropOptions(
        startingGesture: isMobilePlatform()
            ? DragStartingGesture.longPress
            : DragStartingGesture.tap,
        onEventDragged: (FlutterWeekViewEvent event, DateTime newStartTime) {
          //处理拖拽逻辑
          DateTime roundedTime = roundTimeToFitGrid(newStartTime,
              gridGranularity: const Duration(minutes: 15));
          event.shiftEventTo(roundedTime);
        },
      ),
      //调整大小选项
      resizeEventOptions: ResizeEventOptions(
        minimumEventDuration: const Duration(minutes: 30),
        //处理上拉逻辑
        onEventResizedUp: (FlutterWeekViewEvent event, DateTime newStartTime) {
          event.start = newStartTime;
        },
        onEventResizeUpUpdate:
            (FlutterWeekViewEvent event, DateTime newStartTime) {
          event.start = newStartTime;
        },
        //处理下拉逻辑
        onEventResizedDown: (FlutterWeekViewEvent event, DateTime newEndTime) {
          event.end = newEndTime;
        },
        onEventResizeDownUpdate:
            (FlutterWeekViewEvent event, DateTime newEndTime) {
          event.end = newEndTime;
        },
      ),
      //是否可以拖放
      dragPredicate: (event) {
        return event.isNewEvent;
      },
      //是否可以调整大小
      resizePredicate: (event) {
        return event.isNewEvent;
      },
      //背景点击事件
      onBackgroundTappedDown: (DateTime dateTime) {
        dateTime = roundTimeToFitGrid(dateTime,
            gridGranularity: const Duration(minutes: 15));
        setState(() {
          events.removeWhere((element) => element.isNewEvent);
          events.add(
            FlutterWeekViewEvent(
              title: NEW_EVENT_TEXT,
              description: NEW_EVENT_TEXT,
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: () => newEventDecoration(context),
              eventTextBuilder: createEventTextBuilder,
              start: dateTime,
              end: dateTime.add(const Duration(minutes: 30)),
              isNewEvent: true,
              onTap: (event) {
                print('+++++++++++++++++++++onTap');
              },
            ),
          );
        });
      },
    );
  }
}
