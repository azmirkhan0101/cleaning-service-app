import 'package:flutter/material.dart';

/// Spacing & Layout
extension SpacingExtensions on num {
  /// Returns a SizedBox with width equal to the number.
  SizedBox get widthBox => SizedBox(width: toDouble());

  /// Returns a SizedBox with height equal to the number.
  SizedBox get heightBox => SizedBox(height: toDouble());

  /// Returns an EdgeInsets with all sides equal to the number.
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// Returns an EdgeInsets with horizontal padding equal to the number.
  EdgeInsets get paddingX => EdgeInsets.symmetric(horizontal: toDouble());

  /// Returns an EdgeInsets with vertical padding equal to the number.
  EdgeInsets get paddingY => EdgeInsets.symmetric(vertical: toDouble());

  /// Returns an EdgeInsets with left padding equal to the number.
  EdgeInsets get paddingL => EdgeInsets.only(left: toDouble());

  /// Returns an EdgeInsets with right padding equal to the number.
  EdgeInsets get paddingR => EdgeInsets.only(right: toDouble());

  /// Returns an EdgeInsets with top padding equal to the number.
  EdgeInsets get paddingT => EdgeInsets.only(top: toDouble());

  /// Returns an EdgeInsets with bottom padding equal to the number.
  EdgeInsets get paddingB => EdgeInsets.only(bottom: toDouble());
}
