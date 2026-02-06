import 'package:flutter/material.dart';
import 'glass_theme.dart';
import 'glass_border_painter.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';
import 'utils/blur_cache.dart';

/// A container widget with glassmorphism effect.
///
/// This widget creates a frosted glass appearance using [BackdropFilter]
/// with configurable blur, opacity, borders, and optional noise overlay.
///
/// Example:
/// ```dart
/// GlassContainer(
///   blur: 10.0,
///   opacity: 0.1,
///   borderRadius: BorderRadius.circular(16),
///   child: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Hello Glass'),
///   ),
/// )
/// ```
///
/// See also:
/// - [GlassCard] for a pre-styled card variant
/// - [AnimatedGlassContainer] for animated transitions
/// - [GlassTheme] for providing consistent styling
class GlassContainer extends StatelessWidget {
  /// Creates a glass container.
  const GlassContainer({
    super.key,
    this.child,
    this.blur,
    this.opacity,
    this.borderRadius,
    this.borderColor,
    this.borderGradient,
    this.backgroundGradient,
    this.borderWidth,
    this.noise,
    this.frostColor,
    this.performance,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.padding,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
    this.enableBlur = true,
  });

  /// The child widget to display inside the container.
  final Widget? child;

  /// The blur sigma value. Higher values create more blur.
  ///
  /// If null, uses the value from [GlassTheme] or [GlassConstants.defaultBlur].
  final double? blur;

  /// The background opacity (0.0 to 1.0).
  ///
  /// If null, uses the value from [GlassTheme] or [GlassConstants.defaultOpacity].
  final double? opacity;

  /// The border radius for the container.
  ///
  /// If null, uses the value from [GlassTheme] or [GlassConstants.defaultBorderRadius].
  final BorderRadius? borderRadius;

  /// The solid color for the border.
  ///
  /// If specified, this takes priority over [borderGradient].
  /// Use this for a simple solid color border instead of a gradient.
  final Color? borderColor;

  /// The gradient for the border.
  ///
  /// If null, uses the value from [GlassTheme] or a default white gradient.
  /// Note: [borderColor] takes priority if both are specified.
  final Gradient? borderGradient;

  /// The gradient for the background.
  ///
  /// If specified, this is drawn over the frost color.
  final Gradient? backgroundGradient;

  /// The width of the border.
  ///
  /// If null, uses the value from [GlassTheme] or [GlassConstants.defaultBorderWidth].
  final double? borderWidth;

  /// The noise overlay opacity (0.0 to 1.0).
  ///
  /// Set to 0 to disable noise. If null, uses the value from [GlassTheme].
  final double? noise;

  /// The frost/tint color applied to the glass.
  ///
  /// If null, uses the value from [GlassTheme] or [GlassConstants.defaultFrostColor].
  final Color? frostColor;

  /// The performance mode controlling visual quality.
  ///
  /// If null, uses the value from [GlassTheme] or [GlassPerformance.medium].
  final GlassPerformance? performance;

  /// The width of the container.
  final double? width;

  /// The height of the container.
  final double? height;

  /// Additional constraints to apply to the container.
  final BoxConstraints? constraints;

  /// The margin around the container.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the container.
  final EdgeInsetsGeometry? padding;

  /// The alignment of the child within the container.
  final AlignmentGeometry? alignment;

  /// The clip behavior for the container.
  final Clip clipBehavior;

  /// Whether to enable the blur effect.
  ///
  /// Set to false to disable blur (useful for testing or performance).
  final bool enableBlur;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    final effectiveBlur = blur ?? theme.blur ?? GlassConstants.defaultBlur;
    final effectiveOpacity =
        opacity ?? theme.opacity ?? GlassConstants.defaultOpacity;
    final effectiveBorderRadius =
        borderRadius ?? theme.borderRadius ?? GlassConstants.defaultBorderRadius;
    final effectiveBorderWidth =
        borderWidth ?? theme.borderWidth ?? GlassConstants.defaultBorderWidth;
    final effectiveFrostColor =
        frostColor ?? theme.frostColor ?? GlassConstants.defaultFrostColor;
    final effectivePerformance =
        performance ?? theme.performance ?? GlassPerformance.medium;

    // If borderColor is set, create a solid color gradient, otherwise use borderGradient
    final effectiveBorderGradient = borderColor != null
        ? LinearGradient(colors: [borderColor!, borderColor!])
        : (borderGradient ??
            theme.borderGradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.6),
                Colors.white.withValues(alpha: 0.1),
              ],
            ));

    final effectiveBackgroundGradient = backgroundGradient ?? theme.backgroundGradient;

    final adjustedBlur = effectiveBlur * effectivePerformance.blurMultiplier;

    Widget content = child ?? const SizedBox.shrink();

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (alignment != null) {
      content = Align(alignment: alignment!, child: content);
    }

    Widget glassContent = _buildGlassEffect(
      context: context,
      child: content,
      blur: adjustedBlur,
      opacity: effectiveOpacity,
      borderRadius: effectiveBorderRadius,
      borderWidth: effectiveBorderWidth,
      borderGradient: effectiveBorderGradient,
      backgroundGradient: effectiveBackgroundGradient,
      frostColor: effectiveFrostColor,
    );

    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        child: glassContent,
      ),
    );
  }

  Widget _buildGlassEffect({
    required BuildContext context,
    required Widget child,
    required double blur,
    required double opacity,
    required BorderRadius borderRadius,
    required double borderWidth,
    required Gradient borderGradient,
    required Gradient? backgroundGradient,
    required Color frostColor,
  }) {
    final blurSigma = blur.clamp(GlassConstants.minBlurSigma, double.infinity);

    Widget result = ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          if (enableBlur && blurSigma > 0)
            Positioned.fill(
              child: BackdropFilter(
                filter: BlurCache.instance.getBlurFilter(blurSigma, blurSigma),
                child: const SizedBox.expand(),
              ),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: frostColor.withValues(alpha: opacity.clamp(0.0, 1.0)),
                gradient: backgroundGradient,
              ),
            ),
          ),
          child,
        ],
      ),
    );

    if (borderWidth > 0) {
      result = CustomPaint(
        painter: GlassBorderPainter(
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          gradient: borderGradient,
        ),
        child: result,
      );
    }

    return result;
  }
}
