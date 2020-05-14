import 'package:flutter/material.dart';
import 'constants.dart';

class PlayerPiece {
  PieceType pieceType;
  int pieceId;
  Widget container;
  int location;

//  PieceType pieceTurn;
  bool isAtEndColumn;
  bool runComplete;

  PlayerPiece({this.pieceId, this.pieceType}) {
    location = 0;
    isAtEndColumn = false;
    runComplete = false;
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
  String toString() =>
      '${pieceId.toString()} @ ${location.toString()} - $pieceType';

  static Color getColor(PieceType pt) {
    switch (pt) {
      case PieceType.Green:
        return green;
      case PieceType.Blue:
        return blue;
      case PieceType.Red:
        return red1;
      case PieceType.Yellow:
        return yellow;
      default:
        return white;
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (this.pieceId == other.pieceId) {
     if (this.pieceType == other.pieceType) {
       return true;
     }
    }
    return false;
  }

  @override
  int get hashCode => 31 * 17 + pieceId.hashCode;
}
