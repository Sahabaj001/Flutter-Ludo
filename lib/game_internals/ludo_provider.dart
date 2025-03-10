import 'dart:math';
import 'package:flutter/material.dart';
import 'ludo_player.dart';
import 'package:provider/provider.dart';
import 'package:basic/audio/audio.dart';
import 'constants.dart';
import 'package:basic/settings/settings_controller.dart';

class LudoProvider extends ChangeNotifier {
  final SettingsController _settingsController;

  LudoProvider(this._settingsController);

  // ==================== Game State and Properties ====================

  /// Current game state (throw dice, pick pawn, moving, finish)
  LudoGameState _gameState = LudoGameState.throwDice;
  LudoGameState get gameState => _gameState;

  /// Current player's turn
  LudoPlayerType _currentTurn = LudoPlayerType.green;

  /// Index of the current player (0: green, 1: yellow, 2: blue, 3: red)
  int _currentPlayerIndex = 0;
  int get currentPlayerIndex => _currentPlayerIndex;

  /// Number of players in the game (2, 3, or 4)
  int _numberOfPlayers = 2;
  int get numberOfPlayers => _numberOfPlayers;

  /// List of players in the game
  final List<LudoPlayer> players = [];

  /// List of winners
  final List<LudoPlayerType> winners = [];

  /// Current dice result
  int _diceResult = 0;
  int get diceResult => _diceResult.clamp(1, 6); // Ensure dice result is between 1 and 6

  /// Flag to check if dice is rolling
  bool _diceStarted = false;
  bool get diceStarted => _diceStarted;

  /// Flags to manage pawn movement
  bool _isMoving = false;
  bool _stopMoving = false;

  // ==================== Player and Pawn Management ====================

  /// Get the current player
  LudoPlayer get currentPlayer => players.firstWhere((element) => element.type == _currentTurn);

  /// Get a player by type
  LudoPlayer player(LudoPlayerType type) => players.firstWhere((element) => element.type == type);

  /// Check if a pawn can kill another pawn
  bool checkToKill(LudoPlayerType type, int index, int step, List<List<double>> path) {
    bool killSomeone = false;
    for (int i = 0; i < 4; i++) {
      var greenElement = player(LudoPlayerType.green).pawns[i];
      var blueElement = player(LudoPlayerType.blue).pawns[i];
      var redElement = player(LudoPlayerType.red).pawns[i];
      var yellowElement = player(LudoPlayerType.yellow).pawns[i];

      if ((greenElement.step > -1 && !LudoPath.safeArea.map((e) => e.toString()).contains(player(LudoPlayerType.green).path[greenElement.step].toString())) && type != LudoPlayerType.green) {
        if (player(LudoPlayerType.green).path[greenElement.step].toString() == path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.green).movePawn(i, -1);
          notifyListeners();
        }
      }
      if ((yellowElement.step > -1 && !LudoPath.safeArea.map((e) => e.toString()).contains(player(LudoPlayerType.yellow).path[yellowElement.step].toString())) && type != LudoPlayerType.yellow) {
        if (player(LudoPlayerType.yellow).path[yellowElement.step].toString() == path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.yellow).movePawn(i, -1);
          notifyListeners();
        }
      }
      if ((blueElement.step > -1 && !LudoPath.safeArea.map((e) => e.toString()).contains(player(LudoPlayerType.blue).path[blueElement.step].toString())) && type != LudoPlayerType.blue) {
        if (player(LudoPlayerType.blue).path[blueElement.step].toString() == path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.blue).movePawn(i, -1);
          notifyListeners();
        }
      }
      if ((redElement.step > -1 && !LudoPath.safeArea.map((e) => e.toString()).contains(player(LudoPlayerType.red).path[redElement.step].toString())) && type != LudoPlayerType.red) {
        if (player(LudoPlayerType.red).path[redElement.step].toString() == path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.red).movePawn(i, -1);
          notifyListeners();
        }
      }
    }
    return killSomeone;
  }

  // ==================== Dice and Turn Management ====================

  /// Roll the dice
  void throwDice() async {
    // Prevent multiple clicks or concurrent executions
    if (_gameState != LudoGameState.throwDice || _diceStarted) return;

    // Block further clicks immediately
    _diceStarted = true;
    notifyListeners();

    try {
      Audio.rollDice(); // Play dice roll sound

      // Skip turn if player already won
      if (winners.contains(currentPlayer.type)) {
        nextTurn();
        return;
      }

      // Turn off pawn highlights
      currentPlayer.highlightAllPawns(false);

      // Simulate dice rolling delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate dice result
      _diceResult = Random().nextInt(6) + 1;
      notifyListeners();
// Reset `_diceStarted` immediately after dice result is determined
      _diceStarted = false;
      notifyListeners();

      // Handle dice result
      if (diceResult == 6) {
        if (currentPlayer.pawnInsideCount == 4) {
          // Only highlight pawns inside home when all are in
          currentPlayer.highlightInside();
        } else if (currentPlayer.pawnInsideCount > 0) {
          // Highlight both pawns inside and outside home
          currentPlayer.highlightAllPawns();
        } else {
          // No pawns inside home, highlight only outside pawns
          currentPlayer.highlightOutside();
        }
        _gameState = LudoGameState.pickPawn;
      } else {
        if (currentPlayer.pawnInsideCount == 4) {
          await Future.delayed(const Duration(seconds: 1)); // Add delay here
          nextTurn(); // Skip turn if all pawns are inside
          return;
        } else {
          currentPlayer.highlightOutside();
          _gameState = LudoGameState.pickPawn;
        }
      }

      notifyListeners();

      // Disable highlight for pawns exceeding finish box
      for (var i = 0; i < currentPlayer.pawns.length; i++) {
        var pawn = currentPlayer.pawns[i];
        if ((pawn.step + diceResult) > currentPlayer.path.length - 1) {
          currentPlayer.highlightPawn(i, false);
        }
      }

      // Auto-move if all pawns are on the same step
      var moveablePawns = currentPlayer.pawns.where((e) => e.highlight).toList();
      if (moveablePawns.length > 1) {
        var maxStep = moveablePawns.map((e) => e.step).reduce(max);
        if (moveablePawns.every((p) => p.step == maxStep)) {
          var randomIndex = Random().nextInt(moveablePawns.length);
          var selectedPawn = moveablePawns[randomIndex];
          if (selectedPawn.step == -1) {
            // Move pawn out of home (step = 0)
            move(selectedPawn.type, selectedPawn.index, 0);
          } else {
            // Move pawn 6 steps ahead
            move(selectedPawn.type, selectedPawn.index, selectedPawn.step + 1 + diceResult);
          }
          return;
        }
      }

      // Handle turn switching
      if (currentPlayer.pawns.every((p) => !p.highlight)) {
        if (diceResult == 6) {
          _gameState = LudoGameState.throwDice;
        } else {
          // Delay before switching to the next player
          await Future.delayed(const Duration(seconds: 1)); // Add delay here
          nextTurn();
          return;
        }
      }

      // If only one pawn is highlighted, move it automatically
      if (currentPlayer.pawns.where((p) => p.highlight).length == 1) {
        var index = currentPlayer.pawns.indexWhere((p) => p.highlight);
        if (currentPlayer.pawns[index].step == -1) {
          // Move pawn out of home (step = 0)
          move(currentPlayer.type, index, 0);
        } else {
          // Move pawn 6 steps ahead
          move(currentPlayer.type, index, currentPlayer.pawns[index].step + 1 + diceResult);
        }
      }
    } finally {
      // Ensure `_diceStarted` is reset even if an error occurs
      _diceStarted = false;
      notifyListeners();
    }
  }
  /// Move pawn to the next step
  void move(LudoPlayerType type, int index, int step) async {
    if (_isMoving) return;
    _isMoving = true;
    _gameState = LudoGameState.moving;

    currentPlayer.highlightAllPawns(false);

    var selectedPlayer = player(type);

    // Ensure the pawn index is valid
    if (index < 0 || index >= selectedPlayer.pawns.length) {
      print("Invalid pawn index: $index. Skipping move.");
      _isMoving = false;
      return;
    }

    // Move pawn out of home (step = 0)
    if (step == 0) {
      selectedPlayer.movePawn(index, 0);
      notifyListeners();
      _isMoving = false;
      _gameState = LudoGameState.throwDice;
      return;
    }

    // Move pawn step by step
    for (int i = selectedPlayer.pawns[index].step; i < step; i++) {
      if (_stopMoving) break;

      // Move pawn step by step
      if (selectedPlayer.pawns[index].step == i) continue;

      selectedPlayer.movePawn(index, i);

      // Play move sound only if sound effects are enabled
      if (_settingsController.soundsOn.value) {
        await Audio.playMove();
      }

      notifyListeners(); // Update UI
      await Future.delayed(const Duration(milliseconds: 400));

      if (_stopMoving) break;
    }

    // After pawn movement, check if it has reached the finish line
    var movedPawn = selectedPlayer.pawns[index];

    if (movedPawn.step == selectedPlayer.path.length - 1) {
      // Play finish sound if sound effects are enabled
      if (_settingsController.soundsOn.value) {
        await Audio.playFinish();
      }
    }

    // Check if a pawn has been killed after moving
    if (checkToKill(type, index, step, selectedPlayer.path)) {
      _gameState = LudoGameState.throwDice;
      _isMoving = false;

      // Play kill sound if sound effects are enabled
      if (_settingsController.soundsOn.value) {
        await Audio.playKill();
      }

      notifyListeners();
      return;
    }

    // Validate if the current player has won
    validateWin(type);

    // Handle next turn logic based on dice result
    if (diceResult == 6) {
      _gameState = LudoGameState.throwDice;
    } else {
      nextTurn();
    }

    notifyListeners();
    _isMoving = false;
  }
  /// Switch to the next player's turn
  void nextTurn() {
    switch (_currentTurn) {
      case LudoPlayerType.green:
        _currentTurn = LudoPlayerType.yellow;
        _currentPlayerIndex = 1;
        break;
      case LudoPlayerType.yellow:
        _currentTurn = LudoPlayerType.blue;
        _currentPlayerIndex = 2;
        break;
      case LudoPlayerType.blue:
        _currentTurn = LudoPlayerType.red;
        _currentPlayerIndex = 3;
        break;
      case LudoPlayerType.red:
        _currentTurn = LudoPlayerType.green;
        _currentPlayerIndex = 0;
        break;
    }

    // Skip the turn if the next player has already won
    if (winners.contains(_currentTurn)) {
      nextTurn();
      return;
    }

    _gameState = LudoGameState.throwDice;
    notifyListeners();
  }

  /// Check if the current player has won
  void validateWin(LudoPlayerType color) {
    if (winners.map((e) => e.name).contains(color.name)) return;
    if (player(color).pawns.map((e) => e.step).every((element) => element == player(color).path.length - 1)) {
      winners.add(color);
      notifyListeners();
    }

    if (winners.length == 3) {
      _gameState = LudoGameState.finish;
    }
  }

  // ==================== Game Initialization ====================

  /// Start a new game with the specified number of players
  void startGame([int? numberOfPlayers]) {
    // Validate the number of players
    if (numberOfPlayers != null && (numberOfPlayers < 2 || numberOfPlayers > 4)) {
      throw ArgumentError("Number of players must be between 2 and 4.");
    }

    // Use the provided number of players or the stored value
    _numberOfPlayers = numberOfPlayers ?? _numberOfPlayers;
    winners.clear();
    players.clear();

    // Add players based on the selected number
    if (_numberOfPlayers >= 2) {
      players.add(LudoPlayer(LudoPlayerType.green));
      players.add(LudoPlayer(LudoPlayerType.yellow));
    }
    if (_numberOfPlayers >= 3) {
      players.add(LudoPlayer(LudoPlayerType.blue));
    }
    if (_numberOfPlayers >= 4) {
      players.add(LudoPlayer(LudoPlayerType.red));
    }

    _currentPlayerIndex = 0; // Reset to green player
    _currentTurn = LudoPlayerType.green; // Reset to green player
    _gameState = LudoGameState.throwDice; // Reset game state
    notifyListeners();

  }

  // ==================== Cleanup ====================

  @override
  void dispose() {
    _stopMoving = true;
    super.dispose();
  }

  static LudoProvider read(BuildContext context) => context.read();
}