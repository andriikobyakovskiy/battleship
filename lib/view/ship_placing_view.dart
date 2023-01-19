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
  final double gridSide;
  final Function(String) onError;
  final Function(String) onPlayerSwitch;

  const ShipPlacingView({
    super.key,
    required this.controller,
    required this.gridSide,
    required this.onError,
    required this.onPlayerSwitch,
  });

  @override
  State createState() => _ShipPlacingState();
}

class _ShipPlacingState extends State<ShipPlacingView> {
  late final Map<int, ShipOrientation> _shipsOrientation;
  int? _selectedShip;

  @override
  void initState() {
    super.initState();
    _shipsOrientation = widget.controller.currentShipsCount.map(
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
                if (result is Error) {
                  widget.onError(result.error);
                } else {
                  setState(() {
                    final removedShip = (result as Success).ship;
                    if (removedShip != null) {
                      widget.controller.currentShipsCount[removedShip.size] =
                          widget.controller.currentShipsCount[removedShip.size]! + 1;
                    }
                  });
                }
              } else {
                final result = widget.controller.addShip(
                  target,
                  _shipsOrientation[_selectedShip!]! == ShipOrientation.vertical
                    ? target.copyWith(length: target.length + _selectedShip! - 1)
                    : target.copyWith(width: target.width + _selectedShip! - 1)
                );
                if (result is Error) {
                  _selectedShip = null;
                  widget.onError(result.error);
                } else {
                  setState(() {
                    widget.controller.currentShipsCount[_selectedShip!] =
                        widget.controller.currentShipsCount[_selectedShip!]! - 1;
                    _selectedShip = null;
                  });
                }
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
          const Spacer(),
          Column(
            children: List<Widget>.generate(
              widget.controller.currentShipsCount.length,
              (i) => Row(
                children: [
                  ElevatedButton(
                    // disable button if no ships left
                    onPressed: widget.controller.currentShipsCount[i+1]! == 0
                      ? null
                      : () => setState(() { _selectedShip = i + 1; }),
                    child: Text(
                      _shipsOrientation[i+1]! == ShipOrientation.vertical
                        ? "${i+1} Vertical: ${widget.controller.currentShipsCount[i+1]!} left"
                        : "${i+1} Horizontal: ${widget.controller.currentShipsCount[i+1]!} left"
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
              ElevatedButton(
                // disable if any ships left to place
                onPressed: widget.controller
                                 .currentShipsCount
                                 .values.any((x) => x != 0)
                  ? null
                  : () => widget.onPlayerSwitch(widget.controller.switchPlayer()),
                child: const Text("Ships ready")
              ),
            ],
          ),
        ],
      )
    );
  }
}