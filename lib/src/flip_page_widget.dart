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
