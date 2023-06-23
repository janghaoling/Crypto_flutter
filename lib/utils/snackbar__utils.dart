import 'package:flutter/material.dart';
import 'package:crypto/utils/Dimension_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';
import 'package:crypto/utils/navigator_key.dart';

class SnackBarUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      {required String title, required bool isError}) {
    return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: RGB.whiteColor,
            ),
            SizedBox(
              width: Dimension.smSize,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.orange : Colors.green,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(
          vertical: Dimension.smSize,
          horizontal: Dimension.defaultSize,
        ),
      ),
    );
  }
}
