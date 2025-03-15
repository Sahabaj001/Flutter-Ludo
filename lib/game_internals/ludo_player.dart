import 'package:flutter/material.dart';
import 'constants.dart';
import '/game_widgets/pawn_widget.dart';

class LudoPlayer {
  ///Player type
  final LudoPlayerType type;

  ///Pawn's paths
  late List<List<double>> path;

  ///Home path
  late List<List<double>> homePath;

  ///Pawn widgets
  final List<PawnWidget> pawns = [];

  ///Player color
  late Color color;

  LudoPlayer(this.type) {
    for (int i = 0; i < 4; i++) {
      pawns.add(PawnWidget(i, type));
    }

    ///initializing paths
    switch (type) {
      case LudoPlayerType.green:
        path = LudoPath.greenPath;
        color = LudoColor.green;
        homePath = LudoPath.greenHomePath;
        break;
      case LudoPlayerType.yellow:
        path = LudoPath.yellowPath;
        color = LudoColor.yellow;
        homePath = LudoPath.yellowHomePath;
        break;
      case LudoPlayerType.blue:
        path = LudoPath.bluePath;
        color = LudoColor.blue;
        homePath = LudoPath.blueHomePath;
        break;
      case LudoPlayerType.red:
        path = LudoPath.redPath;
        color = LudoColor.red;
        homePath = LudoPath.redHomePath;
        break;
    }
  }

  int get pawnInsideCount => pawns.where((element) => element.step == -1).length;

  int get pawnOutsideCount => pawns.where((element) => element.step > -1).length;

  void movePawn(int index, int step) async {
    pawns[index] = PawnWidget(index, type, step: step, highlight: false);
  }

  void highlightPawn(int index, [bool highlight = true]) {
    var pawn = pawns[index];
    pawns.removeAt(index);
    pawns.insert(index, PawnWidget(index, pawn.type, highlight: highlight, step: pawn.step));
  }

  void highlightAllPawns([bool highlight = true]) {
    for (var i = 0; i < pawns.length; i++) {
      highlightPawn(i, highlight);
    }
  }

  void highlightOutside([bool highlight = true]) {
    for (var i = 0; i < pawns.length; i++) {
      if (pawns[i].step != -1) highlightPawn(i, highlight);
    }
  }

  void highlightInside([bool highlight = true]) {
    for (var i = 0; i < pawns.length; i++) {
      if (pawns[i].step == -1) highlightPawn(i, highlight);
    }
  }
}
