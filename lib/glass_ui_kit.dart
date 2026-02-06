/// A complete Glassmorphism / Frosted UI system for Flutter.
///
/// This library provides a set of widgets and utilities for creating
/// beautiful frosted glass effects in your Flutter applications.
///
/// ## Core Components
///
/// - [GlassContainer] - The base container with glassmorphism effect
/// - [GlassCard] - A card widget with glass styling
/// - [GlassButton] - An interactive button with press animation
/// - [GlassBottomSheet] - A keyboard-aware bottom sheet
/// - [GlassAppBar] - An app bar with glass effect
///
/// ## Helpers
///
/// - [GlassTheme] - Theme configuration for glass widgets
/// - [GlassNoiseOverlay] - Noise/grain texture overlay
/// - [GlassBorderPainter] - Custom painter for gradient borders
/// - [AnimatedGlassContainer] - Implicit animation support
///
/// ## Performance Modes
///
/// Use [GlassPerformance] to control rendering quality:
/// - [GlassPerformance.low] - Reduced blur for better performance
/// - [GlassPerformance.medium] - Full blur with gradients
library glass_ui_kit;

export 'src/glass_container.dart';
export 'src/glass_card.dart';
export 'src/glass_button.dart';
export 'src/glass_bottom_sheet.dart';
export 'src/glass_app_bar.dart';
export 'src/glass_theme.dart';
export 'src/glass_noise.dart';
export 'src/glass_border_painter.dart';
export 'src/animated_glass.dart';
export 'src/utils/glass_performance.dart';
export 'src/utils/glass_constants.dart';
