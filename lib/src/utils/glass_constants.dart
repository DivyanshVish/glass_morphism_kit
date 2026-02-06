import 'package:flutter/material.dart';

/// Default constants used throughout the glass UI kit.
/// These values are tuned to match Apple's frosted glass aesthetic.
abstract class GlassConstants {
  /// Default blur sigma value (high blur = frosted effect).
  static const double defaultBlur = 80.0;

  /// Default background opacity (low = more transparent, blur does the work).
  static const double defaultOpacity = 0.1;

  /// Default border radius.
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(16.0));

  /// Default border width (thin subtle border).
  static const double defaultBorderWidth = 0.5;

  /// Default frost color.
  static const Color defaultFrostColor = Colors.white;

  /// Default noise opacity (very subtle).
  static const double defaultNoiseOpacity = 0.02;

  /// Default animation duration.
  static const Duration defaultAnimationDuration = Duration(milliseconds: 200);

  /// Default animation curve.
  static const Curve defaultAnimationCurve = Curves.easeInOut;

  /// Default button scale on press.
  static const double defaultButtonPressScale = 0.95;

  /// Minimum blur sigma (for fallback).
  static const double minBlurSigma = 0.1;
}
