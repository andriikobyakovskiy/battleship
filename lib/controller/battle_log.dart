import 'dart:collection';

import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/ship.dart';

class Turn {
  final String player;
  final Coordinates target;
  final Ship? result;

  const Turn(this.player, this.target, this.result);
}

class BattleLog {
  final ListQueue<Turn> _log;
  final Map<String, Map<Ship, Set<Coordinates>>> _shipsToHit;

  BattleLog(
    this._shipsToHit,
    [ListQueue<Turn>? existingLog]
  ): _log = existingLog ?? ListQueue();

  String? get winner {
    for (var playerEntry in _shipsToHit.entries) {
      final shipsRemain = playerEntry.value.entries.any(
        (shipEntry) => shipEntry.key.hitZone.coordinates.toSet().difference(
          shipEntry.value.toSet()
        ).isNotEmpty
      );
      if (!shipsRemain) {
        return playerEntry.key;
      }
    }
    return null;
  }

  BattleLog logTurn(String player, Coordinates target, Ship? result) {
    if (result != null) {
      _shipsToHit[player]?[result]?.add(target);
    }

    _log.add(Turn(player, target, result));
    return this;
  }
}