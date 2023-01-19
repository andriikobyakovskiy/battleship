import 'dart:math';

import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/zone.dart';

class Ship {
  final Zone hitZone;

  const Ship._(this.hitZone);

  factory Ship.build(Coordinates start, Coordinates end) {
    if(start.length != end.length && start.width != end.width) {
      throw ArgumentError("Ship should be placed horizontally or vertically");
    }

    return Ship._(Zone(
      (start.length - end.length).abs() + 1,
      (start.width - end.width).abs() + 1,
      min(start.length, end.length),
      min(start.width, end.width),
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

  bool intersects(Ship other) =>
    hitZone.coordinates.toSet().intersection(
      // switch between surroundingZone and hitZone here to
      // allow/reject placing ships one close to another
      other.surroundingZone.coordinates.toSet()
    ).isNotEmpty;

  @override
  int get hashCode => hitZone.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is Ship
    && (other.hitZone == this.hitZone)
  );
}