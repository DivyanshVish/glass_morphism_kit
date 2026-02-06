import 'dart:ui';

/// A cache for [ImageFilter] instances to avoid recreating them.
///
/// This improves performance by reusing blur filters with the same sigma values.
class BlurCache {
  BlurCache._();

  static final BlurCache _instance = BlurCache._();

  /// The singleton instance of [BlurCache].
  static BlurCache get instance => _instance;

  final Map<_BlurKey, ImageFilter> _cache = {};

  /// Maximum number of cached filters.
  static const int _maxCacheSize = 50;

  /// Gets or creates a blur filter with the specified sigma values.
  ///
  /// Returns a cached filter if one exists, otherwise creates and caches a new one.
  ImageFilter getBlurFilter(double sigmaX, double sigmaY) {
    final key = _BlurKey(sigmaX, sigmaY);

    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    final filter = ImageFilter.blur(
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      tileMode: TileMode.clamp,
    );

    _cache[key] = filter;
    return filter;
  }

  /// Clears all cached filters.
  void clear() {
    _cache.clear();
  }
}

class _BlurKey {
  final double sigmaX;
  final double sigmaY;

  const _BlurKey(this.sigmaX, this.sigmaY);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _BlurKey &&
        other.sigmaX == sigmaX &&
        other.sigmaY == sigmaY;
  }

  @override
  int get hashCode => Object.hash(sigmaX, sigmaY);
}
