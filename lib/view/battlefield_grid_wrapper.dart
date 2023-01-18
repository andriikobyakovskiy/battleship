import 'package:flutter/material.dart';
import 'package:battleship/model/battlefield.dart';

class BattleFieldGridWrapper extends StatelessWidget {
  final BattleField battleField;
  final Widget battleFieldWidget;
  final double side;

  const BattleFieldGridWrapper({
    super.key,
    required this.battleField,
    required this.battleFieldWidget,
    required this.side,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: side * 1.1,
      height: side * 1.1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: battleFieldWidget,
          ),

          // vertical axis
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: side * 0.1,
              height: side,
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
              width: side,
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