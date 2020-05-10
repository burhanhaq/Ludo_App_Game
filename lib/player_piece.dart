import 'package:flutter/material.dart';
import 'constants.dart';

class PlayerPiece {
  PieceType pieceType;
  int pieceId;
  Widget container;
  int location;
  Function func;

  PlayerPiece({this.pieceType, this.pieceId, this.location, this.func}) {
    if (this.location == null) {
      this.location = 0;
    }
    Color c;
    switch (this.pieceType) {
      case PieceType.Green:
        c = green;
        break;
      case PieceType.Blue:
        c = blue;
        break;
      case PieceType.Red:
        c = red1;
        break;
      case PieceType.Yellow:
        c = yellow;
        break;
    }
    container = GestureDetector(
      onTap: () => this.func(this),
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.0)),
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
