# Flutter Schedule View

一个功能丰富的Flutter日程视图控件，支持高度定制的事件列表显示、拖拽、调整大小等功能。

[![pub package](https://img.shields.io/pub/v/flutter_schedule_view?label=flutter_schedule_view&color=green)](https://pub.dev/packages/flutter_schedule_view)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/kongpf8848/flutter_schedule_view/blob/master/LICENSE)

## 截图

<table> 
  <tr> 
    <td><img src="https://github.com/kongpf8848/flutter_schedule_view/raw/master/screenshots/drag_and_resize.gif" alt="Drag and Resize" width="250" height="550"></td> 
    <td><img src="https://github.com/kongpf8848/flutter_schedule_view/raw/master/screenshots/schedule_view_light.jpg" alt="Light Mode" width="250" height="550"></td> 
    <td><img src="https://github.com/kongpf8848/flutter_schedule_view/raw/master/screenshots/schedule_view_dark.jpg" alt="Dark Mode" width="250" height="550"></td> 
  </tr> 
</table>


## 功能特点
- 高度可定制：轻松定制时间表视图以符合你的应用风格。
- 拖拽支持：允许用户在计划中拖放事件。
- 调整大小：支持上下拖拉视图调整事件的持续时间。
- 模式切换：无缝支持亮色和暗色模式切换。

## 安装
将以下依赖添加到项目的```pubspec.yaml```文件中：
```dart
dependencies:
  flutter_schedule_view: ^0.2.0
```

## 使用
```dart
import 'package:flutter_schedule_view/flutter_schedule_view.dart';

List<FlutterWeekViewEvent> events = [];

//定义事件列表
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

//定义日视图控件  
DayView(
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
    backgroundColor: Colors.white,
    //每个小时高度
    hourRowHeight: 60,
    //分割线颜色
    backgroundRulesColor: Color(0xFFE5E5E5),
    currentTimeRuleColor: Colors.blue,
    currentTimeCircleColor: Colors.blue,
    currentTimeCircleRadius: 5,
    currentTimeRuleHeight: 1,
    currentTimeCirclePosition: CurrentTimeCirclePosition.left,
    currentTimeTextStyle: TextStyle(
      color: Colors.blue,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
  ),
  //左侧时间文本风格
  hoursColumnStyle: HoursColumnStyle(
    width: 55,
    color: Colors.white,
    textAlignment: Alignment.center,
    textStyle: TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5),
    timeRangeTextStyle: TextStyle(
      color: Colors.blue,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    interval: const Duration(hours: 1),
  ),
  //拖拽选项
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
```
## 许可证
本项目遵循MIT许可证。
