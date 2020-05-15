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
  bool throwDiceToken = false;
  List<PieceType> pieceTurn = [
    PieceType.Green,
    PieceType.Blue,
    PieceType.Red,
    PieceType.Yellow
  ];

  _setStop(int id) {
    slotList[id - 1].isStop = true;
  }

  Slot getSlot(int id) {
    return slotList[id - 1];
  }

  Slot getRedEndSlot(int id) {
    return redEndList[id - 1];
  }

  Slot getBlueEndSlot(int id) {
    return blueEndList[id - 1];
  }

  Slot getYellowEndSlot(int id) {
    return yellowEndList[id - 1];
  }

  Slot getGreenEndSlot(int id) {
    return greenEndList[id - 1];
  }

  setPieceOnSlot(PlayerPiece pp, int id) {
    pp.location = id;
    getSlot(id).playerPieceList.add(pp);
    notifyListeners();
  }

  setPieceOnEndSlot(PlayerPiece pp, int id) {
    pp.location = id;
    pp.isAtEndColumn = true;
    switch (pp.pieceType) {
      case PieceType.Green:
        getGreenEndSlot(id).playerPieceList.add(pp);
        break;
      case PieceType.Blue:
        getBlueEndSlot(id).playerPieceList.add(pp);
        break;
      case PieceType.Red:
        getRedEndSlot(id).playerPieceList.add(pp);
        break;
      case PieceType.Yellow:
        getYellowEndSlot(id).playerPieceList.add(pp);
        break;
    }
    notifyListeners();
  }

  initialize() {
    generatePlayerPieces();
    initColumn();
    // 1 - 13 green
    _setStop(4);
    _setStop(9);
    // 14 - 26 blue
    _setStop(17);
    _setStop(22);
    // 27 - 39 red
    _setStop(30);
    _setStop(35);
    // 40 - 52 yellow
    _setStop(43);
    _setStop(48);

    setPieceOnSlot(greenPlayerPieces[0], 6);
//    setPieceOnSlot(greenPlayerPieces[1], 10);
    setPieceOnSlot(bluePlayerPieces[0], 19);
//    setPieceOnSlot(yellowPlayerPieces[1], 22);
    setPieceOnSlot(yellowPlayerPieces[0], 45);
    setPieceOnSlot(redPlayerPieces[0], 32);
//    setPieceOnSlot(yellowPlayerPieces[0], 45);
//    setPieceOnEndSlot(greenPlayerPieces[2], 5);
//    setPieceOnEndSlot(bluePlayerPieces[2], 5);
//    setPieceOnEndSlot(redPlayerPieces[2], 5);
//    setPieceOnEndSlot(yellowPlayerPieces[2], 5);
  }

  PieceType getTurn() {
    return pieceTurn[0];
  }

  pieceTap(PlayerPiece pp) {
    print('Tapped Slot');
    if (pp == null) return;
    if (canThrowDice()) return;
    if (pp.pieceType == getTurn()) {
      if (movesList.length > 0) {
        if (pp.location == 0) {
          if (movesList.contains(6)) {
            addPiece(pp.pieceType);
          }
        } else {
          movePiece(pp, movesList[0]);
        }
      } else {
        print('No moves available. Tap Dice for moves');
      }
    } else {
      print('Please wait your turn sir');
    }
  }

  canAnyPieceMove(PieceType pt) {
    if (throwDiceToken) return true;
    if (movesList.isEmpty) return false;
    bool anyPieceCanMove;
    List list;
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

    if (movesList.contains(6) && list.any((element) => element.isAtHome())) {
      // can move 6 and some piece at home
      return true;
    }

    anyPieceCanMove = list.any((element) =>
            !element.isAtHome() && // some piece not at home and
            !element.runComplete && // some piece run not complete and
            (element.isAtEndColumn && // (some piece at end column and
                    movesList.every((move) =>
                        element.location <=
                        MAX_LOC - move) || // every move > than location) or
                !element.isAtEndColumn) // some piece not at end column
        );

    return anyPieceCanMove;
  }

  void diceTap() {
    PieceType turn = getTurn();
    bool canThrow = canThrowDice();
    throwDiceToken = false;
    if (!canThrow) return;
    int diceNum = throwDice();
    movesList.add(diceNum);
    canThrow = canThrowDice();
    bool anyPieceCanMove = canAnyPieceMove(turn);
    if (!canThrow && !movesList.contains(6) && !anyPieceCanMove) {
      print('clearing: $movesList');
      movesList.clear();
    }
    if (movesList.isEmpty) {
      changeTurn();
    }
    notifyListeners();
  }

  canThrowDice() {
    if (throwDiceToken) return true;

    if (movesList.isEmpty) return true;
    if (movesList.last != 6) return false;
    int len = movesList.length;
    if (len >= 3) {
      if (movesList[len - 1] == 6 &&
          movesList[len - 2] == 6 &&
          movesList[len - 3] == 6) {
        movesList.removeLast();
        movesList.removeLast();
        movesList.removeLast();
        notifyListeners();
        return false;
      }
    }
    notifyListeners();
    return true;
  }

  changeTurn() {
    pieceTurn.add(pieceTurn.removeAt(0));
    movesList.clear();
  }

  bool canDelete(int slotId) {
    if (getSlot(slotId).isStop) return false;
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
    throwDiceToken = true;
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

  addPiece(PieceType pt) {
    PlayerPiece pp;
    Iterable<PlayerPiece> availablePieces;
    int homePosition;
    switch (pt) {
      case PieceType.Green: // 9
        availablePieces = greenPlayerPieces;
        homePosition = 9;
        break;
      case PieceType.Blue: // 22
        availablePieces = bluePlayerPieces;
        homePosition = 22;
        break;
      case PieceType.Red: // 35
        availablePieces = redPlayerPieces;
        homePosition = 35;
        break;
      case PieceType.Yellow: // 48
        availablePieces = yellowPlayerPieces;
        homePosition = 48;
        break;
    }
    availablePieces = availablePieces
        .where((element) => element.location == kPieceHomeLocation);
    if (availablePieces.length > 0) {
      pp = availablePieces.first;
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
      if (canDelete(pp.location)) {
        deleteBottomPieces(pp.location);
      }
    }
    bool anyPieceCanMove = canAnyPieceMove(pp.pieceType);
    if (!anyPieceCanMove) {
      // !throwDiceToken &&
      changeTurn();
    }

    notifyListeners();
  }

  int throwDice() {
    int num = math.Random().nextInt(MAX_DICE_NUM) + 1;
    print('threw $num');
    return num;
  }

  movePieceInEndCol(PlayerPiece pp, int moveDistance) {
    int curLocation = pp.location;
    int newLocation = curLocation + moveDistance;
    if (newLocation == MAX_LOC) {
      // won
      throwDiceToken = true;
      pp.runComplete = true;
      pp.isAtEndColumn = false;
      pp.location = newLocation;
      switch (pp.pieceType) {
        case PieceType.Green:
          getGreenEndSlot(curLocation).playerPieceList.remove(pp);
          getGreenEndSlot(newLocation).playerPieceList.add(pp);
          break;
        case PieceType.Blue:
          getBlueEndSlot(curLocation).playerPieceList.remove(pp);
          getBlueEndSlot(newLocation).playerPieceList.add(pp);
          break;
        case PieceType.Red:
          getRedEndSlot(curLocation).playerPieceList.remove(pp);
          getRedEndSlot(newLocation).playerPieceList.add(pp);
          break;
        case PieceType.Yellow:
          getYellowEndSlot(curLocation).playerPieceList.remove(pp);
          getYellowEndSlot(newLocation).playerPieceList.add(pp);
          break;
      }
      movesList.remove(moveDistance);
    } else if (newLocation < MAX_LOC) {
      // move forward
      pp.location = newLocation;
      switch (pp.pieceType) {
        case PieceType.Green:
          getGreenEndSlot(curLocation).playerPieceList.remove(pp);
          getGreenEndSlot(newLocation).playerPieceList.add(pp);
          break;
        case PieceType.Blue:
          getBlueEndSlot(curLocation).playerPieceList.remove(pp);
          getBlueEndSlot(newLocation).playerPieceList.add(pp);
          break;
        case PieceType.Red:
          getRedEndSlot(curLocation).playerPieceList.remove(pp);
          getRedEndSlot(newLocation).playerPieceList.add(pp);
          break;
        case PieceType.Yellow:
          getYellowEndSlot(curLocation).playerPieceList.remove(pp);
          getYellowEndSlot(newLocation).playerPieceList.add(pp);
          break;
      }
      movesList.remove(moveDistance);
    } else {
      // newDistance > maxLocation, don't move forward
      // todo cancel turn if no more moves/pieces outside

    }
    notifyListeners();
  }

  movePieceToEndCol(PlayerPiece pp, int moveDistance) {
    pp.isAtEndColumn = true;
    int curLocation = pp.location;
    switch (pp.pieceType) {
      case PieceType.Green:
        int endLocation = moveDistance - (7 - curLocation);
        getSlot(curLocation).playerPieceList.remove(pp);
        pp.location = endLocation;
        getGreenEndSlot(endLocation).playerPieceList.add(pp);
        movesList.remove(moveDistance);
        break;
      case PieceType.Blue:
        int endLocation = moveDistance - (20 - curLocation);
        getSlot(curLocation).playerPieceList.remove(pp);
        pp.location = endLocation;
        getBlueEndSlot(endLocation).playerPieceList.add(pp);
        movesList.remove(moveDistance);
        break;
      case PieceType.Red:
        int endLocation = moveDistance - (33 - curLocation);
        getSlot(curLocation).playerPieceList.remove(pp);
        pp.location = endLocation;
        getRedEndSlot(endLocation).playerPieceList.add(pp);
        movesList.remove(moveDistance);
        break;
      case PieceType.Yellow:
        int endLocation = moveDistance - (46 - curLocation);
        getSlot(curLocation).playerPieceList.remove(pp);
        pp.location = endLocation;
        getYellowEndSlot(endLocation).playerPieceList.add(pp);
        movesList.remove(moveDistance);
        break;
    }
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
      CustomBox(getGreenEndSlot(5), c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getGreenEndSlot(4), c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getGreenEndSlot(3), c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getGreenEndSlot(2), c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getGreenEndSlot(1), c: PlayerPiece.getColor(PieceType.Green)),
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
      CustomBox(getBlueEndSlot(5), c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getBlueEndSlot(4), c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getBlueEndSlot(3), c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getBlueEndSlot(2), c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getBlueEndSlot(1), c: PlayerPiece.getColor(PieceType.Blue)),
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
      CustomBox(getRedEndSlot(5), c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getRedEndSlot(4), c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getRedEndSlot(3), c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getRedEndSlot(2), c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getRedEndSlot(1), c: PlayerPiece.getColor(PieceType.Red)),
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
      CustomBox(getYellowEndSlot(5), c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getYellowEndSlot(4), c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getYellowEndSlot(3), c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getYellowEndSlot(2), c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getYellowEndSlot(1), c: PlayerPiece.getColor(PieceType.Yellow)),
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
