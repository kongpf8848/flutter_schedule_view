# Flutter Schedule View

一个高度可定制的日视图控件，可显示事件列表，支持拖拽、缩放等。

本项目的原始代码来自[FlutterWeekView](https://github.com/Skyost/FlutterWeekView)

## 截图
<div>
  <img src="https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/drag_and_resize.gif"  width="30%" height ="580">
  <img src="https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/schedule_view_light.jpg"  width="30%" height ="580">
  <img src="https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/schedule_view_dark.jpg"  width="30%" height ="580">
</div>

## 功能特点
- 显示可自定义的时间表视图，用于管理任务和约会。
- 允许用户在计划中拖放任务。
- 允许用户调整条目大小以调整其持续时间
- 支持亮色模式和暗色模式进行切换

## 导入

## 使用
```dart
  DayView(
      date: DateTime.now(),
      initialTime: const HourMinute(hour: 6),
      userZoomable: false,
      showTimeRangeText: true,
      events: events,
      style: DayViewStyle(
        ...
      ),
      hoursColumnStyle: HoursColumnStyle(
        width: 55,
        color: Colors.white,
        textAlignment: Alignment.center,
        textStyle: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5),
        timeRangeTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5),
        interval: const Duration(hours: 1),
      ),
      //拖放选项
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
      //改变大小选项
      resizeEventOptions: ResizeEventOptions(
        minimumEventDuration: const Duration(minutes: 30),
        onEventResizedUp:
            (FlutterWeekViewEvent event, DateTime newStartTime) {
          event.start = newStartTime;
        },
        onEventResizeUpUpdate:
            (FlutterWeekViewEvent event, DateTime newStartTime) {
          event.start = newStartTime;
        },
        onEventResizedDown:
            (FlutterWeekViewEvent event, DateTime newEndTime) {
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
      //是否可以拖拽
      resizePredicate: (event) {
        return event.isNewEvent;
      },
      //点击事件
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
    );
```

## 属性说明
| 字段  | 类型         | 备注      |
|:----------|:-----------|:--------|
| `date`    | DateTime   | 显示的日期   |
| `initialTime`    | HourMinute | 开始时间    |
| `userZoomable`    | bool       | 是否缩放    |
| `events`    | List<FlutterWeekViewEvent>       | 事件列表    |
| `style`    | DayViewStyle       | 控件整体风格  |
| `hoursColumnStyle`    | HoursColumnStyle       | 左边的小时风格 |
| `dragAndDropOptions`    | DragAndDropOptions       | 拖放选项    |
| `resizeEventOptions`    | ResizeEventOptions       | 拖拽选项    |
| `dragPredicate`    | Function       | 是否可以拖放  |
| `resizePredicate`    | Function       | 是否可以拖拽  |
| `onBackgroundTappedDown`    | Function       | 背景点击事件  |

## 感谢
原始代码在这里[https://github.com/Skyost/FlutterWeekView](https://github.com/Skyost/FlutterWeekView)

