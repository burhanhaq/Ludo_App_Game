import 'package:flutter/material.dart';
import 'constants.dart';

import 'game_state.dart';

class PlayerPiece {
  PieceType pieceType;
  int pieceId;
  Widget container;
  int location;
  Function func;
  PieceType pieceTurn;

  PlayerPiece(
      {this.pieceType,
      this.pieceId,
      this.location,
      this.func,
      this.pieceTurn}) {
    if (this.location == null) {
      this.location = 0;
    }
    Color c = GameState.getColor(this.pieceType);
    container = IgnorePointer(
      ignoring: false,
      child: GestureDetector(
        onTap: () => this.func(this),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Text(
            this.pieceId.toString(),
            textAlign: TextAlign.center,
            style: kStyle.copyWith(
              fontSize: 8,
            ),
          ),
        ),
      ),
    );
  }

  isAtHome() {
    return this.location == 0;
  }

  @override
  String toString() {
    return '${pieceId.toString()} - loc:${location.toString()} - ${pieceType} home:${isAtHome()}';
  }
}
