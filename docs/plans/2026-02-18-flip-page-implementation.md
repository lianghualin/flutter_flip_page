# FlipPage Widget Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a reusable Flutter flip page widget with 3D horizontal flip animation, packaged so other projects can import it.

**Architecture:** A Flutter package (`flutter_flip_page`) with the `FlipPage` widget in `lib/flip_page.dart`. Uses `Transform` + `Matrix4.rotationY()` with perspective for true 3D flip. An `example/` app demonstrates usage.

**Tech Stack:** Flutter 3.41, Dart 3.11, no external dependencies.

---

### Task 1: Create Flutter package project

**Files:**
- Create: `pubspec.yaml`
- Create: `lib/flip_page.dart` (empty placeholder)
- Create: `analysis_options.yaml`

**Step 1: Create the Flutter package**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page
flutter create --template=package --project-name=flutter_flip_page .
```

Expected: Package scaffolding created with `lib/flutter_flip_page.dart`, `pubspec.yaml`, etc.

**Step 2: Clean up generated files**

- Remove the generated `lib/flutter_flip_page.dart` (we'll use `lib/flip_page.dart` instead)
- Remove the generated `test/flutter_flip_page_test.dart`

**Step 3: Create the library entry point**

Create `lib/flip_page.dart`:
```dart
library flip_page;

export 'src/flip_page_widget.dart';
```

Create `lib/src/flip_page_widget.dart` with a placeholder:
```dart
import 'package:flutter/material.dart';

class FlipPage extends StatefulWidget {
  const FlipPage({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget front;
  final Widget back;
  final Duration duration;

  @override
  State<FlipPage> createState() => _FlipPageState();
}

class _FlipPageState extends State<FlipPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

**Step 4: Verify package compiles**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page && flutter analyze
```

Expected: No issues found.

**Step 5: Initialize git and commit**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page
git init
git add pubspec.yaml lib/ analysis_options.yaml .gitignore CHANGELOG.md LICENSE README.md
git commit -m "chore: scaffold flutter_flip_page package"
```

---

### Task 2: Implement the FlipPage widget with 3D animation

**Files:**
- Modify: `lib/src/flip_page_widget.dart`

**Step 1: Add AnimationController mixin and fields**

Update `_FlipPageState` to mix in `SingleTickerProviderStateMixin` and create the controller:

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

class FlipPage extends StatefulWidget {
  const FlipPage({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget front;
  final Widget back;
  final Duration duration;

  @override
  State<FlipPage> createState() => _FlipPageState();
}

class _FlipPageState extends State<FlipPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showingFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.addListener(() {
      setState(() {
        _showingFront = _controller.value < 0.5;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Flipping content
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final angle = _animation.value * math.pi;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(angle),
                child: _showingFront
                    ? widget.front
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: widget.back,
                      ),
              );
            },
          ),
          // Floating FLIP button
          Positioned(
            top: 16,
            right: 16,
            child: FilledButton.icon(
              onPressed: _flip,
              icon: _showingFront
                  ? const SizedBox.shrink()
                  : const Icon(Icons.arrow_back, size: 16),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('FLIP'),
                  if (_showingFront)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.arrow_forward, size: 16),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Verify it compiles**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page && flutter analyze
```

Expected: No issues found.

**Step 3: Commit**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page
git add lib/
git commit -m "feat: implement FlipPage widget with 3D Y-axis rotation"
```

---

### Task 3: Create the example app

**Files:**
- Create: `example/lib/main.dart`
- Create: `example/pubspec.yaml`

**Step 1: Create the example directory and pubspec**

Run:
```bash
mkdir -p /Users/hualinliang/Project/flutter_flip_page/example/lib
```

Create `example/pubspec.yaml`:
```yaml
name: flutter_flip_page_example
description: Example app demonstrating the FlipPage widget.
publish_to: 'none'

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  flutter_flip_page:
    path: ../

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
```

**Step 2: Create the example main.dart**

Create `example/lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_flip_page/flip_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlipPage Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const FlipPageDemo(),
    );
  }
}

class FlipPageDemo extends StatelessWidget {
  const FlipPageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlipPage(
        front: Container(
          color: Colors.blue.shade100,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PAGE A',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Hello, I\'m A!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        back: Container(
          color: Colors.green.shade100,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PAGE B',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Hey, I\'m B!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 3: Get dependencies and verify**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page/example && flutter pub get && flutter analyze
```

Expected: No issues found.

**Step 4: Commit**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page
git add example/
git commit -m "feat: add example app demonstrating FlipPage widget"
```

---

### Task 4: Test the example on a device/simulator

**Step 1: Run the example app**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page/example && flutter run
```

**Step 2: Verify behavior**

- App launches showing Page A (blue) with "Hello, I'm A!"
- FLIP button visible at top-right with arrow pointing right
- Clicking FLIP: page flips horizontally with 3D perspective
- After flip: Page B (green) with "Hey, I'm B!" is shown
- Button now shows arrow pointing left
- Clicking again: flips back to Page A

**Step 3: Fix any visual issues found during testing**

**Step 4: Final commit**

Run:
```bash
cd /Users/hualinliang/Project/flutter_flip_page
git add -A
git commit -m "fix: polish FlipPage animation and layout"
```
