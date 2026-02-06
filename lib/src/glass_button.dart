import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_container.dart';
import 'glass_theme.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';

/// A button widget with glassmorphism styling and press animation.
///
/// This button provides visual feedback through scale animation when pressed
/// and supports various customization options.
///
/// Example:
/// ```dart
/// GlassButton(
///   onPressed: () => print('Pressed!'),
///   child: Text('Click Me'),
/// )
/// ```
///
/// See also:
/// - [GlassContainer] for static glass containers
/// - [GlassIconButton] for icon-only buttons
class GlassButton extends StatefulWidget {
  /// Creates a glass button.
  const GlassButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
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
    this.padding,
    this.pressScale,
    this.pressOpacity,
    this.animationDuration,
    this.animationCurve,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
  });

  /// The child widget to display inside the button.
  final Widget child;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The border radius.
  final BorderRadius? borderRadius;

  /// The solid color for the border.
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

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// Additional constraints for the button.
  final BoxConstraints? constraints;

  /// The padding inside the button.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 24, vertical: 12)`.
  final EdgeInsetsGeometry? padding;

  /// The scale factor when pressed (0.0 to 1.0).
  ///
  /// Defaults to [GlassConstants.defaultButtonPressScale].
  final double? pressScale;

  /// The opacity when pressed (0.0 to 1.0).
  final double? pressOpacity;

  /// The duration of the press animation.
  final Duration? animationDuration;

  /// The curve of the press animation.
  final Curve? animationCurve;

  /// Whether the button is enabled.
  final bool enabled;

  /// Whether to provide haptic feedback on press.
  final bool enableHapticFeedback;

  /// The focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether to autofocus this button.
  final bool autofocus;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _opacityAnimation;
  bool _didInitAnimations = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? GlassConstants.defaultAnimationDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitAnimations) {
      _updateAnimations();
      _didInitAnimations = true;
    }
  }

  @override
  void didUpdateWidget(GlassButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration =
          widget.animationDuration ?? GlassConstants.defaultAnimationDuration;
    }
    if (oldWidget.pressScale != widget.pressScale ||
        oldWidget.pressOpacity != widget.pressOpacity ||
        oldWidget.animationCurve != widget.animationCurve) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    final theme = GlassTheme.maybeOf(context);
    final curve = widget.animationCurve ??
        theme?.animationCurve ??
        GlassConstants.defaultAnimationCurve;

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale ?? GlassConstants.defaultButtonPressScale,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressOpacity ?? 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  void _handleLongPress() {
    if (!widget.enabled) return;
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    Widget button = GlassContainer(
      blur: widget.blur,
      opacity: widget.opacity,
      borderRadius: widget.borderRadius,
      borderColor: widget.borderColor,
      borderGradient: widget.borderGradient,
      backgroundGradient: widget.backgroundGradient,
      borderWidth: widget.borderWidth,
      noise: widget.noise,
      frostColor: widget.frostColor,
      performance: widget.performance,
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      padding: effectivePadding,
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: TextStyle(
          color: widget.frostColor ?? theme.frostColor ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
        child: IconTheme(
          data: IconThemeData(
            color: widget.frostColor ?? theme.frostColor ?? Colors.white,
          ),
          child: widget.child,
        ),
      ),
    );

    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _handleTap,
          onLongPress: widget.onLongPress != null ? _handleLongPress : null,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = _scaleAnimation?.value ?? 1.0;
              final opacity = _opacityAnimation?.value ?? 1.0;
              return Opacity(
                opacity: widget.enabled ? opacity : 0.5,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: button,
          ),
        ),
      ),
    );
  }
}

/// An icon button with glassmorphism styling.
///
/// This is a convenience wrapper for creating circular glass buttons with icons.
class GlassIconButton extends StatelessWidget {
  /// Creates a glass icon button.
  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.size = 48,
    this.iconSize = 24,
    this.blur,
    this.opacity,
    this.borderColor,
    this.borderGradient,
    this.borderWidth,
    this.frostColor,
    this.iconColor,
    this.performance,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.tooltip,
  });

  /// The icon to display.
  final IconData icon;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// The size of the button.
  final double size;

  /// The size of the icon.
  final double iconSize;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The solid border color.
  final Color? borderColor;

  /// The border gradient.
  final Gradient? borderGradient;

  /// The border width.
  final double? borderWidth;

  /// The frost color.
  final Color? frostColor;

  /// The icon color.
  final Color? iconColor;

  /// The performance mode.
  final GlassPerformance? performance;

  /// Whether the button is enabled.
  final bool enabled;

  /// Whether to provide haptic feedback.
  final bool enableHapticFeedback;

  /// Tooltip to display on hover/long press.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    Widget button = GlassButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      blur: blur,
      opacity: opacity,
      borderRadius: BorderRadius.circular(size / 2),
      borderColor: borderColor,
      borderGradient: borderGradient,
      borderWidth: borderWidth,
      frostColor: frostColor,
      performance: performance,
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      enabled: enabled,
      enableHapticFeedback: enableHapticFeedback,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// A text button with glassmorphism styling.
///
/// This is a convenience wrapper for creating glass buttons with text.
class GlassTextButton extends StatelessWidget {
  /// Creates a glass text button.
  const GlassTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.style,
    this.blur,
    this.opacity,
    this.borderRadius,
    this.borderGradient,
    this.borderWidth,
    this.frostColor,
    this.performance,
    this.padding,
    this.enabled = true,
  });

  /// The text to display.
  final String text;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// The text style.
  final TextStyle? style;

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

  /// The padding inside the button.
  final EdgeInsetsGeometry? padding;

  /// Whether the button is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      borderGradient: borderGradient,
      borderWidth: borderWidth,
      frostColor: frostColor,
      performance: performance,
      padding: padding,
      enabled: enabled,
      child: Text(text, style: style),
    );
  }
}
