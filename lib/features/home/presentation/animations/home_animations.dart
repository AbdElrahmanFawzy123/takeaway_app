import 'package:flutter/material.dart';

class HomeAnimations {
  final TickerProvider vsync;

  late AnimationController controller;
  late Animation<double> floatAnim;
  late Animation<double> scaleAnim;

  HomeAnimations(this.vsync);

  void init() {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    floatAnim = Tween(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutSine),
    );

    scaleAnim = Tween(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  void dispose() {
    controller.dispose();
  }
}
