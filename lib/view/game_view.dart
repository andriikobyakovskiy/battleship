import 'dart:math';

import 'package:battleship/controller/battle_controller.dart';
import 'package:battleship/controller/ship_placing_controller.dart';
import 'package:battleship/model/battlefield.dart';
import 'package:battleship/model/zone.dart';
import 'package:battleship/view/battle_view.dart';
import 'package:battleship/view/ship_placing_view.dart';
import 'package:battleship/view/two_players_activity.dart';
import 'package:flutter/material.dart';

enum GameStage {
  enteringNames,
  settingShipsNumber,
  placingShips,
  battle,
  victory
}

class GameView extends StatefulWidget {
  const GameView({super.key});


  @override
  State createState()  => _GameState();
}

class _GameState extends State<GameView> {
  GameStage _stage = GameStage.enteringNames;
  String _editingNameError = 'Names should not be empty';
  String _player1Name = '';
  String _player2Name = '';
  String? _winner;
  bool _player1ShipsPlaced = false;
  Map<int, int> _shipsCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 1};
  late Map<String, BattleField> _battleFields;
  late Map<String, Map<int, int>> _playersShipsCounts;

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case GameStage.enteringNames:
        return _buildEnteringNamesView();
      case GameStage.settingShipsNumber:
        return _buildShipsCountsView();
      case GameStage.placingShips:
        return _buildShipsPlacingView();
      case GameStage.battle:
        return _buildBattleView();
      case GameStage.victory:
        return _buildVictoryScreen();
    }
  }

  Widget _buildVictoryScreen() {
    return SizedBox(
      width: 500,
      height: 500,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text("$_winner won!", style: const TextStyle(fontSize: 24))
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _player1Name = '';
                _player2Name = '';
                _editingNameError = 'Names should not be empty';
                _stage = GameStage.enteringNames;
              }),
              child: const Text(
                'Play Again',
                style: TextStyle(fontSize: 16),
              ),
            )
          ),
        ]
      ),
    );
  }

  Widget _buildBattleView() {
    final controller = BattleController.initiate(_battleFields);
    return TwoPlayersActivity(
      onActivityEnd: (winner) => setState(() {
        _winner = winner;
        _stage = GameStage.victory;
      }),
      header: "Battle",
      firstPlayer: controller.currentPlayer,
      widgetBuilder: (onActivityEnd, onError, onPlayerSwitch) => BattleView(
        battleController: controller,
        onError: onError,
        onPlayerSwitch: onPlayerSwitch,
        onVictory: (w) {
          onError('');
          onActivityEnd(w);
        },
      )
    );
  }

  Widget _buildShipsPlacingView() {
    final controller = ShipPlacingController(
      _battleFields,
      _playersShipsCounts
    );
    if (_player1ShipsPlaced) {
      controller.switchPlayer();
    }
    return TwoPlayersActivity(
      onActivityEnd: (_) => setState(() {
        _player1ShipsPlaced = false;
        _stage = GameStage.battle;
      }),
      header: "Select the ship and click on the battlefield to place it. "
            "Click on existing ship to remove it",
      firstPlayer: controller.currentPlayer,
      widgetBuilder: (onActivityEnd, onError, onPlayerSwitch) => ShipPlacingView(
        controller: controller,
        onError: onError,
        onPlayerSwitch: _player1ShipsPlaced
          ? (x) => onActivityEnd(x)
          : (player) {
              onPlayerSwitch(player);
              setState(() {
                _player1ShipsPlaced = true;
              });
            },
        gridSide: BattleView.gridSide,
      ),
    );
  }

  Widget _buildShipsCountsView() {
    return Column(
      children: <Widget>[
        const Text("Enter ships counts:", style: TextStyle(fontSize: 24)),
      ] + List.generate(
        5,
        (i) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Size ${i + 1}:"),
            ElevatedButton(
              onPressed: () => setState(() {
                _shipsCounts[i + 1] = max(0, _shipsCounts[i + 1]! - 1);
              }),
              child: const Text('-'),
            ),
            Text(_shipsCounts[i + 1]!.toString()),
            ElevatedButton(
              onPressed: () => setState(() {
                _shipsCounts[i + 1] = min(3, _shipsCounts[i + 1]! + 1);
              }),
              child: const Text('+'),
            ),
          ],
        )
      ) + [
        ElevatedButton(
          onPressed: () => setState(() {
            _playersShipsCounts = {
              _player1Name: Map.from(_shipsCounts),
              _player2Name: Map.from(_shipsCounts),
            };
            _stage = GameStage.placingShips;
          }),
          child: const Text('Ready', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }

  void _checkPlayersNames() {
    if (_player1Name == _player2Name) {
      setState(() {
        _editingNameError = 'Names should be different';
      });
    } else if (_player1Name.isNotEmpty && _player2Name.isNotEmpty) {
      setState(() {
        _editingNameError = '';
      });
    }
  }
  Widget _buildEnteringNamesView() {
    return SizedBox(
      width: 500,
      height: 500,
      child: Column(
        children: [
          const Text("Enter players names:", style: TextStyle(fontSize: 24)),
          Row(
            children: [
              const Text("Player 1: ", style: TextStyle(fontSize: 16)),
              Expanded(child: TextField(onChanged: (s) {
                _player1Name = s;
                _checkPlayersNames();
              })),
            ]
          ),
          Row(
            children: [
              const Text("Player 2: ", style: TextStyle(fontSize: 16)),
              Expanded(child: TextField(onChanged: (s) {
                _player2Name = s;
                _checkPlayersNames();
              })),
            ]
          ),
          Text(
            _editingNameError,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          ElevatedButton(
            onPressed: _editingNameError != ''
              ? null
              : () => setState(() {
                  _battleFields = {
                    _player1Name: BattleField.build(
                      Zone(10, 10, 'A'.runes.first, 1),
                    ),
                    _player2Name: BattleField.build(
                      Zone(10, 10, 'A'.runes.first, 1),
                    ),
                  };
                  _stage = GameStage.settingShipsNumber;
                }),
            child: const Text(
              'Ready',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}