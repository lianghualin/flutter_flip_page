# flutter_flip_page

A Flutter widget that flips between two child widgets with a 3D Y-axis rotation animation. Includes a built-in FLIP button, or use `FlipPageController` to trigger flips from your own UI.

## Features

- 3D perspective flip animation around the Y-axis
- Customizable front and back widgets
- Configurable animation duration
- Built-in floating FLIP button with directional arrows (can be hidden)
- `FlipPageController` for external flip control
- Smooth easeInOut curve

## Getting started

Add `flutter_flip_page` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_flip_page: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic (built-in button)

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

### External control

Use `FlipPageController` to trigger flips from outside the widget and hide the built-in button:

```dart
final flipController = FlipPageController();

// In your toolbar, FAB, or anywhere else:
IconButton(
  onPressed: flipController.flip,
  icon: const Icon(Icons.flip),
),

// The FlipPage widget:
FlipPage(
  controller: flipController,
  showButton: false, // hide built-in button
  front: MyFrontWidget(),
  back: MyBackWidget(),
)
```

The controller exposes `showingFront` and extends `ChangeNotifier`, so you can listen for state changes:

```dart
flipController.addListener(() {
  print('Showing front: ${flipController.showingFront}');
});
```

The `FlipPage` widget expands to fill its parent. Place it inside a `Scaffold` body or any sized container.

See the [example app](example/lib/main.dart) for a complete working demo.

## License

MIT License. See [LICENSE](LICENSE) for details.
