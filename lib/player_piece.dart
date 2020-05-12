import 'package:flutter/material.dart';
import 'constants.dart';

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
    Color c = getColor(this.pieceType);
    container = Container(
      height: kPieceSize,
      width: kPieceSize,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Center(
        child: Text(
          this.pieceId.toString(),
          textAlign: TextAlign.center,
          style: kStyle.copyWith(
            fontSize: 8,
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

  static Color getColor(PieceType pt) {
    switch (pt) {
      case PieceType.Green:
        return green;
        break;
      case PieceType.Blue:
        return blue;
        break;
      case PieceType.Red:
        return red12;
        break;
      case PieceType.Yellow:
        return yellow2;
        break;
      default:
        return white;
    }
  }
}
