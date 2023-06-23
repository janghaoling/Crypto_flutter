import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';
import 'package:flutter/material.dart';

final primaryBtn = ElevatedButton.styleFrom(
  backgroundColor: RGB.primaryColor,
);
final secondaryBtn = ElevatedButton.styleFrom(
  backgroundColor: RGB.primaryColor,
);
final primaryBtnRounded = ElevatedButton.styleFrom(
  backgroundColor: RGB.primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Dimension.defaultSize * 100),
  ),
);
final secondaryBtnRounded = ElevatedButton.styleFrom(
  backgroundColor: RGB.primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Dimension.defaultSize * 100),
  ),
);

class FormsUtils {
  static inputStyle({
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? suffixOnPressed,
    bool? passwordVisibility,
    required String hintText,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: Dimension.lgSize,
            )
          : null,
      suffixIcon: suffixOnPressed != null
          ? IconButton(
              onPressed: () {
                suffixOnPressed.call();
              },
              icon: passwordVisibility!
                  ? const Icon(
                      Icons.visibility_outlined,
                      color: RGB.lightDarker,
                    )
                  : const Icon(
                      Icons.visibility_off_outlined,
                      color: RGB.lightDarker,
                    ),
            )
          : suffixIcon != null
              ? Icon(suffixIcon)
              : null,
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: RGB.lightDarker,
        ),
      ),
      hintText: hintText,
      fillColor: RGB.whiteColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimension.radiusSize),
        borderSide: const BorderSide(
          color: RGB.muted,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimension.radiusSize),
        borderSide: const BorderSide(
          color: RGB.muted,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimension.radiusSize),
        borderSide: const BorderSide(
          color: RGB.lightDarker,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimension.radiusSize),
        borderSide: const BorderSide(
          color: RGB.lightDarker,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.all(
        Dimension.defaultSize / 1.25,
      ),
      counterText: '',
    );
  }
}
