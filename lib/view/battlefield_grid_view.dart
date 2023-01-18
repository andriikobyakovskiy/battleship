import 'package:battleship/view/battlefield_view.dart';
import 'package:flutter/material.dart';
import 'package:battleship/model/battlefield.dart';

class BattleFieldGridView extends StatelessWidget {
  final BattleField battleField;
  final bool showShips;
  final double side;

  const BattleFieldGridView({
    super.key,
    required this.battleField,
    required this.showShips,
    this.side = 500,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: BattleFieldView(
              battleField: battleField,
              showShips: showShips,
              side: side * 0.9,
            ),
          ),

          // vertical axis
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: side * 0.1,
              height: side * 0.9,
              child: Stack(
                fit: StackFit.expand,
                children: List.generate(
                  battleField.zone.length,
                  (i) => Align(
                    alignment: Alignment(
                      0,
                      (2 * i + 1) / battleField.zone.length - 1
                    ),
                    child: Text(
                      battleField.zone.lengthOffset < 'A'.runes.first
                        ? (battleField.zone.lengthOffset + i).toString()
                        : String.fromCharCode(battleField.zone.lengthOffset + i)
                    )
                  )
                ),
              ),
            ),
          ),

          // horizontal axis
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: side * 0.1,
              width: side * 0.9,
              child: Stack(
                fit: StackFit.expand,
                children: List.generate(
                  battleField.zone.width,
                    (i) => Align(
                    alignment: Alignment(
                      (2 * i + 1) / battleField.zone.width - 1,
                      0
                    ),
                    child: Text(
                      battleField.zone.widthOffset < 'A'.runes.first
                        ? (battleField.zone.widthOffset + i).toString()
                        : String.fromCharCode(battleField.zone.widthOffset + i)
                    )
                  )
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}