import 'dart:collection';

import 'package:battleship/model/ship.dart';
import 'package:battleship/model/zone.dart';
import 'package:battleship/model/coordinates.dart';

class BattleField {
  final Zone zone;
  final List<List<bool?>> _hitMap;
  // I planned to use linked list here, but dart documentation suggests
  // to use queue instead as generic collection with quick append
  final ListQueue<Ship> ships;

  const BattleField._(this.zone, this.ships, this._hitMap);

  factory BattleField.build(
    Zone battleZone,
    [List<List<bool?>>? existingHitMap,
     ListQueue<Ship>? existingShips]
  ) {
    final hitMap = existingHitMap ?? List.filled(
      battleZone.length,
      List.filled(battleZone.width, null)
    );
    if (hitMap.any((row) => row.length != hitMap.first.length))
      throw ArgumentError("Hits map should be rectangle");
    if (hitMap.length != battleZone.length
        && hitMap.first.length != battleZone.width)
      throw ArgumentError("Hits map should have same dimentions as battle zone");

    final ships = existingShips ?? ListQueue();
    return BattleField._(battleZone, ships, hitMap);
  }

  BattleField addShip(Ship newShip) {
    ships.add(newShip);
    return this;
  }

  Ship? checkHit(Coordinates c) =>
      ships.firstWhere((ship) => ship.hitZone.contains(c));

  Ship? makeMove(Coordinates c) {
    if (!zone.contains(c))
      throw ArgumentError("Cannot target outside the battlefield");
    if (_hitMap[c.x][c.y] != null)
      throw ArgumentError("Cannot target same coordinates twice");

    final target = checkHit(c);
    _hitMap[c.x][c.y] = target != null;
    return target;
  }

  List<List<bool?>> get hitMap =>
    List.generate(
      hitMap.length,
      (x) => List.from(hitMap[x])
    );
}