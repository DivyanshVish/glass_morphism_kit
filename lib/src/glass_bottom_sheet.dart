import 'package:flutter/material.dart';
import 'glass_container.dart';
import 'glass_theme.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';
import 'utils/blur_cache.dart';

/// A modal bottom sheet with glassmorphism styling.
///
/// This bottom sheet is keyboard-aware and will automatically adjust its
/// position when the keyboard appears.
///
/// Example:
/// ```dart
/// showGlassBottomSheet(
///   context: context,
///   builder: (context) => GlassBottomSheet(
///     child: Column(
///       children: [
///         Text('Bottom Sheet Title'),
///         Text('Content goes here'),
///       ],
///     ),
///   ),
/// );
/// ```
class GlassBottomSheet extends StatelessWidget {
  /// Creates a glass bottom sheet.
  const GlassBottomSheet({
    super.key,
    required this.child,
    this.blur,
    this.opacity,
    this.borderRadius,
    this.borderGradient,
    this.backgroundGradient,
    this.borderWidth,
    this.noise,
    this.frostColor,
    this.performance,
    this.padding,
    this.minHeight,
    this.maxHeight,
    this.showHandle = true,
    this.handleColor,
    this.handleWidth = 40,
    this.handleHeight = 4,
    this.enableDrag = true,
  });

  /// The child widget to display.
  final Widget child;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The border radius.
  final BorderRadius? borderRadius;

  /// The border gradient.
  final Gradient? borderGradient;

  /// The background gradient.
  final Gradient? backgroundGradient;

  /// The border width.
  final double? borderWidth;

  /// The noise overlay opacity.
  final double? noise;

  /// The frost color.
  final Color? frostColor;

  /// The performance mode.
  final GlassPerformance? performance;

  /// The padding inside the bottom sheet.
  final EdgeInsetsGeometry? padding;

  /// The minimum height of the bottom sheet.
  final double? minHeight;

  /// The maximum height of the bottom sheet.
  final double? maxHeight;

  /// Whether to show the drag handle.
  final bool showHandle;

  /// The color of the drag handle.
  final Color? handleColor;

  /// The width of the drag handle.
  final double handleWidth;

  /// The height of the drag handle.
  final double handleHeight;

  /// Whether the bottom sheet can be dragged.
  final bool enableDrag;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;

    final effectiveBorderRadius = borderRadius ??
        theme.borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        );

    final effectivePadding = padding ?? const EdgeInsets.all(16);
    final effectiveHandleColor =
        handleColor ?? Colors.white.withValues(alpha: 0.3);

    Widget content = child;

    if (showHandle) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: handleWidth,
            height: handleHeight,
            decoration: BoxDecoration(
              color: effectiveHandleColor,
              borderRadius: BorderRadius.circular(handleHeight / 2),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(child: child),
        ],
      );
    }

    return AnimatedPadding(
      duration: GlassConstants.defaultAnimationDuration,
      curve: GlassConstants.defaultAnimationCurve,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0,
          maxHeight: maxHeight ?? mediaQuery.size.height * 0.9,
        ),
        child: GlassContainer(
          blur: blur,
          opacity: opacity,
          borderRadius: effectiveBorderRadius,
          borderGradient: borderGradient,
          backgroundGradient: backgroundGradient,
          borderWidth: borderWidth,
          noise: noise,
          frostColor: frostColor,
          performance: performance,
          padding: effectivePadding,
          child: SafeArea(
            top: false,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Shows a glass bottom sheet.
///
/// This function displays a modal bottom sheet with glassmorphism styling.
/// The bottom sheet is keyboard-aware and will adjust when the keyboard appears.
///
/// Returns a [Future] that resolves to the value passed to [Navigator.pop]
/// when the bottom sheet is closed.
Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: builder,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.3),
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
  );
}

/// A scrollable glass bottom sheet with a header.
///
/// This is useful for bottom sheets with long content that needs scrolling.
class GlassScrollableBottomSheet extends StatelessWidget {
  /// Creates a scrollable glass bottom sheet.
  const GlassScrollableBottomSheet({
    super.key,
    required this.children,
    this.header,
    this.blur,
    this.opacity,
    this.borderRadius,
    this.borderGradient,
    this.borderWidth,
    this.frostColor,
    this.performance,
    this.padding,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.9,
    this.showHandle = true,
    this.handleColor,
    this.snap = false,
    this.snapSizes,
  });

  /// The children widgets to display in the scrollable area.
  final List<Widget> children;

  /// The header widget (fixed at the top).
  final Widget? header;

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

  /// The padding inside the bottom sheet.
  final EdgeInsetsGeometry? padding;

  /// The initial size as a fraction of the screen height.
  final double initialChildSize;

  /// The minimum size as a fraction of the screen height.
  final double minChildSize;

  /// The maximum size as a fraction of the screen height.
  final double maxChildSize;

  /// Whether to show the drag handle.
  final bool showHandle;

  /// The color of the drag handle.
  final Color? handleColor;

  /// Whether to snap to [snapSizes].
  final bool snap;

  /// The sizes to snap to.
  final List<double>? snapSizes;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    final effectiveBorderRadius = borderRadius ??
        theme.borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        );

    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 16);
    final effectiveHandleColor =
        handleColor ?? Colors.white.withValues(alpha: 0.3);

    final effectiveBlur = blur ?? theme.blur ?? GlassConstants.defaultBlur;
    final effectiveOpacity = opacity ?? theme.opacity ?? GlassConstants.defaultOpacity;
    final effectiveFrostColor = frostColor ?? theme.frostColor ?? GlassConstants.defaultFrostColor;
    final effectivePerformance = performance ?? theme.performance ?? GlassPerformance.medium;
    final adjustedBlur = effectiveBlur * effectivePerformance.blurMultiplier;

    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      snap: snap,
      snapSizes: snapSizes,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: BackdropFilter(
            filter: BlurCache.instance.getBlurFilter(adjustedBlur, adjustedBlur),
            child: Container(
              decoration: BoxDecoration(
                color: effectiveFrostColor.withValues(alpha: effectiveOpacity),
                borderRadius: effectiveBorderRadius,
              ),
              child: Column(
                children: [
                  if (showHandle) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: effectiveHandleColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (header != null)
                    Padding(
                      padding: effectivePadding,
                      child: header,
                    ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: effectivePadding,
                      children: children,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shows a scrollable glass bottom sheet.
Future<T?> showGlassScrollableBottomSheet<T>({
  required BuildContext context,
  required List<Widget> children,
  Widget? header,
  double? blur,
  double? opacity,
  BorderRadius? borderRadius,
  Gradient? borderGradient,
  double? borderWidth,
  Color? frostColor,
  GlassPerformance? performance,
  EdgeInsetsGeometry? padding,
  double initialChildSize = 0.5,
  double minChildSize = 0.25,
  double maxChildSize = 0.9,
  bool showHandle = true,
  Color? handleColor,
  bool snap = false,
  List<double>? snapSizes,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.3),
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: true,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (context) => GlassScrollableBottomSheet(
      header: header,
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      borderGradient: borderGradient,
      borderWidth: borderWidth,
      frostColor: frostColor,
      performance: performance,
      padding: padding,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      showHandle: showHandle,
      handleColor: handleColor,
      snap: snap,
      snapSizes: snapSizes,
      children: children,
    ),
  );
}
