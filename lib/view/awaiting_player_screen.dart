import 'package:flutter/material.dart';

class AwaitingPlayerScreen extends StatelessWidget {

  final void Function() onReady;
  final String player;

  const AwaitingPlayerScreen({
    super.key,
    required this.onReady,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 500,
      height: 500,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Awaiting player $player",
              style: const TextStyle(fontSize: 24),
            )
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: onReady,
              child: const Text(
                'Ready',
                style: TextStyle(fontSize: 16),
              ),
            )
          ),
        ],
      ),
    );
  }
}