import 'package:flutter/material.dart';
import 'tw_colors.dart';

extension TailwindTheme on ThemeData {
  TWColors get twColors => extension<TWColors>()!;
}

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2563EB),
    appBarTheme: const AppBarTheme(
        color: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16
        ),
        iconTheme: IconThemeData(
            color: Colors.black
        )
    ),
    extensions: const <ThemeExtension<dynamic>>[
      TWColors(
          primary: Color(0xFF2563EB),
          primaryBackgroundColor: Color(0xFFFFFFFF),
          secondBackgroundColor: Color(0xFFF3F4F6),
          thirdBackgroundColor: Color(0xFFE5E7EB),
          primaryTextColor: Color(0xFF111827),
          secondTextColor: Color(0xFF6B7280),
          thirdTextColor: Color(0xFF9CA3AF),
          dividerBackgroundColor: Color(0xFFE5E5E5),
          iconTintColor: Color(0xFF000000)),
    ],
  );

  static final darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3B82F6),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF25262A),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16
        ),
        iconTheme: IconThemeData(
            color: Colors.white
        )
    ),
    extensions: const <ThemeExtension<dynamic>>[
      TWColors(
          primary: Color(0xFF3B82F6),
          primaryBackgroundColor: Color(0xFF171717),
          secondBackgroundColor: Color(0xFF0A0A0A),
          thirdBackgroundColor: Color(0xFF262626),
          primaryTextColor: Color(0xFFFFFFFF),
          secondTextColor: Color(0xFFD1D5DB),
          thirdTextColor: Color(0xFF6B7280),
          dividerBackgroundColor: Color(0xFF404040),
          iconTintColor: Color(0xFFFFFFFF)),
    ],
  );
}
