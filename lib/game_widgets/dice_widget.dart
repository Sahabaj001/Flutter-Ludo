import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../game_internals/constants.dart';
import '../game_internals/ludo_provider.dart';

class DiceWidget extends StatelessWidget {
  const DiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LudoProvider>(
      builder: (context, value, child) {
        final diceResult = value.diceResult ?? 1; // Default to 1 if null

        return RippleAnimation(
          color: value.gameState == LudoGameState.throwDice
              ? (value.currentPlayer?.color ?? Colors.white)
              : Colors.transparent, // Use transparent instead of opacity 0
          ripplesCount: value.gameState == LudoGameState.throwDice ? 3 : 0, // Avoid unnecessary animations
          minRadius: 50,
          repeat: true,
          child: AbsorbPointer(
            absorbing: value.diceStarted, // Block clicks while dice is rolling
            child: CupertinoButton(
              onPressed: () {
                if (value.gameState == LudoGameState.throwDice && !value.diceStarted) {
                  debugPrint("Dice clicked, rolling...");
                  value.throwDice();
                }
              },
              padding: EdgeInsets.zero, // Remove unnecessary padding
              child: value.diceStarted
                  ? Image.asset(
                "assets/images/dice/draw.gif",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Fallback if asset is missing
                },
              )
                  : Image.asset(
                "assets/images/dice/$diceResult.jpg",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Fallback if asset is missing
                },
              ),
            ),
          ),
        );
      },
    );
  }
}