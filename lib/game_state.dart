import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'column_area.dart';
import 'constants.dart';
import 'slot.dart';
import 'custom_box.dart';
import 'player_piece.dart';
import 'fire_helper.dart';

class GameState extends ChangeNotifier {
  List<Slot> slotList = List.generate(13 * 4, (index) => Slot(id: index + 1));
  List<int> movesList = [];
  bool extraThrowToken = false;
  List<PieceType> pieceTurn = [];
  List<PieceType> winnerList = [];
  int selectedDiceIndex = 0;
  int _lastMove = 1;
  bool gameOver = false;

  get lastMoveOnDice => _lastMove;

  set lastMoveOnDice(int val) {
    _lastMove = val;
    notifyListeners();
  }

  _setHomeStop(int id) {
    slotList[id - 1].isHomeStop = true;
  }

  _setOtherStop(int id) {
    slotList[id - 1].isOtherStop = true;
  }

  Slot getSlot(int id) {
    return slotList[id - 1];
  }

  Slot getEndSlot(PieceType pt, int id) {
    switch (pt) {
      case PieceType.Green:
        return greenEndList[id - 1];
      case PieceType.Blue:
        return blueEndList[id - 1];
      case PieceType.Red:
        return redEndList[id - 1];
      case PieceType.Yellow:
        return yellowEndList[id - 1];
    }
    return null;
  }

  setTurnsForPlayers(int playerNum) {
    switch (playerNum) {
      case 2:
        pieceTurn = [PieceType.Green, PieceType.Red];
        break;
      case 3:
        pieceTurn = [PieceType.Green, PieceType.Blue, PieceType.Red];
        break;
      case 4:
        pieceTurn = [
          PieceType.Green,
          PieceType.Blue,
          PieceType.Red,
          PieceType.Yellow
        ];
        break;
    }
  }

  setPieceOnSlot(PlayerPiece pp, int id) {
    pp.location = id;
    getSlot(id).playerPieceList.add(pp);
    notifyListeners();
  }

  setPieceOnEndSlot(PlayerPiece pp, int id) {
    pp.location = id;
    pp.isAtEndColumn = true;
    getEndSlot(pp.pieceType, id).playerPieceList.add(pp);
    notifyListeners();
  }

  setPieceWon(PlayerPiece pp) {
    pp.location = 6;
    pp.isAtEndColumn = true;
  }

  initialize() {
    setTurnsForPlayers(4);

    generatePlayerPieces();
    initColumn();
    // 1 - 13 green
    _setOtherStop(4);
    _setHomeStop(9);
    // 14 - 26 blue
    _setOtherStop(17);
    _setHomeStop(22);
    // 27 - 39 red
    _setOtherStop(30);
    _setHomeStop(35);
    // 40 - 52 yellow
    _setOtherStop(43);
    _setHomeStop(48);

//    setPieceOnSlot(greenPlayerPieces[0], 7);
//    setPieceOnSlot(bluePlayerPieces[0], 20);
//    setPieceOnSlot(yellowPlayerPieces[0], 46);
//    setPieceOnSlot(redPlayerPieces[0], 33);
//    setPieceOnSlot(greenPlayerPieces[1], 7);
//    setPieceOnSlot(bluePlayerPieces[1], 20);
//    setPieceOnSlot(yellowPlayerPieces[1], 46);
//    setPieceOnSlot(redPlayerPieces[1], 33);
//    setPieceOnSlot(greenPlayerPieces[2], 7);
//    setPieceOnSlot(bluePlayerPieces[2], 20);
//    setPieceOnSlot(yellowPlayerPieces[2], 46);
//    setPieceOnSlot(redPlayerPieces[2], 33);
//    setPieceOnSlot(greenPlayerPieces[3], 7);
//    setPieceOnSlot(bluePlayerPieces[3], 20);
//    setPieceOnSlot(yellowPlayerPieces[3], 46);
//    setPieceOnSlot(redPlayerPieces[3], 33);

//    setPieceOnEndSlot(greenPlayerPieces[0], 4);
//    setPieceOnEndSlot(bluePlayerPieces[0], 4);
//    setPieceOnEndSlot(yellowPlayerPieces[0], 4);
//    setPieceOnEndSlot(redPlayerPieces[0], 4);
//    setPieceWon(greenPlayerPieces[1]);
//    setPieceWon(greenPlayerPieces[2]);
//    setPieceWon(greenPlayerPieces[3]);
//    setPieceWon(bluePlayerPieces[1]);
//    setPieceWon(bluePlayerPieces[2]);
//    setPieceWon(bluePlayerPieces[3]);
//    setPieceWon(redPlayerPieces[1]);
//    setPieceWon(redPlayerPieces[2]);
//    setPieceWon(redPlayerPieces[3]);
//    setPieceWon(yellowPlayerPieces[1]);
//    setPieceWon(yellowPlayerPieces[2]);
//    setPieceWon(yellowPlayerPieces[3]);
  }

  PieceType getTurn() {
    return pieceTurn[0];
  }

  pieceTap(PlayerPiece pp) {
    if (gameOver) return;
    print('Tapped Slot');
    print('index: $selectedDiceIndex');
    if (pp == null) return;
    if (canThrowDice()) return;
    if (pp.pieceType == getTurn()) {
      if (movesList.length > 0) {
        if (pp.location == 0) {
          if (movesList.contains(6)) {
            addPiece(pp);
          }
        } else {
          movePiece(pp, movesList[selectedDiceIndex]);
        }
      } else {
        print('No moves available. Tap Dice for moves');
      }
    } else {
      print('Please wait your turn sir');
    }
  }

  canAnyPieceMove(PieceType pt) {
    if (gameOver) return false;
    if (extraThrowToken) return true;
    if (movesList.isEmpty) return false;
    List<PlayerPiece> list;
    switch (pt) {
      case PieceType.Green:
        list = greenPlayerPieces;
        break;
      case PieceType.Blue:
        list = bluePlayerPieces;
        break;
      case PieceType.Red:
        list = redPlayerPieces;
        break;
      case PieceType.Yellow:
        list = yellowPlayerPieces;
        break;
    }

//    if (didPlayerWin(pt)) return false; // todo needed?

    if (movesList.contains(6) && list.any((element) => element.isAtHome())) {
      // can move 6 and some piece at home
      return true;
    }

    bool anyPieceCanMove = list.any((element) =>
            !element.isAtHome() && // some piece not at home and
            !element.isRunComplete() && // some piece run not complete and
            (element.isAtEndColumn && // (some piece at end column and
                    movesList.any((move) =>
                        move <=
                        kMaxLoc -
                            element
                                .location) || // any move <= kMaxLoc - location) or
                !element.isAtEndColumn) // some piece not at end column
        );

    return anyPieceCanMove;
  }

  void diceTap() {
    if (gameOver) return;
    PieceType turn = getTurn();
    bool canThrow = canThrowDice();
    if (!canThrow) return;
    extraThrowToken = false;
    int diceNum = throwDice();
    movesList.add(diceNum);
    canThrow = canThrowDice();
    bool anyPieceCanMove = canAnyPieceMove(turn);
    if (!canThrow && !anyPieceCanMove) {
      print('clearing: $movesList');
      movesList.clear();
    }
    if (movesList.isEmpty) {
      changeTurn();
    }
    notifyListeners();
  }

  canThrowDice() {
    if (extraThrowToken) return true;

    if (movesList.isEmpty) return true;
    if (movesList.last != 6) return false;
    int len = movesList.length;
    if (len >= 3) {
      if (lastMoveOnDice == 6) {
        if (movesList[len - 1] == 6 && // first one is redundant
            movesList[len - 2] == 6 &&
            movesList[len - 3] == 6) {
          movesList.removeLast();
          movesList.removeLast();
          movesList.removeLast();
          notifyListeners();
          return false;
        }
      }
    }
    if (lastMoveOnDice == 6) {
      return true;
    }
    notifyListeners();
    return false;
  }

  changeTurn() {
    pieceTurn.add(pieceTurn.removeAt(0));
    movesList.clear();
  }

  bool canDelete(int slotId) {
    if (getSlot(slotId).isStop()) return false;
    var pieceList = getSlot(slotId).playerPieceList;
    if (pieceList.isEmpty) return false;
    PlayerPiece topPiece = pieceList.last;
    int playerPieceCount = 0;
    int otherPieceCount = 0;
    for (int i = 0; i < pieceList.length; i++) {
      if (pieceList[i].pieceType == topPiece.pieceType) {
        ++playerPieceCount;
      } else {
        ++otherPieceCount;
      }
    }
    if (otherPieceCount <= 0) return false;
    return playerPieceCount >= otherPieceCount;
  }

  deleteBottomPieces(int slotId) {
    extraThrowToken = true;
    var pieceList = getSlot(slotId).playerPieceList;
    PlayerPiece topPiece = pieceList.last;
    List<PlayerPiece> otherPieces = [];
    getSlot(slotId).playerPieceList.forEach((element) {
      if (element.pieceType != topPiece.pieceType) {
        otherPieces.add(element);
      }
    });
    otherPieces.forEach((element) => element.location = 0);
    getSlot(slotId)
        .playerPieceList
        .removeWhere((element) => element.pieceType != topPiece.pieceType);
    notifyListeners();
  }

  getHomePosition(PieceType pt) {
    switch (pt) {
      case PieceType.Green: // 9
        return kGreenHomeLocation;
      case PieceType.Blue: // 22
        return kBlueHomeLocation;
      case PieceType.Red: // 35
        return kRedHomeLocation;
      case PieceType.Yellow: // 48
        return kYellowHomeLocation;
    }
  }

  addPiece(PlayerPiece pp) {
//    PlayerPiece pp;
    int homePosition = getHomePosition(pp.pieceType);

//    Iterable<PlayerPiece> availablePieces = getPlayerPieceList(pt)
//        .where((element) => element.location == kPieceHomeLocation);
    if (pp.isAtHome()) {
//      pp = availablePieces.first;
      pp.location = homePosition;
      getSlot(homePosition).playerPieceList.add(pp);
      movesList.remove(6);
    } else {
      print('AddPiece() No available pieces found');
    }
    notifyListeners();
  }

  movePiece(PlayerPiece pp, int moveDistance) {
    if (pp.isAtEndColumn) {
      movePieceInEndCol(pp, moveDistance);
    } else if (checkAddToEndCol(pp, moveDistance)) {
      movePieceToEndCol(pp, moveDistance);
    } else {
      int curLocation = pp.location;
      int newLocation = curLocation + moveDistance;
      if (newLocation > 52) {
        newLocation -= 52;
      }
      pp.location = newLocation;
      getSlot(curLocation).playerPieceList.remove(pp);
      getSlot(newLocation).playerPieceList.add(pp);
      movesList.remove(moveDistance);
      selectedDiceIndex = 0;
      if (canDelete(pp.location)) {
        deleteBottomPieces(pp.location);
      }
    }
    bool anyPieceCanMove = canAnyPieceMove(pp.pieceType);
    if (!anyPieceCanMove) {
      changeTurn();
    }

    notifyListeners();
  }

  int throwDice() {
    int num = math.Random().nextInt(kMaxDiceNum) + 1;
    lastMoveOnDice = num;
    print('threw $num');
    return num;
  }

  didPlayerWin(PieceType pt) {
    return getPlayerPieceList(pt).every((element) => element.isRunComplete());
  }

  playerFinishedRun() {
    winnerList.add(getTurn());
    pieceTurn.remove(getTurn());
    if (pieceTurn.length == 1) {
      gameOver = true;
    }
  }

  movePieceInEndCol(PlayerPiece pp, int moveDistance) {
    int curLocation = pp.location;
    int newLocation = curLocation + moveDistance;

    if (newLocation > kMaxLoc) return;
    if (newLocation == kMaxLoc) {
      // todo add piece to triangle end
      // won
      extraThrowToken =
          true; // todo add this to movePieceToEndCol() if piece wins
      pp.isAtEndColumn = true;
    }
    // newLocation <= MAX_LOC
    pp.location = newLocation;
    getEndSlot(pp.pieceType, curLocation).playerPieceList.remove(pp);
    getEndSlot(pp.pieceType, newLocation).playerPieceList.add(pp);
    movesList.remove(moveDistance);
    if (didPlayerWin(pp.pieceType)) {
      playerFinishedRun();
    }
    notifyListeners();
  }

  movePieceToEndCol(PlayerPiece pp, int moveDistance) {
    pp.isAtEndColumn = true;
    int curLocation = pp.location;
    int endLocation;
    switch (pp.pieceType) {
      case PieceType.Green:
        endLocation = moveDistance - (7 - curLocation);
        break;
      case PieceType.Blue:
        endLocation = moveDistance - (20 - curLocation);
        break;
      case PieceType.Red:
        endLocation = moveDistance - (33 - curLocation);
        break;
      case PieceType.Yellow:
        endLocation = moveDistance - (46 - curLocation);
        break;
    }
    getSlot(curLocation).playerPieceList.remove(pp);
    pp.location = endLocation;
    getEndSlot(pp.pieceType, endLocation).playerPieceList.add(pp);
    movesList.remove(moveDistance);
//    if (endLocation == 6) {
//      return;
//    }
    notifyListeners();
  }

  checkAddToEndCol(PlayerPiece pp, int moveDistance) {
    int curLocation = pp.location;
    int newLocation = curLocation + moveDistance;
    switch (pp.pieceType) {
      case PieceType.Green:
        if (curLocation < 8 && newLocation >= 8) return true;
        break;
      case PieceType.Blue:
        if (curLocation < 21 && newLocation >= 21) return true;
        break;
      case PieceType.Red:
        if (curLocation < 34 && newLocation >= 34) return true;
        break;
      case PieceType.Yellow:
        if (curLocation < 47 && newLocation >= 47) return true;
        break;
    }
    return false;
  }

  getPlayerPieceList(PieceType pt) {
    switch (pt) {
      case PieceType.Green:
        return greenPlayerPieces;
      case PieceType.Blue:
        return bluePlayerPieces;
      case PieceType.Red:
        return redPlayerPieces;
      case PieceType.Yellow:
        return yellowPlayerPieces;
    }
  }

  generatePlayerPieces() {
    // todo generate only for current number of players
    greenPlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Green,
//        pieceTurn: getTurn(),
      ),
    );
    bluePlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Blue,
//        pieceTurn: getTurn(),
      ),
    );
    redPlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Red,
//        pieceTurn: getTurn(),
      ),
    );
    yellowPlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Yellow,
//        pieceTurn: getTurn(),
      ),
    );
  }

  List<PlayerPiece> redPlayerPieces = [];
  List<PlayerPiece> bluePlayerPieces = [];
  List<PlayerPiece> yellowPlayerPieces = [];
  List<PlayerPiece> greenPlayerPieces = [];

  List<Slot> redEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));
  List<Slot> blueEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));
  List<Slot> yellowEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));
  List<Slot> greenEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));

  get redCol1 => _redColumn1;

  get redCol2 => _redColumn2;

  get redCol3 => _redColumn3;

  get yellowCol1 => _yellowColumn1;

  get yellowCol2 => _yellowColumn2;

  get yellowCol3 => _yellowColumn3;

  get blueCol1 => _blueColumn1;

  get blueCol2 => _blueColumn2;

  get blueCol3 => _blueColumn3;

  get greenCol1 => _greenColumn1;

  get greenCol2 => _greenColumn2;

  get greenCol3 => _greenColumn3;

  List<Widget> _greenColumn1 = [];
  List<Widget> _greenColumn2 = [];
  List<Widget> _greenColumn3 = [];

  List<Widget> _blueColumn1 = [];
  List<Widget> _blueColumn2 = [];
  List<Widget> _blueColumn3 = [];

  List<Widget> _redColumn1 = [];
  List<Widget> _redColumn2 = [];
  List<Widget> _redColumn3 = [];

  List<Widget> _yellowColumn1 = [];
  List<Widget> _yellowColumn2 = [];
  List<Widget> _yellowColumn3 = [];

  initColumn() {
    _greenColumn1 = [
      CustomBox(getSlot(1)),
      CustomBox(getSlot(2)),
      CustomBox(getSlot(3)),
      CustomBox(getSlot(4), c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getSlot(5)),
      CustomBox(getSlot(6)),
    ];
    _greenColumn2 = [
      CustomBox(getEndSlot(PieceType.Green, 5),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, 4),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, 3),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, 2),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, 1),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getSlot(7)),
    ];
    _greenColumn3 = [
      CustomBox(getSlot(13)),
      CustomBox(getSlot(12)),
      CustomBox(getSlot(11)),
      CustomBox(getSlot(10)),
      CustomBox(getSlot(9), c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getSlot(8)),
    ];
    _blueColumn1 = [
      CustomBox(getSlot(14)),
      CustomBox(getSlot(15)),
      CustomBox(getSlot(16)),
      CustomBox(getSlot(17), c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getSlot(18)),
      CustomBox(getSlot(19)),
    ];
    _blueColumn2 = [
      CustomBox(getEndSlot(PieceType.Blue, 5),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, 4),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, 3),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, 2),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, 1),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getSlot(20)),
    ];
    _blueColumn3 = [
      CustomBox(getSlot(26)),
      CustomBox(getSlot(25)),
      CustomBox(getSlot(24)),
      CustomBox(getSlot(23)),
      CustomBox(getSlot(22), c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getSlot(21)),
    ];
    _redColumn1 = [
      CustomBox(getSlot(27)),
      CustomBox(getSlot(28)),
      CustomBox(getSlot(29)),
      CustomBox(getSlot(30), c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getSlot(31)),
      CustomBox(getSlot(32)),
    ];
    _redColumn2 = [
      CustomBox(getEndSlot(PieceType.Red, 5),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, 4),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, 3),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, 2),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, 1),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getSlot(33)),
    ];
    _redColumn3 = [
      CustomBox(getSlot(39)),
      CustomBox(getSlot(38)),
      CustomBox(getSlot(37)),
      CustomBox(getSlot(36)),
      CustomBox(getSlot(35), c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getSlot(34)),
    ];
    _yellowColumn1 = [
      CustomBox(getSlot(40)),
      CustomBox(getSlot(41)),
      CustomBox(getSlot(42)),
      CustomBox(getSlot(43), c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getSlot(44)),
      CustomBox(getSlot(45)),
    ];
    _yellowColumn2 = [
      CustomBox(getEndSlot(PieceType.Yellow, 5),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, 4),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, 3),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, 2),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, 1),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getSlot(46)),
    ];
    _yellowColumn3 = [
      CustomBox(getSlot(52)),
      CustomBox(getSlot(51)),
      CustomBox(getSlot(50)),
      CustomBox(getSlot(49)),
      CustomBox(getSlot(48), c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getSlot(47)),
    ];
  }
}
