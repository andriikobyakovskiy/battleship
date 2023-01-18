import 'package:battleship/model/ship.dart';
import 'package:battleship/model/zone.dart';
import 'package:flutter/material.dart';

class ShipView extends StatelessWidget {
  final Ship ship;
  final Zone battleZone;
  final double cellSide;

  const ShipView({
    super.key,
    required this.ship,
    required this.battleZone,
    required this.cellSide,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (ship.hitZone.lengthOffset - battleZone.lengthOffset) * cellSide,
      left: (ship.hitZone.widthOffset - battleZone.widthOffset) * cellSide,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: cellSide * ship.hitZone.length,
          maxWidth: cellSide - ship.hitZone.width,
        ),
        color: Colors.black,
      ),
    );
  }
}