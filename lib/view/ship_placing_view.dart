import 'package:battleship/controller/ship_placing_controller.dart';
import 'package:battleship/view/battlefield_grid_wrapper.dart';
import 'package:battleship/view/battlefield_view.dart';
import 'package:battleship/view/target_listener.dart';
import 'package:flutter/material.dart';

enum ShipOrientation {
  vertical,
  horizontal,
}

ShipOrientation otherOrientation (ShipOrientation current) =>
  current == ShipOrientation.vertical
    ? ShipOrientation.horizontal
    : ShipOrientation.vertical;

class ShipPlacingView extends StatefulWidget {

  final ShipPlacingController controller;
  final Map<int, int> shipsCount;
  final double gridSide;
  final Function(String) onError;
  final Function(String) onSwitch;

  const ShipPlacingView({
    super.key,
    required this.controller,
    required this.shipsCount,
    required this.gridSide,
    required this.onError,
    required this.onSwitch,
  });

  @override
  State createState() => _ShipPlacingState();
}

class _ShipPlacingState extends State<ShipPlacingView> {
  late final Map<int, ShipOrientation> _shipsOrientation;
  int? _selectedShip;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _shipsOrientation = widget.shipsCount.map(
      (key, value) => MapEntry(key, ShipOrientation.vertical)
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.gridSide * 2.5,
      height: widget.gridSide * 1.1,
      child: Row(
        children: [
          TargetListener(
            onTarget: (target) {
              if (_selectedShip == null) {
                final result = widget.controller.removeShip(target);
                setState(() {
                  if (result is Error) {
                      _error = result.error;
                  } else {
                    final removedShip = (result as Success).ship;
                    if (removedShip != null) {
                      widget.shipsCount[removedShip.size] =
                          widget.shipsCount[removedShip.size]! + 1;
                    }
                  }
                });
              } else {
                final result = widget.controller.addShip(
                  target,
                  _shipsOrientation[_selectedShip!]! == ShipOrientation.vertical
                    ? target.copyWith(length: target.length + _selectedShip! - 1)
                    : target.copyWith(width: target.width + _selectedShip! - 1)
                );
                setState(() {
                  if (result is Error) {
                    _error = result.error;
                    _selectedShip = null;
                  } else {
                    widget.shipsCount[_selectedShip!] =
                        widget.shipsCount[_selectedShip!]! - 1;
                    _selectedShip = null;
                  }
                });
              }
            },
            zone: widget.controller.currentPlayerBattleField.zone,
            side: widget.gridSide,
            child: BattleFieldGridWrapper(
              battleField: widget.controller.currentPlayerBattleField,
              side: widget.gridSide,
              battleFieldWidget: BattleFieldView(
                battleField: widget.controller.currentPlayerBattleField,
                showShips: true,
                side: widget.gridSide,
              ),
            ),
          ),
          Spacer(),
          Column(
            children: List<Widget>.generate(
              widget.shipsCount.length,
              (i) => Row(
                children: [
                  ElevatedButton(
                    onPressed: widget.shipsCount[i+1]! == 0
                      ? null
                      : () => setState(() { _selectedShip = i + 1; }),
                    child: Text(
                      _shipsOrientation[i+1]! == ShipOrientation.vertical
                        ? "${i+1}V: ${widget.shipsCount[i+1]!} left"
                        : "${i+1}H: ${widget.shipsCount[i+1]!} left"
                    )
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _shipsOrientation[i+1] =
                          otherOrientation(_shipsOrientation[i+1]!);
                    }),
                    child: const Icon(Icons.rotate_left),
                  ),
                ],
              )
            ) + [
              Text(_error, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: widget.shipsCount.values.any((x) => x != 0)
                  ? null
                  : () => widget.onSwitch(widget.controller.switchPlayer()),
                child: const Text("Ships ready")
              ),
            ],
          ),
        ],
      )
    );
  }
}