import 'dart:math';

import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/zone.dart';

class Ship {
  final Zone hitZone;

  const Ship._(this.hitZone);

  factory Ship.build(Coordinates start, Coordinates end) {
    if(start.x != end.x && start.y != end.y)
       throw Exception("Ship should be placed horizontally or vertically");

    return Ship._(Zone(
      (start.x - end.x).abs(),
      (start.y - end.y).abs(),
      min(start.x, end.x),
      min(start.y, end.y),
    ));
  }

  // zone where other ships cannot be placed
  Zone get surroundingZone => Zone(
    hitZone.length + 2,
    hitZone.width + 2,
    hitZone.lengthOffset - 1,
    hitZone.widthOffset - 1
  );

  // zone where other ships cannot be placed
  Ship get rotated => Ship._(Zone(
    hitZone.width,
    hitZone.length,
    hitZone.lengthOffset,
    hitZone.widthOffset,
  ));

  int get size => max(hitZone.length, hitZone.width);

  @override
  int get hashCode => hitZone.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is Ship
    && (other.hitZone == this.hitZone)
  );
}