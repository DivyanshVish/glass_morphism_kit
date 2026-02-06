import 'package:flutter/material.dart';

/// A custom painter that draws gradient borders for glass containers.
///
/// This painter creates a border with a gradient effect, commonly used
/// in glassmorphism designs to create a subtle edge highlight.
///
/// Example:
/// ```dart
/// CustomPaint(
///   painter: GlassBorderPainter(
///     borderRadius: BorderRadius.circular(16),
///     borderWidth: 1.5,
///     gradient: LinearGradient(
///       colors: [Colors.white54, Colors.white10],
///     ),
///   ),
///   child: Container(),
/// )
/// ```
class GlassBorderPainter extends CustomPainter {
  /// Creates a glass border painter.
  GlassBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  /// The border radius of the container.
  final BorderRadius borderRadius;

  /// The width of the border stroke.
  final double borderWidth;

  /// The gradient to use for the border.
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0 || size.isEmpty) return;

    final rect = Offset.zero & size;
    final innerRect = rect.deflate(borderWidth / 2);
    final innerRRect = borderRadius.toRRect(innerRect);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(innerRRect, paint);
  }

  @override
  bool shouldRepaint(GlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradient != gradient;
  }
}

/// A widget that wraps [GlassBorderPainter] for easier use.
///
/// This widget handles the custom paint setup and provides a cleaner API.
class GlassBorder extends StatelessWidget {
  /// Creates a glass border widget.
  const GlassBorder({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.borderWidth = 1.5,
    this.gradient,
  });

  /// The child widget to wrap with a border.
  final Widget child;

  /// The border radius.
  final BorderRadius borderRadius;

  /// The border width.
  final double borderWidth;

  /// The gradient for the border. If null, a default white gradient is used.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0.1),
          ],
        );

    return CustomPaint(
      painter: GlassBorderPainter(
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        gradient: effectiveGradient,
      ),
      child: child,
    );
  }
}

/// A decoration that paints a gradient border.
///
/// This can be used with [Container] or other widgets that accept a [Decoration].
class GlassBorderDecoration extends Decoration {
  /// Creates a glass border decoration.
  const GlassBorderDecoration({
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.borderWidth = 1.5,
    this.gradient,
  });

  /// The border radius.
  final BorderRadius borderRadius;

  /// The border width.
  final double borderWidth;

  /// The gradient for the border.
  final Gradient? gradient;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GlassBorderBoxPainter(
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      gradient: gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.5),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
    );
  }

  @override
  EdgeInsetsGeometry get padding => EdgeInsets.all(borderWidth);
}

class _GlassBorderBoxPainter extends BoxPainter {
  _GlassBorderBoxPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  final BorderRadius borderRadius;
  final double borderWidth;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size ?? Size.zero;
    if (borderWidth <= 0 || size.isEmpty) return;

    final rect = offset & size;
    final innerRect = rect.deflate(borderWidth / 2);
    final innerRRect = borderRadius.toRRect(innerRect);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(innerRRect, paint);
  }
}
