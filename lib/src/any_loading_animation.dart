import 'package:flutter/material.dart';

/// AnyLoadingAnimationType
enum AnyLoadingAnimationType {
  opacity,
  scale,
}

class AnyLoadingAnimation extends StatelessWidget {
  /// [AnyLoadingAnimationType]
  final AnyLoadingAnimationType animationType;
  final Widget child;
  final AnimationController controller;
  final AlignmentGeometry? alignment;

  const AnyLoadingAnimation(
      {super.key,
      required this.controller,
      required this.child,
      required this.animationType,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (animationType) {
      case AnyLoadingAnimationType.opacity:
        widget = Opacity(
          opacity: controller.value,
          child: child,
        );
        break;
      case AnyLoadingAnimationType.scale:
        widget = Opacity(
          opacity: controller.value,
          child: ScaleTransition(
            scale: controller,
            child: child,
          ),
        );
        break;
    }
    return widget;
  }
}
