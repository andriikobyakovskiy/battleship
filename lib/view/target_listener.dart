import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/zone.dart';
import 'package:flutter/material.dart';

class TargetListener extends StatelessWidget {
  final Zone zone;
  final double side;
  final Widget child;
  final void Function(Coordinates) onTarget;

  const TargetListener({
    super.key,
    required this.zone,
    required this.child,
    required this.side,
    required this.onTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (event) {
        final relativePosition = event.localPosition / side;
        final target = Coordinates(
          zone.lengthOffset
            + (zone.length * relativePosition.dy).floor(),
          zone.widthOffset
            + (zone.width * relativePosition.dx).floor(),
        );
        onTarget(target);
      },
      child: child,
    );
  }
}