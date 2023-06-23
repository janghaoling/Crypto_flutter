import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/utils/custom_style.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/fonts_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';

class MyTheme {
  static var systemUI = SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: RGB.primaryColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: RGB.secondaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // theme => 0 mean light || 1 mean dark
  // top
  static updateStatusBar(dynamic bgColor, dynamic theme) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: bgColor,
          statusBarBrightness: theme == 0 ? Brightness.light : Brightness.dark,
          statusBarIconBrightness:
              theme == 0 ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness:
              theme == 0 ? Brightness.light : Brightness.dark,
        ),
      );
    }
  }

  // bottom
  static updateNavigationBar(dynamic bgColor, dynamic theme) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: bgColor,
          systemNavigationBarIconBrightness:
              theme == 0 ? Brightness.light : Brightness.dark,
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarDividerColor: const Color(0x00000000),
        ),
      );
    }
  }

  static ThemeData appTheme = ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: Fonts.primaryFont,
    appBarTheme: AppBarTheme(
      backgroundColor: RGB.primaryColor,
      foregroundColor: RGB.whiteColor,
      elevation: 1,
      shadowColor: RGB.grayColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: RGB.whiteColor),
      contentPadding: const EdgeInsets.all(
        Dimension.defaultSize,
      ),
      filled: true,
      fillColor: RGB.secondaryColor,
      focusedBorder: CustomStyle.focusBorder,
      enabledBorder: CustomStyle.focusErrorBorder,
      focusedErrorBorder: CustomStyle.focusErrorBorder,
      errorBorder: CustomStyle.focusErrorBorder,
    ),
  );
}
