import 'package:battleship/controller/battle_controller.dart';
import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/coordinates.dart';
import 'package:battleship/view/battlefield_view.dart';
import 'package:flutter/material.dart';

class BattleView extends StatefulWidget {
  final BattleController battleController;
  final double side;

  const BattleView({
    super.key,
    required this.battleController,
    required this.side,
  });

  @override
  State<BattleView> createState() => _BattleState();
}


class _BattleState extends State<BattleView> {

  @override
  Widget build(BuildContext context) {
    final battleFieldToShow = widget.battleController.otherPlayerBattleField;
    return Listener(
      onPointerUp: (event) {
        final relativePosition = event.localPosition / widget.side;
        final target = Coordinates(
          battleFieldToShow.zone.lengthOffset
            + (battleFieldToShow.zone.length * relativePosition.dy).floor(),
          battleFieldToShow.zone.widthOffset
            + (battleFieldToShow.zone.width * relativePosition.dx).floor(),
        );
        final result = widget.battleController.makeTurn(target);
        setState(() {});
      },
      child: BattleFieldView(
        battleField: battleFieldToShow,
        showShips: false,
        side: widget.side,
      ),
    );
  }
}