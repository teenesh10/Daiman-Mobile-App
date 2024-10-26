import 'package:daiman_mobile/views/widgets/curved_shape.dart';
import 'package:flutter/material.dart';

class CustomShapeWidget extends StatelessWidget {
  const CustomShapeWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedShape(),
      child: child,
    );
  }
}