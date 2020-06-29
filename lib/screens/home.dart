import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/column_area.dart';
import '../constants.dart';
import '../widgets/piece_home.dart';
import '../game_state.dart';
import '../widgets/dice.dart';
import '../widgets/triangle_painter.dart';
import '../models/player_piece.dart';
import '../helper/fire_helper.dart';
import 'game_page.dart';
import 'pages/page_one.dart';
import 'pages/page_two.dart';
import 'pages/page_three.dart';
import 'pages/page_four.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context)
      ..initialize(MediaQuery.of(context).size.width);
    Color backColor = grey;
    switch (gameState.curPage) {
      case 1:
        backColor = PlayerPiece.getColor(PieceType.Blue);
        break;
      case 2:
        backColor = PlayerPiece.getColor(PieceType.Red);
        break;
      case 3:
        backColor = PlayerPiece.getColor(PieceType.Green);
        break;
      case 4:
        backColor = PlayerPiece.getColor(PieceType.Yellow);
        break;
    }
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          GamePage(),
          Opacity(
            opacity: 0.98,
            child: Offstage(
              offstage: gameState.curPageOption == PageOption.StartGame,
              child: Container(
                color: gameState.curPageOption == PageOption.StartGame
                    ? trans
                    : backColor,
                child: Row(
                  children: <Widget>[
                    PageContainer(
                      c: PlayerPiece.getColor(PieceType.Blue),
                      child: PageOne(),
                      pageNum: 1,
                    ),
                    PageContainer(
                      c: PlayerPiece.getColor(PieceType.Red),
                      child: PageTwo(),
                      pageNum: 2,
                    ),
                    PageContainer(
                      c: PlayerPiece.getColor(PieceType.Green),
                      child: PageThree(),
                      pageNum: 3,
                    ),
                    PageContainer(
                      c: PlayerPiece.getColor(PieceType.Yellow),
                      child: PageFour(),
                      pageNum: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageContainer extends StatefulWidget {
  final Color c;
  final Widget child;
  int pageNum;

  PageContainer({this.c = white, this.child, @required this.pageNum});

  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer>
    with SingleTickerProviderStateMixin {
  var sizeController;
  var sizeAnimation;
  int animationSpeed = 150;

  @override
  void initState() {
    super.initState();
    sizeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationSpeed),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    bool selected = gameState.curPage == widget.pageNum;

    if (selected) {
      sizeController.forward();
      width *= kPageOpenWidthMultiplier;
      height *= 1;
    } else {
      sizeController.reverse();
      width *= kPageClosedWidthMultiplier;
      width -= 3;
      height *= 0.5;
    }
    if (gameState.curPageOption == PageOption.StartGame) {
      width = 0;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: animationSpeed),
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      decoration: BoxDecoration(
          color: widget.c, borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Offstage(
        offstage: !selected,
        child: SizeTransition(
          sizeFactor: sizeController,
          axis: Axis.horizontal,
          axisAlignment: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
//                color: Colors.black.withOpacity(0.05),
                child: widget.child,
              ),
              if (widget.pageNum != 1)
                GestureDetector(
                  onTap: () {
                    gameState.pageBack();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black45,
                    size: 80,
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }
}
