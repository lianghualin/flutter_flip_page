# flutter_flip_page

A Flutter widget that flips between two child widgets with a 3D Y-axis rotation animation. Tap the built-in FLIP button to smoothly transition between a front and back page.

## Features

- 3D perspective flip animation around the Y-axis
- Customizable front and back widgets
- Configurable animation duration
- Built-in floating FLIP button with directional arrows
- Smooth easeInOut curve

## Getting started

Add `flutter_flip_page` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_flip_page: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

```dart
import 'package:flutter_flip_page/flutter_flip_page.dart';

FlipPage(
  front: Container(
    color: Colors.blue.shade100,
    child: const Center(child: Text('Front Page')),
  ),
  back: Container(
    color: Colors.green.shade100,
    child: const Center(child: Text('Back Page')),
  ),
  duration: const Duration(milliseconds: 500), // optional
)
```

The `FlipPage` widget expands to fill its parent. Place it inside a `Scaffold` body or any sized container.

See the [example app](example/lib/main.dart) for a complete working demo.

## License

MIT License. See [LICENSE](LICENSE) for details.
