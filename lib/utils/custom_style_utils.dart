import 'package:flutter/material.dart';
import 'package:crypto/utils/Dimension_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';

class CustomStyle {
  static TextStyle textStyle = const TextStyle(
    color: RGB.lightDarker,
    fontSize: Dimension.defaultSize,
  );
  static RoundedRectangleBorder modalShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(
        Dimension.lgSize,
      ),
      topRight: Radius.circular(
        Dimension.lgSize,
      ),
    ),
  );
}
