import 'package:battleship/controller/utils.dart';
import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/coordinates.dart';
import 'package:battleship/model/ship.dart';

abstract class PlacingResult {}

class Success extends PlacingResult {
  final Ship? ship;

  Success(this.ship);
}

class Error extends PlacingResult {

  final String error;

  Error(this.error);
}

class ShipPlacingController {
  final Map<String, BattleField> _battleFields;
  final Map<String, Map<int, int>> _playersShipsCounts;
  String _currentPlayer;

  ShipPlacingController(
    this._battleFields,
    this._playersShipsCounts,
  ): _currentPlayer = _battleFields.keys.first;

  PlacingResult addShip(Coordinates start, Coordinates end) {
    try {
      final newShip = currentPlayerBattleField.addShip(
        Ship.build(start, end)
      );
      return Success(newShip);

    } on ArgumentError catch (e) {
      return Error(e.message);
    }
  }

  PlacingResult removeShip(Coordinates target) {
    try {
      final result = currentPlayerBattleField.removeShip(target);
      return Success(result);

    } on ArgumentError catch (e) {
      return Error(e.message);
    }
  }

  String switchPlayer() {
    _currentPlayer = otherPlayer(_currentPlayer, _battleFields);
    return _currentPlayer;
  }

  BattleField get currentPlayerBattleField => _battleFields[_currentPlayer]!;
  String get currentPlayer => _currentPlayer;
  Map<int, int> get currentShipsCount => _playersShipsCounts[_currentPlayer]!;
}