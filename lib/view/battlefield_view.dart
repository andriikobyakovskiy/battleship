import 'package:battleship/model/battlefield.dart';
import 'package:battleship/view/ship_view.dart';
import 'package:flutter/material.dart';

class BattleFieldView extends StatelessWidget {
  final BattleField battleField;
  final bool showShips;
  final double side;
  final double padding;

  const BattleFieldView({
    super.key,
    required this.battleField,
    required this.showShips,
    this.side = 500,
    double? padding,
  }): padding = padding ?? side * 0.01;

  @override
  Widget build(BuildContext context) {
    final hitMap = battleField.hitMap;
    final cellSide = side / battleField.zone.width;
    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        fit: StackFit.expand,
        children: (
          showShips
            ? battleField.ships.map<Widget>((s) => ShipView(
                ship: s,
                battleZone: battleField.zone,
                cellSide: cellSide
              )).toList()
            : <Widget>[]
        ) + List.generate(
          battleField.zone.length * battleField.zone.width,
          (i) {
            final cellHit = hitMap[i % battleField.zone.length][i ~/ battleField.zone.length];
            return Align(
              alignment: Alignment(
                2 * (i ~/ battleField.zone.length) / (battleField.zone.length - 1) - 1,
                2 * (i % battleField.zone.length) / (battleField.zone.width - 1) - 1
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: cellSide - padding,
                  maxWidth: cellSide - padding
                ),
                color: cellHit == null
                  ? (showShips ? Colors.black12 : Colors.grey)
                  : (cellHit ? Colors.redAccent : Colors.lightBlueAccent),
              )
            );
          }),
      ),
    );
  }
}