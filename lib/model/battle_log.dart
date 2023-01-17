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
  final ListQueue<Turn> log;
  final Map<String, Map<Ship, Set<Coordinates>>> shipHits;

  BattleLog(
    this.shipHits,
    [ListQueue<Turn>? existingLog]
  ): log = existingLog ?? ListQueue();

  String? get winner {
    for (var playerEntry in shipHits.entries) {
      final shipsRemain = playerEntry.value.entries.any(
        (shipEntry) => shipEntry.value.toSet() !=
            shipEntry.key.hitZone.coordinates.toSet()
      );
      if (!shipsRemain)
        return playerEntry.key;
    }
    return null;
  }

  BattleLog logTurn(String player, Coordinates target, Ship? result) {
    if (result != null)
      shipHits[player]?[result]?.add(target);

    log.add(Turn(player, target, result));
    return this;
  }
}