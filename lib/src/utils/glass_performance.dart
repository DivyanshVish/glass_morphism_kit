/// Performance mode for glass rendering.
///
/// Controls the level of visual effects applied to glass widgets,
/// allowing you to balance between visual quality and performance.
enum GlassPerformance {
  /// Reduced blur for better performance on low-end devices.
  ///
  /// - Blur sigma is reduced by 50%
  /// - Simpler rendering
  low,

  /// Full quality mode with standard blur and gradient effects.
  ///
  /// - Full blur effect
  /// - Gradient backgrounds and borders
  medium,
}

/// Extension methods for [GlassPerformance].
extension GlassPerformanceExtension on GlassPerformance {
  /// Returns the blur multiplier for this performance mode.
  double get blurMultiplier {
    switch (this) {
      case GlassPerformance.low:
        return 0.5;
      case GlassPerformance.medium:
        return 1.0;
    }
  }

  /// Whether gradient effects should be rendered.
  bool get enableGradient {
    return this != GlassPerformance.low;
  }
}
