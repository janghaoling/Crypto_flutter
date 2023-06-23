import 'package:flutter/material.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';

class CustomStyle {
  static var textStyle = TextStyle(
    color: RGB.whiteColor,
    fontSize: Dimension.defaultSize,
  );

  static var hintTextStyle = TextStyle(
    color: RGB.whiteColor,
    fontSize: Dimension.defaultSize,
  );

  static var defaultStyle = TextStyle(
    color: RGB.primaryColor,
    fontSize: Dimension.defaultSize,
  );

  static var focusBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(Dimension.defaultSize / 2),
    ),
    borderSide: BorderSide(
      color: RGB.borderColor,
      width: 0,
    ),
  );

  static var focusErrorBorder = OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(Dimension.defaultSize / 2),
    ),
    borderSide: BorderSide(
      color: RGB.borderColor,
      width: 0,
    ),
  );

  static var boxDecoration = BoxDecoration(
    color: RGB.secondaryColor,
    borderRadius: BorderRadius.circular(
      Dimension.defaultSize / 2,
    ),
  );
}
