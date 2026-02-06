import 'package:flutter/material.dart';
import 'glass_container.dart';
import 'glass_theme.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';

/// A card widget with glassmorphism styling.
///
/// This is a convenience wrapper around [GlassContainer] with card-like
/// defaults including padding and elevation styling.
///
/// Example:
/// ```dart
/// GlassCard(
///   child: Column(
///     children: [
///       Text('Card Title'),
///       Text('Card content goes here'),
///     ],
///   ),
/// )
/// ```
///
/// See also:
/// - [GlassContainer] for more customization options
/// - [GlassButton] for interactive elements
class GlassCard extends StatelessWidget {
  /// Creates a glass card.
  const GlassCard({
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
    this.elevation = 0,
    this.shadowColor,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The child widget to display inside the card.
  final Widget? child;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity (0.0 to 1.0).
  final double? opacity;

  /// The border radius for the card.
  final BorderRadius? borderRadius;

  /// The solid color for the border.
  final Color? borderColor;

  /// The gradient for the border.
  final Gradient? borderGradient;

  /// The gradient for the background.
  final Gradient? backgroundGradient;

  /// The width of the border.
  final double? borderWidth;

  /// The noise overlay opacity (0.0 to 1.0).
  final double? noise;

  /// The frost/tint color.
  final Color? frostColor;

  /// The performance mode.
  final GlassPerformance? performance;

  /// The width of the card.
  final double? width;

  /// The height of the card.
  final double? height;

  /// Additional constraints for the card.
  final BoxConstraints? constraints;

  /// The margin around the card.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the card.
  ///
  /// Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? padding;

  /// The alignment of the child within the card.
  final AlignmentGeometry? alignment;

  /// The elevation of the card shadow.
  ///
  /// Defaults to 0.
  final double elevation;

  /// The color of the card shadow.
  final Color? shadowColor;

  /// The clip behavior for the card.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final effectiveBorderRadius =
        borderRadius ?? theme.borderRadius ?? GlassConstants.defaultBorderRadius;
    final effectivePadding = padding ?? const EdgeInsets.all(16);

    Widget card = GlassContainer(
      blur: blur,
      opacity: opacity,
      borderRadius: effectiveBorderRadius,
      borderColor: borderColor,
      borderGradient: borderGradient,
      backgroundGradient: backgroundGradient,
      borderWidth: borderWidth,
      noise: noise,
      frostColor: frostColor,
      performance: performance,
      width: width,
      height: height,
      constraints: constraints,
      padding: effectivePadding,
      alignment: alignment,
      clipBehavior: clipBehavior,
      child: child,
    );

    if (elevation > 0) {
      final effectiveShadowColor = shadowColor ?? Colors.black.withValues(alpha: 0.2);
      card = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          boxShadow: [
            BoxShadow(
              color: effectiveShadowColor,
              blurRadius: elevation * 2,
              offset: Offset(0, elevation),
            ),
          ],
        ),
        child: card,
      );
    }

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}

/// A glass card with a header section.
///
/// This provides a convenient layout for cards with a title and content area.
class GlassCardWithHeader extends StatelessWidget {
  /// Creates a glass card with a header.
  const GlassCardWithHeader({
    super.key,
    required this.header,
    required this.content,
    this.headerPadding,
    this.contentPadding,
    this.dividerColor,
    this.blur,
    this.opacity,
    this.borderRadius,
    this.borderGradient,
    this.borderWidth,
    this.frostColor,
    this.performance,
    this.width,
    this.height,
    this.margin,
  });

  /// The header widget.
  final Widget header;

  /// The content widget.
  final Widget content;

  /// Padding for the header section.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding for the content section.
  final EdgeInsetsGeometry? contentPadding;

  /// Color of the divider between header and content.
  final Color? dividerColor;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The border radius.
  final BorderRadius? borderRadius;

  /// The border gradient.
  final Gradient? borderGradient;

  /// The border width.
  final double? borderWidth;

  /// The frost color.
  final Color? frostColor;

  /// The performance mode.
  final GlassPerformance? performance;

  /// The width of the card.
  final double? width;

  /// The height of the card.
  final double? height;

  /// The margin around the card.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final effectiveDividerColor =
        dividerColor ?? Colors.white.withValues(alpha: 0.1);
    final effectiveHeaderPadding =
        headerPadding ?? const EdgeInsets.all(16);
    final effectiveContentPadding =
        contentPadding ?? const EdgeInsets.all(16);

    return GlassCard(
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      borderGradient: borderGradient,
      borderWidth: borderWidth,
      frostColor: frostColor,
      performance: performance,
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: effectiveHeaderPadding,
            child: header,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: effectiveDividerColor,
          ),
          Padding(
            padding: effectiveContentPadding,
            child: content,
          ),
        ],
      ),
    );
  }
}
