import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../widgets/column_area.dart';
import '../constants.dart';
import '../widgets/piece_home.dart';
import '../game_state.dart';
import '../widgets/dice.dart';
import '../widgets/triangle_painter.dart';
import '../models/player_piece.dart';
import '../helper/fire_helper.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final middleAreaSize = (kBoxWidth + kBoxBorderWidth * 2) * 3;

  void listenToList() {
//    Fire.instance.listenForNewEverything().listen((data) {
//      var updated = data;
//      if (updated != null && updated.length > 0) {
//        print(updated);
//      }
//    });
  }

  List<Color> selectedDiceList;
  List<Widget> diceMovesList;

  generateSelectedDiceList(GameState gameState) {
    selectedDiceList = List.generate(gameState.movesList.length, (i) {
      if (i == gameState.selectedDiceIndex) return white;
      return trans;
    });
  }

  generateDiceMovesList(GameState gameState, Color c) {
    if (gameState.selectedDiceIndex > gameState.movesList.length - 1) {
      gameState.selectedDiceIndex = 0;
    }
    diceMovesList = List.generate(
      gameState.movesList.length,
      (index) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.crop_free,
            color: selectedDiceList[index],
            size: kSmallDiceSize + kSelectedIconSize,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                gameState.selectedDiceIndex = index;
              });
            },
            child: Dice(
              size: kSmallDiceSize,
              c: c,
              num: gameState.movesList[index],
            ),
          ),
        ],
      ),
    );
  }

  getRowChild(GameState gameState, PieceType pt) {
    List<PlayerPiece> completedPiecesList = gameState
        .getPlayerPieceList(pt)
        .where((element) => element.isRunComplete())
        .toList();

    int rowLength = completedPiecesList.length;
    var topPiece = Container();
    if (completedPiecesList.length == 4) {
      --rowLength;
      topPiece = Container(child: completedPiecesList.last.container);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        topPiece,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            rowLength,
            (index) => Container(child: completedPiecesList[index].container),
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of<GameState>(context);

    Fire.instance.gameStream(gameState.gameID).listen((event) {
      if (event.exists) {
        String movesString = event.data[Fire.MOVES_LIST];
        List<int> movesList = GameState.stringToIntList(movesString);
//        if (!listEquals(gameState.movesList, movesList)) {
//          gameState.movesList = movesList;
//          print(movesString);
//        }
      }
    });



    Color stateColor = PlayerPiece.getColor(gameState.getTurn());
    generateSelectedDiceList(gameState);
    generateDiceMovesList(gameState, stateColor);
    return SafeArea(
      child: Container(
        color: grey,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (kBoxWidth) * 15,
            maxWidth: (kBoxWidth) * 15,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              SizedBox(
                height: (kBoxWidth + kBoxBorderWidth * 2) * 15,
                width: (kBoxWidth + kBoxBorderWidth * 2) * 15,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: PieceHome(PieceType.Blue),
                    ),
                    Positioned(
                      top: 0,
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: ColumnArea(piece: PieceType.Red),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: PieceHome(PieceType.Red),
                    ),
                    Positioned(
                      left: 0,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: ColumnArea(piece: PieceType.Blue),
                      ),
                    ),
                    SizedBox(
                      height: middleAreaSize,
                      width: middleAreaSize,
                      child: CustomPaint(
                        size: Size(middleAreaSize, middleAreaSize),
                        painter: TrianglePainter(
                            c: PlayerPiece.getColor(PieceType.Green)),
                        child: getRowChild(gameState, PieceType.Green),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: SizedBox(
                        height: middleAreaSize,
                        width: middleAreaSize,
                        child: CustomPaint(
                          size: Size(middleAreaSize, middleAreaSize),
                          painter: TrianglePainter(
                              c: PlayerPiece.getColor(PieceType.Blue)),
                          child: getRowChild(gameState, PieceType.Blue),
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 2,
                      child: SizedBox(
                        height: middleAreaSize,
                        width: middleAreaSize,
                        child: CustomPaint(
                          size: Size(middleAreaSize, middleAreaSize),
                          painter: TrianglePainter(
                              c: PlayerPiece.getColor(PieceType.Red)),
                          child: getRowChild(gameState, PieceType.Red),
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
                        height: middleAreaSize,
                        width: middleAreaSize,
                        child: CustomPaint(
                          size: Size(middleAreaSize, middleAreaSize),
                          painter: TrianglePainter(
                              c: PlayerPiece.getColor(PieceType.Yellow)),
                          child: getRowChild(gameState, PieceType.Yellow),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: ColumnArea(piece: PieceType.Yellow),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: PieceHome(PieceType.Green),
                    ),
                    Positioned(
                      bottom: 0,
                      child: RotatedBox(
                        quarterTurns: 0,
                        child: ColumnArea(piece: PieceType.Green),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: PieceHome(PieceType.Yellow),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: kSmallDiceSize + kSelectedIconSize,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: diceMovesList,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: gameState.diceTap,
                child: Dice(
                    size: 100, c: stateColor, num: gameState.lastMoveOnDice),
              ),
//              GestureDetector(
//                onTap: Fire.instance.run,
//                child: Container(
//                  color: blue,
//                  height: 200,
//                  width: 200,
//                  child: StreamBuilder(
//                    stream: Fire.instance.gameStream('1589373131638'),
//                    builder: (BuildContext context,
//                        AsyncSnapshot<DocumentSnapshot> snapshot) {
//                      if (snapshot.hasData) {
//                        var x = snapshot.data.data['moves_list'];
//                        return ListView(
//                          children: [Text(x)],
//                        );
//                      }
//                      return Text('nothing to show');
//                    },
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
