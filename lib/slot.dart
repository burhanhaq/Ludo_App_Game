import 'package:flutter/material.dart';

import 'player_piece.dart';
import 'constants.dart';

class Slot {
  final int id;
  bool isStop;
  bool isEnd;
  List<PlayerPiece> playerPieceList;

  Slot({@required this.id, this.isStop = false, this.isEnd = false, this.playerPieceList}) {
    if (playerPieceList == null) {
      playerPieceList = [];
    }
  }

}

