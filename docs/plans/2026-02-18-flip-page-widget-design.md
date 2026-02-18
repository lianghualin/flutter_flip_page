# FlipPage Widget Design

## Summary

A reusable Flutter widget that displays two child widgets (front/back) with a 3D horizontal flip animation triggered by a floating button.

## Requirements

- Horizontal flip animation (Y-axis rotation) between two pages
- Floating "FLIP" button at top-right corner, stays above content during animation
- Widget expands to fill parent container
- No external dependencies
- Packaged as a reusable component other projects can import

## API

```dart
FlipPage(
  front: Widget,         // Front face content
  back: Widget,          // Back face content
  duration: Duration,    // Animation duration (default: 500ms)
)
```

## Architecture

### Project structure

```
flutter_flip_page/
  lib/
    flip_page.dart       # Public API — the FlipPage widget
  example/
    lib/
      main.dart          # Demo app with Page A / Page B
  pubspec.yaml           # Package pubspec
```

### Animation approach

Use `Transform` with `Matrix4.rotationY()` and perspective for true 3D flip:

- `AnimationController` drives value from 0.0 to 1.0 (maps to 0 to pi radians)
- First half (0.0 to 0.5): front face visible, rotating 0 to 90 degrees
- Second half (0.5 to 1.0): back face visible, rotating 90 to 180 degrees
- Back face is mirrored so text reads correctly
- Clicking again reverses the animation (1.0 back to 0.0)

### Widget tree

```
SizedBox.expand
  Stack
    AnimatedBuilder (the flipping content)
      Transform (Matrix4 with perspective + rotationY)
        front or back widget (swapped at 90 degree midpoint)
    Positioned (top-right)
      FloatingActionButton / TextButton ("FLIP")
```

### Button behavior

- Shows "FLIP >" when front is displayed
- Shows "< FLIP" when back is displayed
- Button stays pinned at top-right during animation
