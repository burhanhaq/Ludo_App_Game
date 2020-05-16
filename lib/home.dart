import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'column_area.dart';
import 'constants.dart';
import 'piece_home.dart';
import 'game_state.dart';
import 'dice.dart';
import 'triangle_painter.dart';
import 'player_piece.dart';
import 'fire_helper.dart';
import 'game_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          GamePage(),
          Row(
            children: <Widget>[
              CustomContainer(
                c: PlayerPiece.getColor(PieceType.Blue),
                selected: true,
              ),
              CustomContainer(
                c: PlayerPiece.getColor(PieceType.Red),
                selected: false,
              ),
              CustomContainer(
                c: PlayerPiece.getColor(PieceType.Green),
                selected: false,
              ),
              CustomContainer(
                c: PlayerPiece.getColor(PieceType.Yellow),
                selected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final Color c;
  final Widget child;
  bool selected;

  CustomContainer({this.c = white, this.child, @required this.selected});

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    if (widget.selected) {
      width = width * 0.85;
    } else {
      width = width * 0.05;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: width,
      height: height,
      color: widget.c,
      child: widget.child,
    );
  }
}
