import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_theme.dart';
import 'utils/glass_performance.dart';
import 'utils/glass_constants.dart';
import 'utils/blur_cache.dart';

/// An app bar with glassmorphism styling.
///
/// This app bar provides a frosted glass effect and can be used as a
/// replacement for the standard [AppBar].
///
/// Example:
/// ```dart
/// Scaffold(
///   extendBodyBehindAppBar: true,
///   appBar: GlassAppBar(
///     title: Text('Glass App Bar'),
///   ),
///   body: ...,
/// )
/// ```
///
/// Note: For the glass effect to show content behind the app bar,
/// use `extendBodyBehindAppBar: true` in your [Scaffold].
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a glass app bar.
  const GlassAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.blur,
    this.opacity,
    this.borderGradient,
    this.borderWidth,
    this.frostColor,
    this.performance,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior = Clip.none,
    this.elevation = 0,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
  });

  /// The leading widget (typically an [IconButton] or [BackButton]).
  final Widget? leading;

  /// Whether to automatically imply the leading widget.
  final bool automaticallyImplyLeading;

  /// The title widget.
  final Widget? title;

  /// The action widgets to display.
  final List<Widget>? actions;

  /// The flexible space widget.
  final Widget? flexibleSpace;

  /// The bottom widget (typically a [TabBar]).
  final PreferredSizeWidget? bottom;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The border gradient.
  final Gradient? borderGradient;

  /// The border width.
  final double? borderWidth;

  /// The frost color.
  final Color? frostColor;

  /// The performance mode.
  final GlassPerformance? performance;

  /// Whether to center the title.
  final bool? centerTitle;

  /// Whether to exclude header semantics.
  final bool excludeHeaderSemantics;

  /// The spacing around the title.
  final double? titleSpacing;

  /// The height of the toolbar.
  final double? toolbarHeight;

  /// The width of the leading widget.
  final double? leadingWidth;

  /// The text style for toolbar text.
  final TextStyle? toolbarTextStyle;

  /// The text style for the title.
  final TextStyle? titleTextStyle;

  /// The system overlay style.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether to force material transparency.
  final bool forceMaterialTransparency;

  /// The clip behavior.
  final Clip clipBehavior;

  /// The elevation of the app bar.
  final double elevation;

  /// The shadow color.
  final Color? shadowColor;

  /// The surface tint color.
  final Color? surfaceTintColor;

  /// The shape of the app bar.
  final ShapeBorder? shape;

  /// The icon theme for leading and trailing icons.
  final IconThemeData? iconTheme;

  /// The icon theme for action icons.
  final IconThemeData? actionsIconTheme;

  /// Whether this app bar is a primary app bar.
  final bool primary;

  @override
  Size get preferredSize => Size.fromHeight(
        (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    final effectiveBlur = blur ?? theme.blur ?? GlassConstants.defaultBlur;
    final effectiveOpacity =
        opacity ?? theme.opacity ?? GlassConstants.defaultOpacity;
    final effectiveFrostColor =
        frostColor ?? theme.frostColor ?? GlassConstants.defaultFrostColor;
    final effectivePerformance =
        performance ?? theme.performance ?? GlassPerformance.medium;
    final effectiveBorderWidth =
        borderWidth ?? theme.borderWidth ?? 0;

    final adjustedBlur = effectiveBlur * effectivePerformance.blurMultiplier;

    final effectiveIconTheme = iconTheme ??
        IconThemeData(
          color: effectiveFrostColor == Colors.white
              ? Colors.white
              : Colors.white.withValues(alpha: 0.9),
        );

    final effectiveTitleTextStyle = titleTextStyle ??
        TextStyle(
          color: effectiveFrostColor == Colors.white
              ? Colors.white
              : Colors.white.withValues(alpha: 0.9),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );

    return ClipRect(
      child: BackdropFilter(
        filter: BlurCache.instance.getBlurFilter(adjustedBlur, adjustedBlur),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveFrostColor.withValues(alpha: effectiveOpacity),
            border: effectiveBorderWidth > 0
                ? Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: effectiveBorderWidth,
                    ),
                  )
                : null,
          ),
          child: SafeArea(
            bottom: false,
            child: AppBar(
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              title: title,
              actions: actions,
              flexibleSpace: flexibleSpace,
              bottom: bottom,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: effectiveFrostColor == Colors.white
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.9),
              centerTitle: centerTitle,
              excludeHeaderSemantics: excludeHeaderSemantics,
              titleSpacing: titleSpacing,
              toolbarHeight: toolbarHeight,
              leadingWidth: leadingWidth,
              toolbarTextStyle: toolbarTextStyle,
              titleTextStyle: effectiveTitleTextStyle,
              systemOverlayStyle: systemOverlayStyle,
              forceMaterialTransparency: true,
              clipBehavior: clipBehavior,
              shadowColor: shadowColor,
              surfaceTintColor: Colors.transparent,
              shape: shape,
              iconTheme: effectiveIconTheme,
              actionsIconTheme: actionsIconTheme ?? effectiveIconTheme,
              primary: false,
            ),
          ),
        ),
      ),
    );
  }
}

/// A sliver app bar with glassmorphism styling.
///
/// This is the sliver variant of [GlassAppBar] for use with [CustomScrollView].
class GlassSliverAppBar extends StatelessWidget {
  /// Creates a glass sliver app bar.
  const GlassSliverAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.blur,
    this.opacity,
    this.borderGradient,
    this.borderWidth,
    this.frostColor,
    this.performance,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.expandedHeight,
    this.collapsedHeight,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.forceElevated = false,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.titleTextStyle,
    this.toolbarTextStyle,
    this.primary = true,
  });

  /// The leading widget.
  final Widget? leading;

  /// Whether to automatically imply the leading widget.
  final bool automaticallyImplyLeading;

  /// The title widget.
  final Widget? title;

  /// The action widgets.
  final List<Widget>? actions;

  /// The flexible space widget.
  final Widget? flexibleSpace;

  /// The bottom widget.
  final PreferredSizeWidget? bottom;

  /// The blur sigma value.
  final double? blur;

  /// The background opacity.
  final double? opacity;

  /// The border gradient.
  final Gradient? borderGradient;

  /// The border width.
  final double? borderWidth;

  /// The frost color.
  final Color? frostColor;

  /// The performance mode.
  final GlassPerformance? performance;

  /// Whether to center the title.
  final bool? centerTitle;

  /// Whether to exclude header semantics.
  final bool excludeHeaderSemantics;

  /// The spacing around the title.
  final double? titleSpacing;

  /// The expanded height.
  final double? expandedHeight;

  /// The collapsed height.
  final double? collapsedHeight;

  /// The toolbar height.
  final double toolbarHeight;

  /// The leading width.
  final double? leadingWidth;

  /// Whether to force elevation.
  final bool forceElevated;

  /// Whether the app bar floats.
  final bool floating;

  /// Whether the app bar is pinned.
  final bool pinned;

  /// Whether the app bar snaps.
  final bool snap;

  /// Whether the app bar stretches.
  final bool stretch;

  /// The offset at which stretch triggers.
  final double stretchTriggerOffset;

  /// Callback when stretch is triggered.
  final Future<void> Function()? onStretchTrigger;

  /// The shape of the app bar.
  final ShapeBorder? shape;

  /// The title text style.
  final TextStyle? titleTextStyle;

  /// The toolbar text style.
  final TextStyle? toolbarTextStyle;

  /// Whether this is a primary app bar.
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    final effectiveBlur = blur ?? theme.blur ?? GlassConstants.defaultBlur;
    final effectiveOpacity =
        opacity ?? theme.opacity ?? GlassConstants.defaultOpacity;
    final effectiveFrostColor =
        frostColor ?? theme.frostColor ?? GlassConstants.defaultFrostColor;
    final effectivePerformance =
        performance ?? theme.performance ?? GlassPerformance.medium;

    final adjustedBlur = effectiveBlur * effectivePerformance.blurMultiplier;

    final effectiveIconTheme = IconThemeData(
      color: effectiveFrostColor == Colors.white
          ? Colors.white
          : Colors.white.withValues(alpha: 0.9),
    );

    final effectiveTitleTextStyle = titleTextStyle ??
        TextStyle(
          color: effectiveFrostColor == Colors.white
              ? Colors.white
              : Colors.white.withValues(alpha: 0.9),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );

    return SliverAppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: BlurCache.instance.getBlurFilter(adjustedBlur, adjustedBlur),
          child: Container(
            color: effectiveFrostColor.withValues(alpha: effectiveOpacity),
            child: flexibleSpace,
          ),
        ),
      ),
      bottom: bottom,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: effectiveFrostColor == Colors.white
          ? Colors.white
          : Colors.white.withValues(alpha: 0.9),
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      forceElevated: forceElevated,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      stretchTriggerOffset: stretchTriggerOffset,
      onStretchTrigger: onStretchTrigger,
      shape: shape,
      titleTextStyle: effectiveTitleTextStyle,
      toolbarTextStyle: toolbarTextStyle,
      iconTheme: effectiveIconTheme,
      actionsIconTheme: effectiveIconTheme,
      primary: primary,
      surfaceTintColor: Colors.transparent,
      forceMaterialTransparency: true,
    );
  }
}
