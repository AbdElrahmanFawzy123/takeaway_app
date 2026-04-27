import 'package:flutter/material.dart';
import '../animations/home_animations.dart';

class HeroLogo extends AnimatedWidget {
  final HomeAnimations animation;

  HeroLogo({super.key, required this.animation})
      : super(listenable: animation.controller);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.floatAnim.value),
      child: Transform.scale(
        scale: animation.scaleAnim.value,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _circle(130, 25, 5),
            _circle(110, 0, 0),
            _mainIcon(),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, double blur, double spread) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B00).withValues(alpha: 0.25),
            blurRadius: blur,
            spreadRadius: spread,
          ),
        ],
      ),
    );
  }

  Widget _mainIcon() {
    return Container(
      width: 95,
      height: 95,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
        ),
      ),
      child: const Icon(Icons.restaurant, color: Colors.white, size: 45),
    );
  }
}
