import 'package:flutter/material.dart';
import 'glass_theme.dart';
import 'glass_border_painter.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';
import 'utils/blur_cache.dart';

/// An animated glass container with implicit animations.
///
/// This widget smoothly animates changes to blur, opacity, and other properties.
/// It's useful for creating dynamic glass effects that respond to state changes.
///
/// Example:
/// ```dart
/// AnimatedGlassContainer(
///   blur: isActive ? 15.0 : 5.0,
///   opacity: isActive ? 0.2 : 0.1,
///   duration: Duration(milliseconds: 300),
///   child: Text('Animated Glass'),
/// )
/// ```
///
/// See also:
/// - [GlassContainer] for non-animated glass containers
/// - [TweenAnimationBuilder] for custom animation control
class AnimatedGlassContainer extends StatefulWidget {
  /// Creates an animated glass container.
  const AnimatedGlassContainer({
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
    this.duration,
    this.curve,
    this.onEnd,
    this.clipBehavior = Clip.antiAlias,
    this.enableBlur = true,
  });

  /// The child widget.
  final Widget? child;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The border radius.
  final BorderRadius? borderRadius;

  /// The solid border color.
  final Color? borderColor;

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

  /// The width.
  final double? width;

  /// The height.
  final double? height;

  /// Additional constraints.
  final BoxConstraints? constraints;

  /// The margin.
  final EdgeInsetsGeometry? margin;

  /// The padding.
  final EdgeInsetsGeometry? padding;

  /// The alignment.
  final AlignmentGeometry? alignment;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final Curve? curve;

  /// Callback when animation ends.
  final VoidCallback? onEnd;

  /// The clip behavior.
  final Clip clipBehavior;

  /// Whether to enable blur.
  final bool enableBlur;

  @override
  State<AnimatedGlassContainer> createState() => _AnimatedGlassContainerState();
}

class _AnimatedGlassContainerState extends State<AnimatedGlassContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _blurAnimation;
  Animation<double>? _opacityAnimation;
  Animation<double>? _borderWidthAnimation;
  Animation<Color?>? _frostColorAnimation;
  Animation<BorderRadius?>? _borderRadiusAnimation;

  double _previousBlur = 0;
  double _previousOpacity = 0;
  double _previousBorderWidth = 0;
  Color? _previousFrostColor;
  BorderRadius? _previousBorderRadius;
  bool _didInitAnimations = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? GlassConstants.defaultAnimationDuration,
    );
    _controller.addStatusListener(_handleAnimationStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitAnimations) {
      _initializeAnimations();
      _didInitAnimations = true;
    }
  }

  void _initializeAnimations() {
    final theme = GlassTheme.maybeOf(context);
    final curve = widget.curve ??
        theme?.animationCurve ??
        GlassConstants.defaultAnimationCurve;

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: curve,
    );

    final currentBlur = widget.blur ??
        theme?.blur ??
        GlassConstants.defaultBlur;
    final currentOpacity = widget.opacity ??
        theme?.opacity ??
        GlassConstants.defaultOpacity;
    final currentBorderWidth = widget.borderWidth ??
        theme?.borderWidth ??
        GlassConstants.defaultBorderWidth;
    final currentFrostColor = widget.frostColor ??
        theme?.frostColor ??
        GlassConstants.defaultFrostColor;
    final currentBorderRadius = widget.borderRadius ??
        theme?.borderRadius ??
        GlassConstants.defaultBorderRadius;

    _blurAnimation = Tween<double>(
      begin: _previousBlur,
      end: currentBlur,
    ).animate(curvedAnimation);

    _opacityAnimation = Tween<double>(
      begin: _previousOpacity,
      end: currentOpacity,
    ).animate(curvedAnimation);

    _borderWidthAnimation = Tween<double>(
      begin: _previousBorderWidth,
      end: currentBorderWidth,
    ).animate(curvedAnimation);

    _frostColorAnimation = ColorTween(
      begin: _previousFrostColor ?? currentFrostColor,
      end: currentFrostColor,
    ).animate(curvedAnimation);

    _borderRadiusAnimation = BorderRadiusTween(
      begin: _previousBorderRadius ?? currentBorderRadius,
      end: currentBorderRadius,
    ).animate(curvedAnimation);

    _previousBlur = currentBlur;
    _previousOpacity = currentOpacity;
    _previousBorderWidth = currentBorderWidth;
    _previousFrostColor = currentFrostColor;
    _previousBorderRadius = currentBorderRadius;
  }

  @override
  void didUpdateWidget(AnimatedGlassContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final theme = GlassTheme.maybeOf(context);

    final oldBlur = oldWidget.blur ?? theme?.blur ?? GlassConstants.defaultBlur;
    final newBlur = widget.blur ?? theme?.blur ?? GlassConstants.defaultBlur;

    final oldOpacity = oldWidget.opacity ?? theme?.opacity ?? GlassConstants.defaultOpacity;
    final newOpacity = widget.opacity ?? theme?.opacity ?? GlassConstants.defaultOpacity;

    final oldBorderWidth = oldWidget.borderWidth ?? theme?.borderWidth ?? GlassConstants.defaultBorderWidth;
    final newBorderWidth = widget.borderWidth ?? theme?.borderWidth ?? GlassConstants.defaultBorderWidth;

    final oldFrostColor = oldWidget.frostColor ?? theme?.frostColor ?? GlassConstants.defaultFrostColor;
    final newFrostColor = widget.frostColor ?? theme?.frostColor ?? GlassConstants.defaultFrostColor;

    final oldBorderRadius = oldWidget.borderRadius ?? theme?.borderRadius ?? GlassConstants.defaultBorderRadius;
    final newBorderRadius = widget.borderRadius ?? theme?.borderRadius ?? GlassConstants.defaultBorderRadius;

    final needsAnimation = oldBlur != newBlur ||
        oldOpacity != newOpacity ||
        oldBorderWidth != newBorderWidth ||
        oldFrostColor != newFrostColor ||
        oldBorderRadius != newBorderRadius;

    if (needsAnimation) {
      _previousBlur = _blurAnimation?.value ?? _previousBlur;
      _previousOpacity = _opacityAnimation?.value ?? _previousOpacity;
      _previousBorderWidth = _borderWidthAnimation?.value ?? _previousBorderWidth;
      _previousFrostColor = _frostColorAnimation?.value;
      _previousBorderRadius = _borderRadiusAnimation?.value;

      _controller.duration = widget.duration ?? GlassConstants.defaultAnimationDuration;
      _initializeAnimations();
      _controller.forward(from: 0);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onEnd?.call();
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final effectivePerformance =
        widget.performance ?? theme.performance ?? GlassPerformance.medium;

    // If borderColor is set, create a solid color gradient, otherwise use borderGradient
    final effectiveBorderGradient = widget.borderColor != null
        ? LinearGradient(colors: [widget.borderColor!, widget.borderColor!])
        : (widget.borderGradient ??
            theme.borderGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.5),
                Colors.white.withValues(alpha: 0.1),
              ],
            ));

    Widget content = widget.child ?? const SizedBox.shrink();

    if (widget.padding != null) {
      content = Padding(padding: widget.padding!, child: content);
    }

    if (widget.alignment != null) {
      content = Align(alignment: widget.alignment!, child: content);
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final blur = _blurAnimation?.value ?? (widget.blur ?? theme.blur ?? GlassConstants.defaultBlur);
          final opacity = _opacityAnimation?.value ?? (widget.opacity ?? theme.opacity ?? GlassConstants.defaultOpacity);
          final borderWidth = _borderWidthAnimation?.value ?? (widget.borderWidth ?? theme.borderWidth ?? GlassConstants.defaultBorderWidth);
          final frostColor = _frostColorAnimation?.value ?? GlassConstants.defaultFrostColor;
          final borderRadius = _borderRadiusAnimation?.value ?? GlassConstants.defaultBorderRadius;

          final adjustedBlur = blur * effectivePerformance.blurMultiplier;

          Widget result = ClipRRect(
            borderRadius: borderRadius,
            clipBehavior: widget.clipBehavior,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                if (widget.enableBlur && adjustedBlur > 0)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: BlurCache.instance.getBlurFilter(adjustedBlur, adjustedBlur),
                      child: const SizedBox.expand(),
                    ),
                  ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: frostColor.withValues(alpha: opacity.clamp(0.0, 1.0)),
                      gradient: widget.backgroundGradient ?? theme.backgroundGradient,
                    ),
                  ),
                ),
                child!,
              ],
            ),
          );

          if (borderWidth > 0) {
            result = CustomPaint(
              painter: GlassBorderPainter(
                borderRadius: borderRadius,
                borderWidth: borderWidth,
                gradient: effectiveBorderGradient,
              ),
              child: result,
            );
          }

          return Container(
            width: widget.width,
            height: widget.height,
            constraints: widget.constraints,
            margin: widget.margin,
            child: result,
          );
        },
        child: content,
      ),
    );
  }
}

/// A glass container that animates between two states.
///
/// This is useful for creating toggle effects between two glass configurations.
class GlassToggleContainer extends StatelessWidget {
  /// Creates a glass toggle container.
  const GlassToggleContainer({
    super.key,
    required this.isActive,
    required this.child,
    this.activeBlur,
    this.inactiveBlur,
    this.activeOpacity,
    this.inactiveOpacity,
    this.activeFrostColor,
    this.inactiveFrostColor,
    this.activeBorderRadius,
    this.inactiveBorderRadius,
    this.activeBorderGradient,
    this.inactiveBorderGradient,
    this.borderWidth,
    this.performance,
    this.duration,
    this.curve,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  /// Whether the container is in active state.
  final bool isActive;

  /// The child widget.
  final Widget child;

  /// The blur when active.
  final double? activeBlur;

  /// The blur when inactive.
  final double? inactiveBlur;

  /// The opacity when active.
  final double? activeOpacity;

  /// The opacity when inactive.
  final double? inactiveOpacity;

  /// The frost color when active.
  final Color? activeFrostColor;

  /// The frost color when inactive.
  final Color? inactiveFrostColor;

  /// The border radius when active.
  final BorderRadius? activeBorderRadius;

  /// The border radius when inactive.
  final BorderRadius? inactiveBorderRadius;

  /// The border gradient when active.
  final Gradient? activeBorderGradient;

  /// The border gradient when inactive.
  final Gradient? inactiveBorderGradient;

  /// The border width.
  final double? borderWidth;

  /// The performance mode.
  final GlassPerformance? performance;

  /// The animation duration.
  final Duration? duration;

  /// The animation curve.
  final Curve? curve;

  /// The width.
  final double? width;

  /// The height.
  final double? height;

  /// The padding.
  final EdgeInsetsGeometry? padding;

  /// The margin.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return AnimatedGlassContainer(
      blur: isActive ? activeBlur : inactiveBlur,
      opacity: isActive ? activeOpacity : inactiveOpacity,
      frostColor: isActive ? activeFrostColor : inactiveFrostColor,
      borderRadius: isActive ? activeBorderRadius : inactiveBorderRadius,
      borderGradient: isActive ? activeBorderGradient : inactiveBorderGradient,
      borderWidth: borderWidth,
      performance: performance,
      duration: duration,
      curve: curve,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}
