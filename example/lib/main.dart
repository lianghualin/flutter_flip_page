import 'package:flutter/material.dart';
import 'package:flutter_flip_page/flutter_flip_page.dart';

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

class FlipPageDemo extends StatefulWidget {
  const FlipPageDemo({super.key});

  @override
  State<FlipPageDemo> createState() => _FlipPageDemoState();
}

class _FlipPageDemoState extends State<FlipPageDemo> {
  final _flipController = FlipPageController();

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipPage Demo'),
        actions: [
          IconButton(
            onPressed: _flipController.flip,
            icon: const Icon(Icons.flip),
            tooltip: 'Flip',
          ),
        ],
      ),
      body: FlipPage(
        controller: _flipController,
        showButton: false,
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
