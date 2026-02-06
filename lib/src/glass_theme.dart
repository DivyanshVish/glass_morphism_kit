import 'package:flutter/material.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';

/// Theme data for glass widgets.
///
/// Use [GlassTheme] to provide consistent styling across all glass widgets
/// in your application.
///
/// Example:
/// ```dart
/// GlassTheme(
///   data: GlassThemeData(
///     blur: 15.0,
///     opacity: 0.15,
///     performance: GlassPerformance.medium,
///   ),
///   child: MyApp(),
/// )
/// ```
class GlassTheme extends InheritedWidget {
  /// Creates a glass theme.
  const GlassTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The theme data for glass widgets.
  final GlassThemeData data;

  /// Returns the [GlassThemeData] from the closest [GlassTheme] ancestor.
  ///
  /// If there is no ancestor, returns [GlassThemeData.defaults].
  static GlassThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<GlassTheme>();
    return theme?.data ?? GlassThemeData.defaults();
  }

  /// Returns the [GlassThemeData] from the closest [GlassTheme] ancestor,
  /// or null if there is no ancestor.
  static GlassThemeData? maybeOf(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<GlassTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(GlassTheme oldWidget) {
    return data != oldWidget.data;
  }
}

/// Configuration data for glass widgets.
///
/// All properties are optional and will use sensible defaults if not specified.
class GlassThemeData {
  /// Creates glass theme data.
  const GlassThemeData({
    this.blur,
    this.opacity,
    this.borderRadius,
    this.borderWidth,
    this.borderGradient,
    this.backgroundGradient,
    this.frostColor,
    this.noise,
    this.performance,
    this.animationDuration,
    this.animationCurve,
  });

  /// Creates default glass theme data.
  factory GlassThemeData.defaults() {
    return const GlassThemeData(
      blur: GlassConstants.defaultBlur,
      opacity: GlassConstants.defaultOpacity,
      borderRadius: GlassConstants.defaultBorderRadius,
      borderWidth: GlassConstants.defaultBorderWidth,
      frostColor: GlassConstants.defaultFrostColor,
      noise: GlassConstants.defaultNoiseOpacity,
      performance: GlassPerformance.medium,
      animationDuration: GlassConstants.defaultAnimationDuration,
      animationCurve: GlassConstants.defaultAnimationCurve,
    );
  }

  /// Creates a dark glass theme matching Apple's dark mode frosted glass.
  factory GlassThemeData.dark() {
    return GlassThemeData(
      blur: 80.0,
      opacity: 0.1,
      borderRadius: GlassConstants.defaultBorderRadius,
      borderWidth: 0.5,
      frostColor: Colors.white,
      performance: GlassPerformance.medium,
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
    );
  }

  /// Creates a light glass theme matching Apple's frosted glass aesthetic.
  factory GlassThemeData.light() {
    return GlassThemeData(
      blur: 80.0,
      opacity: 0.1,
      borderRadius: GlassConstants.defaultBorderRadius,
      borderWidth: 0.5,
      frostColor: Colors.white,
      performance: GlassPerformance.medium,
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
    );
  }

  /// The blur sigma value.
  final double? blur;

  /// The background opacity (0.0 to 1.0).
  final double? opacity;

  /// The border radius for glass containers.
  final BorderRadius? borderRadius;

  /// The border width.
  final double? borderWidth;

  /// The gradient for the border.
  final Gradient? borderGradient;

  /// The gradient for the background.
  final Gradient? backgroundGradient;

  /// The frost/tint color.
  final Color? frostColor;

  /// The noise overlay opacity (0.0 to 1.0).
  final double? noise;

  /// The performance mode.
  final GlassPerformance? performance;

  /// The animation duration for transitions.
  final Duration? animationDuration;

  /// The animation curve for transitions.
  final Curve? animationCurve;

  /// Creates a copy of this theme data with the given fields replaced.
  GlassThemeData copyWith({
    double? blur,
    double? opacity,
    BorderRadius? borderRadius,
    double? borderWidth,
    Gradient? borderGradient,
    Gradient? backgroundGradient,
    Color? frostColor,
    double? noise,
    GlassPerformance? performance,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return GlassThemeData(
      blur: blur ?? this.blur,
      opacity: opacity ?? this.opacity,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderGradient: borderGradient ?? this.borderGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      frostColor: frostColor ?? this.frostColor,
      noise: noise ?? this.noise,
      performance: performance ?? this.performance,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  /// Merges this theme data with another, preferring values from [other].
  GlassThemeData merge(GlassThemeData? other) {
    if (other == null) return this;
    return copyWith(
      blur: other.blur,
      opacity: other.opacity,
      borderRadius: other.borderRadius,
      borderWidth: other.borderWidth,
      borderGradient: other.borderGradient,
      backgroundGradient: other.backgroundGradient,
      frostColor: other.frostColor,
      noise: other.noise,
      performance: other.performance,
      animationDuration: other.animationDuration,
      animationCurve: other.animationCurve,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GlassThemeData &&
        other.blur == blur &&
        other.opacity == opacity &&
        other.borderRadius == borderRadius &&
        other.borderWidth == borderWidth &&
        other.borderGradient == borderGradient &&
        other.backgroundGradient == backgroundGradient &&
        other.frostColor == frostColor &&
        other.noise == noise &&
        other.performance == performance &&
        other.animationDuration == animationDuration &&
        other.animationCurve == animationCurve;
  }

  @override
  int get hashCode {
    return Object.hash(
      blur,
      opacity,
      borderRadius,
      borderWidth,
      borderGradient,
      backgroundGradient,
      frostColor,
      noise,
      performance,
      animationDuration,
      animationCurve,
    );
  }
}
