import 'package:flutter/material.dart';

import 'player_piece.dart';
import 'constants.dart';

class Slot {
  final int id;
  bool isHomeStop;
  bool isOtherStop;
  bool isEnd;
  List<PlayerPiece> playerPieceList;

  Slot({@required this.id, this.isHomeStop = false, this.isOtherStop = false, this.isEnd = false, this.playerPieceList}) {
    if (playerPieceList == null) {
      playerPieceList = [];
    }
  }

  isStop() {
    return this.isHomeStop || this.isOtherStop;
  }

}

