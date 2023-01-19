import 'package:battleship/controller/battle_log.dart';
import 'package:battleship/controller/utils.dart';
import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/coordinates.dart';

abstract class TurnResult {}

class Victory extends TurnResult{
  final String player;

  Victory(this.player);
}

class Error extends TurnResult {
  final String error;

  Error(this.error);
}

class Hit extends TurnResult {}

class Miss extends TurnResult {
  final String nextPlayer;

  Miss(this.nextPlayer);
}

class BattleController {
  final BattleLog log;
  final Map<String, BattleField> battleFields;
  String _currentPlayer;

  BattleController._(
    this.log,
    this.battleFields,
  ): _currentPlayer = battleFields.keys.first;

  factory BattleController.initiate(Map<String, BattleField> battleFields) {
    final log = BattleLog(battleFields.map(
      (player, bf) => MapEntry(
        otherPlayer(player, battleFields),
        Map.fromIterable(bf.ships, value: (_) => <Coordinates>{})
      )
    ));
    return BattleController._(log, battleFields);
  }

  TurnResult makeTurn(Coordinates target) {
    try {
      final result = otherPlayerBattleField.makeMove(target);
      log.logTurn(_currentPlayer, target, result);
      final winner = log.winner;
      if (winner != null) {
        return Victory(winner);
      }

      if (result == null) {
        _currentPlayer = otherPlayer(_currentPlayer, battleFields);
        return Miss(_currentPlayer);
      }
      else {
        return Hit();
      }

    } on ArgumentError catch (e) {
      return Error(e.message);
    }
  }

  BattleField get currentPlayerBattleField => battleFields[_currentPlayer]!;
  BattleField get otherPlayerBattleField => otherBattleField(
    _currentPlayer,
    battleFields
  );

  String get currentPlayer => _currentPlayer;
}