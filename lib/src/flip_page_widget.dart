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
