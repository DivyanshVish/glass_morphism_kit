## 1.0.3

* Added `GlassToggleContainer` for easy active/inactive glass containers
* Improved performance of glass rendering
* Fixed minor documentation issues


## 1.0.2

* Added `borderColor` property to all glass widgets for solid color borders
* Updated `.gitignore` with comprehensive ignore patterns
* Performance optimizations and code cleanup

## 1.0.1

* Refined Apple Glass aesthetic with higher blur and lower opacity
* Removed Ultra performance mode (only Low and Medium available)
* Removed noise and glow effects for cleaner glass look
* Fixed `GlassButton` and `AnimatedGlassContainer` initialization issues
* Added dark and light theme factory constructors
* Improved documentation and README

## 1.0.0

* Initial release of glass_ui_kit
* Core widgets:
  - `GlassContainer` - Base glass container with blur effect
  - `GlassCard` - Card variant with padding and elevation
  - `GlassButton` - Interactive button with press animation
  - `GlassIconButton` - Circular icon button
  - `GlassTextButton` - Text button variant
  - `GlassBottomSheet` - Keyboard-aware modal bottom sheet
  - `GlassAppBar` - App bar with glass effect
  - `AnimatedGlassContainer` - Implicitly animated glass container
* Theming support via `GlassTheme` and `GlassThemeData`
* Performance modes: Low and Medium
* Customizable blur, opacity, borders, and colors
* No external dependencies
* Full null safety support
