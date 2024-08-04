# Flutter Schedule View

一个高度可定制的日视图控件，可显示事件列表，支持拖拽、缩放等。

## 截图

|![https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/drag_and_resize.gif](https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/drag_and_resize.gif)|!

| Light mode | Dark mode |
| :-----: | :-----: |
|![https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/schedule_view_light.jpg](https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/schedule_view_light.jpg)|![https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/schedule_view_dark.jpg](https://github.com/kongpf8848/flutter_schedule_view/blob/master/screenshots/schedule_view_dark.jpg)|

## 功能特点
- 显示可自定义的时间表视图，用于管理任务和约会。
- 允许用户在计划中拖放任务。
- 允许用户调整条目大小以调整其持续时间
- 支持亮色模式和暗色模式进行切换

## 导入

## 使用
```dart
  DayView(
      //当前显示日期
      date: DateTime.now(),
      //开始时间
      initialTime: const HourMinute(hour: 6),
      //是否缩放
      userZoomable: false,
      //显示开始时间/结束时间
      showTimeRangeText: true,
      //事件列表
      events: events,
      //风格
      style: DayViewStyle(
          backgroundColor: Theme
              .of(context)
              .twColors
              .primaryBackgroundColor,
          hourRowHeight: 60,
          headerSize: 0,
          backgroundRulesColor:
          Theme
              .of(context)
              .twColors
              .dividerBackgroundColor,
          currentTimeRuleColor: Theme
              .of(context)
              .twColors
              .primary,
          currentTimeCircleColor: Theme
              .of(context)
              .twColors
              .primary,
          currentTimeCircleRadius: 5,
          currentTimeRuleHeight: 1,
          currentTimeCirclePosition: CurrentTimeCirclePosition.left,
          currentTimeTextStyle: TextStyle(
              color: Theme
                  .of(context)
                  .twColors
                  .primary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5)),
      //小时风格
      hoursColumnStyle: HoursColumnStyle(
        width: 55,
        color: Theme
            .of(context)
            .twColors
            .primaryBackgroundColor,
        textAlignment: Alignment.center,
        textStyle: TextStyle(
            color: Theme
                .of(context)
                .twColors
                .secondTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5),
        timeRangeTextStyle: TextStyle(
            color: Theme
                .of(context)
                .twColors
                .primary,
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
          debugPrint(
              '+++++++++++++++onEventResizedUp:start:${event
                  .start},newStartTime:${newStartTime}');
          event.start = newStartTime;
        },
        onEventResizeUpUpdate:
            (FlutterWeekViewEvent event, DateTime newStartTime) {
          debugPrint(
              '+++++++++++++++onEventResizeUpUpdate:start:${event
                  .start},newStartTime:${newStartTime}');
          event.start = newStartTime;
        },
        onEventResizedDown:
            (FlutterWeekViewEvent event, DateTime newEndTime) {
          debugPrint(
              '+++++++++++++++onEventResized:end:${event
                  .end},newEndTime:${newEndTime}');
          event.end = newEndTime;
        },
        onEventResizeDownUpdate:
            (FlutterWeekViewEvent event, DateTime newEndTime) {
          debugPrint(
              '+++++++++++++++onEventResizeUpdate:end:${event
                  .end},newEndTime:${newEndTime}');
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


