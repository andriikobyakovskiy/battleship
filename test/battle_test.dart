import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/ship.dart';
import 'package:battleship/model/zone.dart';
import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/battle_log.dart';
import 'package:battleship/model/battle_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Battlefield Factory', () {
    test('Unit battlefield', (){
      expect(BattleField.build(const Zone(1, 1)).hitMap, [[null]]);
    });
    test('Regular battlefield', (){
      expect(
        BattleField.build(const Zone(10, 10)).hitMap,
        List.filled(10, List.filled(10, null))
      );
    });
    test('Acceptable hits map', (){
      expect(
        BattleField.build(
          const Zone(2, 2),
          existingHitMap: [
            [null, null],
            [null, null]
          ],
        ).hitMap,
        [[null, null], [null, null]]
      );
    });
    test('Non-rectangular hits map', (){
      expect(
        () => BattleField.build(
          const Zone(2, 2),
          existingHitMap: [
            [false],
            [false, false]
          ],
        ),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Hits map should be rectangle"))
      );
    });
    test('Hits map with wrong dimensions', (){
      expect(
        () => BattleField.build(
          const Zone(2, 3),
          existingHitMap: [
            [false, false],
            [false, false]
          ],
        ),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Hits map should have same dimensions as battle zone"))
      );
      expect(
        () => BattleField.build(
          const Zone(3, 2),
          existingHitMap: [
            [false, false],
            [false, false]
          ],
        ),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Hits map should have same dimensions as battle zone"))
      );
    });
    test('Ships out of the battlefield', (){
      expect(
        () => BattleField.build(
          const Zone(10, 10),
          existingShips: [Ship.build(
            const Coordinates(20, 20),
            const Coordinates(21, 20)
          )]
        ),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Ships should be placed inside battlefield"))
      );
    });
    test('Intersecting ships', (){
      expect(
        () => BattleField.build(
          const Zone(10, 10),
          existingShips: [
            Ship.build(
              const Coordinates(4, 5),
              const Coordinates(6, 5)
            ),
            Ship.build(
              const Coordinates(5, 4),
              const Coordinates(5, 6)
            ),
          ]
        ),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Ships should not intersect"))
      );
    });
  });
  /*============================================================*/
  group('Battlefield Methods', () {
    /*
       123456789(10)
       __________
    A |s.........
    B |..........
    C |..........
    D |..........
    E |.....s....
    F |.....s....
    G |.....s....
    H |..........
    I |..........
    J |.......sss
     */
    final b = BattleField.build(
      Zone(10, 10, 'A'.runes.first, 1),
      existingShips: [
        Ship.build(
          Coordinates.letterDigit('A', 1),
          Coordinates.letterDigit('A', 1)
        ),
        Ship.build(
          Coordinates.letterDigit('E', 6),
          Coordinates.letterDigit('G', 6),
        ),
        Ship.build(
          Coordinates.letterDigit('J', 8),
          Coordinates.letterDigit('J', 10)
        ),
      ]
    );
    test('Check hit', (){
      expect(b.checkHit(Coordinates.letterDigit('B', 2)), null);
      expect(
        b.checkHit(Coordinates.letterDigit('E', 6)),
        Ship.build(
          Coordinates.letterDigit('E', 6),
          Coordinates.letterDigit('G', 6),
        )
      );
    });
    test('Add ship successfully', (){
      final s = Ship.build(
        Coordinates.letterDigit('A', 8),
        Coordinates.letterDigit('A', 10),
      );
      b.addShip(s);
      expect(b.ships.contains(s), true);
    });
    test('Add intersecting ship', (){
      final s = Ship.build(
        Coordinates.letterDigit('F', 5),
        Coordinates.letterDigit('F', 7),
      );
      expect(
        () => b.addShip(s),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Ships should not intersect"))
      );
    });
    test('Remove ship', (){
      final s = Ship.build(
        Coordinates.letterDigit('A', 1),
        Coordinates.letterDigit('A', 1),
      );
      b.removeShip(s);
      expect(b.ships.contains(s), false);
    });
    test('Target ship', (){
      final s = Ship.build(
        const Coordinates(1, 1),
        const Coordinates(1, 1)
      );
      final b1 = BattleField.build(
        const Zone(3, 3),
        existingShips: [s]
      );
      expect(b1.makeMove(const Coordinates(1, 1)), s);
    });
    test('Target twice the same place', (){
      final b1 = BattleField.build(
        const Zone(3, 3),
        existingShips: [
          Ship.build(
            const Coordinates(1, 1),
            const Coordinates(1, 1)
          ),
        ]
      );
      b1.makeMove(const Coordinates(1, 1));
      expect(
        () => b1.makeMove(const Coordinates(1, 1)),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Cannot target same coordinates twice"))
      );
    });
    test('Target outside of battlefield', (){
      final b1 = BattleField.build(
        const Zone(3, 3),
        existingShips: [
          Ship.build(
            const Coordinates(1, 1),
            const Coordinates(1, 1)
          ),
        ]
      );
      expect(
        () => b1.makeMove(const Coordinates(10, 10)),
        throwsA(predicate((e) =>
          e is ArgumentError &&
          e.message == "Cannot target outside the battlefield"))
      );
    });
  });
  /*============================================================*/
}