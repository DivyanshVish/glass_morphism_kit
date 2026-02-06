import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that renders a noise/grain texture overlay.
///
/// This creates a subtle grainy texture commonly seen in glassmorphism designs.
/// The noise is generated procedurally and cached for performance.
///
/// Example:
/// ```dart
/// GlassNoiseOverlay(
///   opacity: 0.05,
///   child: Container(),
/// )
/// ```
class GlassNoiseOverlay extends StatelessWidget {
  /// Creates a noise overlay.
  const GlassNoiseOverlay({
    super.key,
    required this.child,
    this.opacity = 0.05,
    this.seed = 42,
  });

  /// The child widget to overlay noise on.
  final Widget child;

  /// The opacity of the noise overlay (0.0 to 1.0).
  final double opacity;

  /// The seed for noise generation.
  final int seed;

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) {
      return child;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _NoisePainter(
                  opacity: opacity.clamp(0.0, 1.0),
                  seed: seed,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  _NoisePainter({
    required this.opacity,
    required this.seed,
  });

  final double opacity;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0 || size.isEmpty) return;

    final random = math.Random(seed);
    final paint = Paint();

    const step = 4.0;
    final maxOpacity = (opacity * 255).round().clamp(0, 255);

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        final brightness = random.nextInt(256);
        final alpha = random.nextInt(maxOpacity + 1);

        paint.color = Color.fromARGB(
          alpha,
          brightness,
          brightness,
          brightness,
        );

        canvas.drawRect(
          Rect.fromLTWH(x, y, step, step),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_NoisePainter oldDelegate) {
    return oldDelegate.opacity != opacity || oldDelegate.seed != seed;
  }
}

/// A static noise texture that can be used as a decoration.
///
/// This is useful when you want to apply noise to a decoration rather than
/// as an overlay widget.
class GlassNoiseDecoration extends Decoration {
  /// Creates a noise decoration.
  const GlassNoiseDecoration({
    this.opacity = 0.05,
    this.seed = 42,
  });

  /// The opacity of the noise (0.0 to 1.0).
  final double opacity;

  /// The seed for noise generation.
  final int seed;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _NoiseBoxPainter(
      opacity: opacity,
      seed: seed,
    );
  }
}

class _NoiseBoxPainter extends BoxPainter {
  _NoiseBoxPainter({
    required this.opacity,
    required this.seed,
  });

  final double opacity;
  final int seed;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size ?? Size.zero;
    if (opacity <= 0 || size.isEmpty) return;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final random = math.Random(seed);
    final paint = Paint();

    const step = 4.0;
    final maxOpacity = (opacity * 255).round().clamp(0, 255);

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        final brightness = random.nextInt(256);
        final alpha = random.nextInt(maxOpacity + 1);

        paint.color = Color.fromARGB(
          alpha,
          brightness,
          brightness,
          brightness,
        );

        canvas.drawRect(
          Rect.fromLTWH(x, y, step, step),
          paint,
        );
      }
    }

    canvas.restore();
  }
}
