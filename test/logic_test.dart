import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/ship.dart';
import 'package:battleship/model/zone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coordinates', () {
    test('Comparison', (){
      expect(const Coordinates(0, 0) == const Coordinates(0, 0), true);
      expect(const Coordinates(0, 0) == const Coordinates(0, 1), false);
    });
    test('Copy with', (){
      expect(
        const Coordinates(0, 0).copyWith(y: 1),
        const Coordinates(0, 1)
      );
      expect(
        const Coordinates(0, 0).copyWith(x: 1),
        const Coordinates(1, 0)
      );
      expect(
        const Coordinates(0, 0).copyWith(x: 1, y: 1),
        const Coordinates(1, 1)
      );
    });
  });
  /*============================================================*/
  group('Unit Zone', (){
    const z = Zone(1,1);
    const c = Coordinates(0, 0);
    test('Contains one coordinate', () {
      expect(z.contains(c), true);
    });
    test('Does not contain other coordinates', (){
      expect(z.contains(const Coordinates(1, 0)), false);
      expect(z.contains(const Coordinates(0, 1)), false);
      expect(z.contains(const Coordinates(1, 1)), false);
    });
    test('List of coordinates contains only origin', (){
      expect(z.coordinates.toList(), [c]);
    });
    test('Comparison', (){
      const z2 = Zone(1, 1, 0, 0);
      const z3 = Zone(1, 1, 1, 1);
      expect(z == z2, true);
      expect(z == z3, false);
    });
  });
  /*============================================================*/
  group('Complex Zone', (){
    const z = Zone(3,4,3,4);
    test('Contains corner coordinates', () {
      expect(z.contains(const Coordinates(3, 4)), true);
      expect(z.contains(const Coordinates(3, 7)), true);
      expect(z.contains(const Coordinates(5, 4)), true);
      expect(z.contains(const Coordinates(5, 7)), true);
    });
    test('Contains inner coordinates', () {
      expect(z.contains(const Coordinates(4, 5)), true);
      expect(z.contains(const Coordinates(3, 6)), true);
      expect(z.contains(const Coordinates(4, 4)), true);
      expect(z.contains(const Coordinates(4, 5)), true);
      expect(z.contains(const Coordinates(5, 4)), true);
    });
    test('Does not contain other coordinates', (){
      expect(z.contains(const Coordinates(0, 0)), false);
      expect(z.contains(const Coordinates(10, 0)), false);
      expect(z.contains(const Coordinates(0, 10)), false);
      expect(z.contains(const Coordinates(10, 10)), false);
      expect(z.contains(const Coordinates(4, 10)), false);
      expect(z.contains(const Coordinates(10, 5)), false);
      expect(z.contains(const Coordinates(4, 0)), false);
      expect(z.contains(const Coordinates(0, 5)), false);
    });
    test('List of coordinates contains only origin', (){
      expect(z.coordinates, [
        const Coordinates(3, 4),
        const Coordinates(3, 5),
        const Coordinates(3, 6),
        const Coordinates(3, 7),
        const Coordinates(4, 4),
        const Coordinates(4, 5),
        const Coordinates(4, 6),
        const Coordinates(4, 7),
        const Coordinates(5, 4),
        const Coordinates(5, 5),
        const Coordinates(5, 6),
        const Coordinates(5, 7),
      ]);
    });
    test('Comparison', (){
      const z2 = Zone(3,4,3,4);
      const z3 = Zone(4,3,4,3);
      expect(z == z2, true);
      expect(z == z3, false);
    });
  });
  /*============================================================*/
  group('Ship Factory', (){
    test('Unit ship', (){
      final s = Ship.build(const Coordinates(0,0), const Coordinates(0,0));
      expect(s.hitZone.coordinates, [const Coordinates(0,0)]);
    });
    test('Unit ship with offset', (){
      final s = Ship.build(const Coordinates(5,5), const Coordinates(5,5));
      expect(s.hitZone.coordinates, [const Coordinates(5,5)]);
    });
    test('Complex ship', (){
      final s = Ship.build(const Coordinates(3,4), const Coordinates(3,6));
      expect(
        s.hitZone.coordinates,
        [
          const Coordinates(3,4),
          const Coordinates(3,5),
          const Coordinates(3,6),
        ]
      );
    });
    test('Bad coordinates', (){
      expect(
        () => Ship.build(const Coordinates(0,0), const Coordinates(1,1)),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Ship should be placed horizontally or vertically"))
      );
    });
  });
  /*============================================================*/
  group('Ship properties', (){
    final s = Ship.build(const Coordinates(3,4), const Coordinates(3,6));
    test('Size', () {
      expect(s.size, 3);
    });
    test('Surrounding zone', (){
      expect(s.surroundingZone, const Zone(3,5,2,3));
    });
    test('Comparison', (){
      final s2 = Ship.build(const Coordinates(3,4), const Coordinates(3,6));
      final s3 = Ship.build(const Coordinates(3,4), const Coordinates(3,7));
      expect(s == s2, true);
      expect(s == s3, false);
    });
    test('Rotation', (){
      expect(
        s.rotated,
        Ship.build(const Coordinates(3,4), const Coordinates(5,4))
      );
    });
  });
}