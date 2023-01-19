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
  final Map<String, Map<Ship, Set<Coordinates>>> shipsToHit;

  BattleLog(
    this.shipsToHit,
    [ListQueue<Turn>? existingLog]
  ): log = existingLog ?? ListQueue();

  String? get winner {
    for (var playerEntry in shipsToHit.entries) {
      print(playerEntry.value.entries.map(
              (shipEntry) => shipEntry.value.toString()));
      print(playerEntry.value.entries.map(
              (shipEntry) => shipEntry.key.hitZone.coordinates.toString()));
      print(playerEntry.value.entries.where(
        (shipEntry) => shipEntry.key.hitZone.coordinates.toSet().difference(
            shipEntry.value.toSet()
        ).isNotEmpty
      ).toList());
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
      shipsToHit[player]?[result]?.add(target);
    }

    log.add(Turn(player, target, result));
    return this;
  }
}