import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_week_view_example/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'pages/dynamic_day_view.dart';

void main(){
  Intl.defaultLocale = "zh_CN";
  runApp(_FlutterWeekViewDemoApp());
}

/// The demo material app.
class _FlutterWeekViewDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }
    return MaterialApp(
      title: 'Flutter Week View Demo',
      debugShowCheckedModeBanner: false,
      locale: Locale("zh","CN"),
      supportedLocales: [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => _FlutterWeekViewDemo(),
        '/dynamic-day-view': (context) => DynamicDayView(),
      },
    );
  }
}

/// The demo app body widget.
class _FlutterWeekViewDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).twColors.primaryBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text("Flutter Week View Demo"),
          actions: [
            IconButton(
                onPressed: () async {
                  Uri uri =
                      Uri.parse('https://github.com/kongpf/FlutterWeekViewEx');
                  if (await launcher.canLaunchUrl(uri)) {
                    await launcher.launchUrl(uri);
                  }
                },
                iconSize: 48,
                icon: Image.asset(
                  'images/git_hub_mobile.png',
                  color: Theme.of(context).twColors.iconTintColor,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  child: const Text('dynamic day view'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/dynamic-day-view'),
                ),
                const Expanded(
                  child: SizedBox.expand(),
                ),
              ],
            ),
          ),
        ));
  }
}
