import 'package:battleship/model/ship.dart';
import 'package:battleship/model/zone.dart';
import 'package:battleship/model/coordinates.dart';
import 'package:collection/collection.dart';

class BattleField {
  final Zone zone;
  final List<List<bool?>> _hitMap;
  final List<Ship> ships;

  const BattleField._(this.zone, this.ships, this._hitMap);

  factory BattleField.build(
    Zone zone,
    {List<List<bool?>>? existingHitMap,
     List<Ship>? existingShips}
  ) {
    final hitMap = existingHitMap ?? List.generate(
      zone.length,
      (_) => List.filled(zone.width, null)
    );
    if (hitMap.any((row) => row.length != hitMap.first.length)) {
      throw ArgumentError("Hits map should be rectangle");
    }
    if (hitMap.length != zone.length
        || hitMap.first.length != zone.width) {
      throw ArgumentError("Hits map should have same dimensions as battle zone");
    }

    final ships = existingShips ?? <Ship>[];

    if (ships.any((s) => s.hitZone.coordinates.any((c) => !zone.contains(c)))) {
      throw ArgumentError("Ships should be placed inside battlefield");
    }
    for (var i = 0; i < ships.length; i++) {
      for (var j = i + 1; j < ships.length; j++) {
        if (ships[i].intersects(ships[j])) {
          throw ArgumentError("Ships should not intersect");
        }
      }
    }

    return BattleField._(zone, ships, hitMap);
  }

  Ship addShip(Ship newShip) {
    for (var i = 0; i < ships.length; i++) {
      if (ships[i].intersects(newShip)) {
        throw ArgumentError("Ships should not intersect");
      }
    }
    ships.add(newShip);
    return newShip;
  }

  Ship? removeShip(Coordinates target) {
    final ship = checkHit(target);
    if (ship != null) {
      ships.remove(ship);
    }
    return ship;
  }

  Ship? checkHit(Coordinates c) =>
      ships.firstWhereOrNull((ship) => ship.hitZone.contains(c));

  Ship? makeMove(Coordinates c) {
    if (!zone.contains(c)) {
      throw ArgumentError("Cannot target outside the battlefield");
    }
    if (_hitMap[c.length - zone.lengthOffset][c.width - zone.widthOffset] != null) {
      throw ArgumentError("Cannot target same coordinates twice");
    }

    final target = checkHit(c);
    _hitMap[c.length - zone.lengthOffset][c.width - zone.widthOffset] = target != null;
    return target;
  }

  List<List<bool?>> get hitMap =>
    List.generate(
      _hitMap.length,
      (x) => List.from(_hitMap[x])
    );
}