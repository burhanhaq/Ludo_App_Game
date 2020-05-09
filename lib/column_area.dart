import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'game_state.dart';
import 'slot.dart';

class ColumnArea extends StatefulWidget {
  final PieceType piece;
  ColumnArea({@required this.piece});

  @override
  _ColumnAreaState createState() => _ColumnAreaState();
}

class _ColumnAreaState extends State<ColumnArea> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context);
    List<Widget> rowList = [];
    switch (widget.piece) {
      case PieceType.Red:
        rowList = [
          Column(
            children: gameState.redCol3,
          ),
          Column(
            children: gameState.redCol2,
          ),
          Column(
            children: gameState.redCol1,
          ),
        ];
        break;
      case PieceType.Blue:
        rowList = [
          Column(
            children: gameState.blueCol3,
          ),
          Column(
            children: gameState.blueCol2,
          ),
          Column(
            children: gameState.blueCol1,
          ),
        ];
        break;
      case PieceType.Green:
        rowList = [
          Column(
            children: gameState.greenCol3,
          ),
          Column(
            children: gameState.greenCol2,
          ),
          Column(
            children: gameState.greenCol1,
          ),
        ];
        break;
      case PieceType.Yellow:
        rowList = [
          Column(
            children: gameState.yellowCol3,
          ),
          Column(
            children: gameState.yellowCol2,
          ),
          Column(
            children: gameState.yellowCol1,
          ),
        ];
        break;
    }

    return Container(
      child: Row(
        children: rowList,
      ),
    );
  }
}
