import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class PlayerPiece {
  PieceType pieceType;
  int pieceId;
  Widget container;
  int location;
  double pieceWidth;

//  PieceType pieceTurn;
//  bool isAtEndColumn;

  PlayerPiece({
    @required this.pieceId,
    @required this.pieceType,
    @required this.pieceWidth,
  }) {
    location = 0;
//    isAtEndColumn = false;
    Color c = getColor(this.pieceType);
    container = Container(
      height: pieceWidth,
      width: pieceWidth,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Center(
        child: Text(
          kDebugMode ? this.pieceId.toString() : '',
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

  isRunComplete() {
    return this.location == 106;
//    return this.location == 6 && this.isAtEndColumn;
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
    return this.pieceType == other.pieceType && this.pieceId == other.pieceId;
  }

  @override
  int get hashCode => int.tryParse(kHash([pieceType, pieceId]));
}
