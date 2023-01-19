import 'package:battleship/controller/battle_controller.dart';
import 'package:battleship/view/battlefield_grid_wrapper.dart';
import 'package:battleship/view/battlefield_view.dart';
import 'package:battleship/view/target_listener.dart';
import 'package:flutter/material.dart';

class BattleView extends StatelessWidget {
  final BattleController battleController;
  final void Function(String) onError;
  final void Function(String) onWinner;
  final void Function(String) onSwitch;

  static const gridSide = 200.0;

  const BattleView({
    super.key,
    required this.battleController,
    required this.onError,
    required this.onSwitch,
    required this.onWinner,
  });

  @override
  Widget build(BuildContext context) {
    final battleFieldToListen = battleController.otherPlayerBattleField;
    final battleFieldToShow = battleController.currentPlayerBattleField;
    return SizedBox(
      width: gridSide * 2.5,
      height: gridSide * 1.1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: BattleFieldGridWrapper(
              battleField: battleController.currentPlayerBattleField,
              side: gridSide,
              battleFieldWidget: BattleFieldView(
                battleField: battleFieldToShow,
                showShips: true,
                side: gridSide,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TargetListener(
              onTarget: (target) {
                final result = battleController.makeTurn(target);
                if (result is Victory) {
                  onWinner(result.player);
                } else if (result is Error) {
                  onError(result.error);
                } else if (result is Hit) {
                  // wipe out existing error and update state
                  onError('');
                } else if (result is Miss) {
                  onSwitch(result.nextPlayer);
                }
              },
              zone: battleFieldToListen.zone,
              side: gridSide,
              child: BattleFieldGridWrapper(
                battleField: battleController.otherPlayerBattleField,
                side: gridSide,
                battleFieldWidget: BattleFieldView(
                  battleField: battleFieldToListen,
                  showShips: false,
                  side: gridSide,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}