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
import 'page_content.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    GameState gameState = Provider.of<GameState>(context);
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          GamePage(),
          Opacity(
            opacity: 0.98,
            child: Row(
              children: <Widget>[
                CustomContainer(
                  c: PlayerPiece.getColor(PieceType.Blue),
                  child: PageOne(),
                  pageNum: 1,
                ),
                CustomContainer(
                  c: PlayerPiece.getColor(PieceType.Red),
                  child: PageTwo(),
                  pageNum: 2,
                ),
                CustomContainer(
                  c: PlayerPiece.getColor(PieceType.Green),
                  child: PageThree(),
                  pageNum: 3,
                ),
                CustomContainer(
                  c: PlayerPiece.getColor(PieceType.Yellow),
                  child: PageFour(),
                  pageNum: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final Color c;
  final Widget child;
  int pageNum;

  CustomContainer({this.c = white, this.child, @required this.pageNum});

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer>
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
      sizeController.forward(from: 0.0);
      width *= kPageOpenWidthMultiplier;
    } else {
      sizeController.reverse();
      width *=  kPageClosedWidthMultiplier;
    }
    if (gameState.curPageOption == PageOption.StartGame) {
      width = 0;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: animationSpeed),
      width: width,
      height: height,
      color: widget.c,
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
                color: Colors.black.withOpacity(0.05),
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
