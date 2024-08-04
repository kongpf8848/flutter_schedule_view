import 'package:flutter/material.dart';

///Tailwind颜色定义
@immutable
class TWColors extends ThemeExtension<TWColors> {
  ///gray
  static const int _grayPrimaryValue = 0xFF6B7280;
  static const MaterialColor gray = MaterialColor(
    _grayPrimaryValue,
    <int, Color>{
      50: Color(0xFFF9FAFB),
      100: Color(0xFFF3F4F6),
      200: Color(0xFFE5E7EB),
      300: Color(0xFFD1D5DB),
      400: Color(0xFF9CA3AF),
      500: Color(0xFF6B7280),
      600: Color(0xFF4B5563),
      700: Color(0xFF374151),
      800: Color(0xFF1F2937),
      900: Color(0xFF111827),
    },
  );

  ///neutral
  static const int _neutralPrimaryValue = 0xFF737373;
  static const MaterialColor neutral = MaterialColor(
    _neutralPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFE5E5E5),
      300: Color(0xFFD4D4D4),
      400: Color(0xFFA3A3A3),
      500: Color(0xFF737373),
      600: Color(0xFF525252),
      700: Color(0xFF404040),
      800: Color(0xFF262626),
      900: Color(0xFF171717),
    },
  );

  ///red
  static const int _redPrimaryValue = 0xFFEF4444;
  static const MaterialColor red = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFFFEF2F2),
      100: Color(0xFFFEE2E2),
      200: Color(0xFFFECACA),
      300: Color(0xFFFCA5A5),
      400: Color(0xFFF87171),
      500: Color(0xFFEF4444),
      600: Color(0xFFDC2626),
      700: Color(0xFFB91C1C),
      800: Color(0xFF991B1B),
      900: Color(0xFF7F1D1D),
    },
  );

  ///green
  static const int _greenPrimaryValue = 0xFF22C55E;
  static const MaterialColor green = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xFFF0FDF4),
      100: Color(0xFFDCFCE7),
      200: Color(0xFFBBF7D0),
      300: Color(0xFF86EFAC),
      400: Color(0xFF4ADE80),
      500: Color(0xFF22C55E),
      600: Color(0xFF16A34A),
      700: Color(0xFF15803D),
      800: Color(0xFF166534),
      900: Color(0xFF14532D),
    },
  );

  ///yellow
  static const int _yellowPrimaryValue = 0xFFEAB308;
  static const MaterialColor yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xFFFEFCE8),
      100: Color(0xFFFEF9C3),
      200: Color(0xFFFEF08A),
      300: Color(0xFFFDE047),
      400: Color(0xFFFACC15),
      500: Color(0xFFEAB308),
      600: Color(0xFFCA8A04),
      700: Color(0xFFA16207),
      800: Color(0xFF854D0E),
      900: Color(0xFF713F12),
    },
  );

  ///blue
  static const int _bluePrimaryValue = 0xFF3B82F6;
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFEFF6FF),
      100: Color(0xFFDBEAFE),
      200: Color(0xFFBFDBFE),
      300: Color(0xFF93C5FD),
      400: Color(0xFF60A5FA),
      500: Color(0xFF3B82F6),
      600: Color(0xFF2563EB),
      700: Color(0xFF1D4ED8),
      800: Color(0xFF1E40AF),
      900: Color(0xFF1E3A8A),
    },
  );

  const TWColors(
      {required this.primary,
      required this.primaryBackgroundColor,
      required this.secondBackgroundColor,
      required this.thirdBackgroundColor,
      required this.primaryTextColor,
      required this.secondTextColor,
      required this.thirdTextColor,
      required this.dividerBackgroundColor,
      required this.iconTintColor});

  final Color? primary;

  final Color? primaryBackgroundColor;

  final Color? secondBackgroundColor;

  final Color? thirdBackgroundColor;

  final Color? primaryTextColor;

  final Color? secondTextColor;

  final Color? thirdTextColor;

  final Color? dividerBackgroundColor;

  final Color? iconTintColor;

  @override
  TWColors copyWith(
      {Color? primaryColor,
      Color? primaryBackgroundColor,
      Color? secondBackgroundColor,
      Color? thirdBackgroundColor,
      Color? primaryTextColor,
      Color? secondTextColor,
      Color? thirdTextColor,
      Color? dividerBackgroundColor,
      Color? ruleBackgroundColor,
      Color? iconTintColor}) {
    return TWColors(
      primary: primaryColor ?? this.primary,
      primaryBackgroundColor:
          primaryBackgroundColor ?? this.primaryBackgroundColor,
      secondBackgroundColor:
          secondBackgroundColor ?? this.secondBackgroundColor,
      thirdBackgroundColor: thirdBackgroundColor ?? this.thirdBackgroundColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondTextColor: secondTextColor ?? this.secondTextColor,
      thirdTextColor: thirdTextColor ?? this.thirdTextColor,
      dividerBackgroundColor:
          dividerBackgroundColor ?? this.dividerBackgroundColor,
      iconTintColor: iconTintColor ?? this.iconTintColor,
    );
  }

  @override
  TWColors lerp(TWColors? other, double t) {
    if (other is! TWColors) {
      return this;
    }
    return TWColors(
      primary: Color.lerp(primary, other.primary, t),
      primaryBackgroundColor:
          Color.lerp(primaryBackgroundColor, other.primaryBackgroundColor, t),
      secondBackgroundColor:
          Color.lerp(secondBackgroundColor, other.secondBackgroundColor, t),
      thirdBackgroundColor:
          Color.lerp(thirdBackgroundColor, other.thirdBackgroundColor, t),
      primaryTextColor: Color.lerp(primaryTextColor, other.primaryTextColor, t),
      secondTextColor: Color.lerp(secondTextColor, other.secondTextColor, t),
      thirdTextColor: Color.lerp(thirdTextColor, other.thirdTextColor, t),
      dividerBackgroundColor:
          Color.lerp(dividerBackgroundColor, other.dividerBackgroundColor, t),
      iconTintColor: Color.lerp(iconTintColor, other.iconTintColor, t),
    );
  }
}
