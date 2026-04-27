import 'package:flutter/material.dart';

class HomeRoutes {
  static PageRoute fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(
          opacity: fade,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRoute slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.easeOutCubic),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRoute scale(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: scale,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
