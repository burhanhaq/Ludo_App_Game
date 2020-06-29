import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'constants.dart';
import 'widgets/slot.dart';
import 'widgets/custom_box.dart';
import 'models/player_piece.dart';
import 'helper/fire_helper.dart';
import 'models/user.dart';

class GameState extends ChangeNotifier {
  List<Slot> slotList = List.generate(13 * 4, (index) => Slot(id: index + 1));
  List<int> _movesList = [];
  bool extraThrowToken = false;
  List<PieceType> pieceTurn = [];
  List<PieceType> winnerList = [];
  int selectedDiceIndex = 0;
  int _lastMove = 1;
  bool gameOver = false;

  double _boxBorderWidth;
  double _boxWidth;
  double _homeWidth;
  double _pieceWidth;

  get boxBorderWidth => _boxBorderWidth;

  get boxWidth => _boxWidth;

  get homeWidth => _homeWidth;

  get pieceWidth => _pieceWidth;

  get movesList => _movesList;

  set movesList(List val) {
    _movesList = val;
    notifyListeners();
  }

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
    if (id < 1 || id > 52) return null;
    return slotList[id - 1];
  }

  Slot getEndSlot(PieceType pt, int id) {
    switch (pt) {
      case PieceType.Green:
        return greenEndList[id - 1 - 100];
      case PieceType.Blue:
        return blueEndList[id - 1 - 100];
      case PieceType.Red:
        return redEndList[id - 1 - 100];
      case PieceType.Yellow:
        return yellowEndList[id - 1 - 100];
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
//    pp.isAtEndColumn = true;
    getEndSlot(pp.pieceType, id).playerPieceList.add(pp);
    notifyListeners();
  }

  setPieceWon(PlayerPiece pp) {
    pp.location = 6;
//    pp.isAtEndColumn = true;
  }

  initialize(double width) {
    if (kReleaseMode) {
      _curPage = 1;
      _curPageOption = PageOption.None;
    }

    // set width ratio
    _boxBorderWidth = 1.0;
    _boxWidth = (width) / 15 - _boxBorderWidth * 3;
    _homeWidth = (width) / 15 * 6- _boxBorderWidth * 6;
    _pieceWidth = width / 16;

    setTurnsForPlayers(4);

    generatePlayerPieces(pieceWidth);
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

//    notifyListeners();
  }

  PieceType getTurn() {
    return pieceTurn[0];
  }

  pieceTap(PlayerPiece pp) async {
    if (gameOver) return;
    print('Tapped Slot');
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
        await updateFireLocationList();
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
            (element.location > 100 && // (some piece at end column and
                    movesList.any((move) =>
                        move <=
                        kEndLocation -
                            element
                                .location) || // any move <= kMaxLoc - location) or
                element.location < 100) // some piece not at end column
        );

    return anyPieceCanMove;
  }

  void addLastMoveToMovesList() {
    movesList.add(_lastMove);
    Fire.instance.updateMovesList(gameID, intListToString(movesList));
    notifyListeners();
  }

  void clearMovesList() {
    movesList.clear();
    Fire.instance.updateMovesList(gameID, '');
    notifyListeners();
  }

  void removeNumFromMovesList(int num) {
    movesList.remove(num);
    Fire.instance.updateMovesList(gameID, intListToString(movesList));
    notifyListeners();
  }

  void diceTap() {
    if (gameOver) return;
    PieceType turn = getTurn();
//    if (curPlayerPieceType != turn) return;
    bool canThrow = canThrowDice();
    if (!canThrow) return;
    extraThrowToken = false;
    throwDice();
    addLastMoveToMovesList();
    canThrow = canThrowDice();
    bool anyPieceCanMove = canAnyPieceMove(turn);
    if (!canThrow && !anyPieceCanMove) {
      print('clearing: $movesList');
      clearMovesList();
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
          removeNumFromMovesList(6);
          removeNumFromMovesList(6);
          removeNumFromMovesList(6);
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
    Fire.instance.updateTurn(gameID, pieceTurn.first);
    clearMovesList();
    notifyListeners();
  }

  // todo this only works with 4 players
  setTurn(int turn) {
    switch (turn) {
      case 0:
        pieceTurn = [
          PieceType.Green,
          PieceType.Blue,
          PieceType.Red,
          PieceType.Yellow,
        ];
        break;
      case 1:
        pieceTurn = [
          PieceType.Blue,
          PieceType.Red,
          PieceType.Yellow,
          PieceType.Green,
        ];
        break;
      case 2:
        pieceTurn = [
          PieceType.Red,
          PieceType.Yellow,
          PieceType.Green,
          PieceType.Blue,
        ];
        break;
      case 3:
        pieceTurn = [
          PieceType.Yellow,
          PieceType.Green,
          PieceType.Blue,
          PieceType.Red,
        ];
        break;
    }
    print('changed');
    notifyListeners();
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
    List<PlayerPiece> otherPieces = []; // todo reduce code
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
    int homePosition = getHomePosition(pp.pieceType);

    if (pp.isAtHome()) {
      pp.location = homePosition;
      getSlot(homePosition).playerPieceList.add(pp);
      removeNumFromMovesList(6);
    }
    notifyListeners();
  }

  movePiece(PlayerPiece pp, int moveDistance, {bool fireUpdate = false}) {
    if (pp.location > 100) {
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
      if (fireUpdate)
        return; // todo this wont work for when moving piece to/in end col because of removeNumFromMovesList()
      removeNumFromMovesList(moveDistance);
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

  movePieceInEndCol(PlayerPiece pp, int moveDistance) {
    int curLocation = pp.location;
    int newLocation = curLocation + moveDistance;

    if (newLocation > kEndLocation) return;

    // newLocation <= MAX_LOC
    pp.location = newLocation;
    getEndSlot(pp.pieceType, curLocation).playerPieceList.remove(pp);
    getEndSlot(pp.pieceType, newLocation).playerPieceList.add(pp);
    removeNumFromMovesList(moveDistance);
    if (newLocation == kEndLocation) {
      // won
      // todo add this to movePieceToEndCol() if piece wins
      pieceFinishedRun(pp);
    }
    if (didPlayerWin(pp.pieceType)) {
      playerFinishedRun();
    }
    notifyListeners();
  }

  movePieceToEndCol(PlayerPiece pp, int moveDistance) {
//    pp.isAtEndColumn = true;
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
    endLocation += 100;
    getSlot(curLocation).playerPieceList.remove(pp);
    pp.location = endLocation;
    getEndSlot(pp.pieceType, endLocation).playerPieceList.add(pp);
    removeNumFromMovesList(moveDistance);
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

  // todo simplify this please
  updateFireLocationList() async {
    List<int> greenList = [];
    List<int> blueList = [];
    List<int> redList = [];
    List<int> yellowList = [];
    greenPlayerPieces.forEach((element) => greenList.add(element.location));
    bluePlayerPieces.forEach((element) => blueList.add(element.location));
    redPlayerPieces.forEach((element) => redList.add(element.location));
    yellowPlayerPieces.forEach((element) => yellowList.add(element.location));
    String greenStr = intListToString(greenList);
    String blueStr = intListToString(blueList);
    String redStr = intListToString(redList);
    String yellowStr = intListToString(yellowList);

    await Fire.instance.gameCollection.document(gameID).updateData({
      Fire.LOCATION_LIST: [greenStr, blueStr, redStr, yellowStr],
      Fire.P1_UPDATED: true,
      Fire.P2_UPDATED: true,
      Fire.P3_UPDATED: true,
      Fire.P4_UPDATED: true,
    });
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

  pieceFinishedRun(PlayerPiece pp) {
    extraThrowToken = true;
    clearMovesList();
//    pp.isAtEndColumn = true;
  }

  List<PlayerPiece> getPlayerPieceList(PieceType pt) {
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
    return null;
  }

  generatePlayerPieces(double pieceWidth) {
    // todo generate only for current number of players
    greenPlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Green,
        pieceWidth: pieceWidth,
//        pieceTurn: getTurn(),
      ),
    );
    bluePlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Blue,
        pieceWidth: pieceWidth,
//        pieceTurn: getTurn(),
      ),
    );
    redPlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Red,
        pieceWidth: pieceWidth,
//        pieceTurn: getTurn(),
      ),
    );
    yellowPlayerPieces = List.generate(
      kNumPlayerPieces,
      (index) => PlayerPiece(
        pieceId: index,
        pieceType: PieceType.Yellow,
        pieceWidth: pieceWidth,
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
      CustomBox(getEndSlot(PieceType.Green, kFiveLocation),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, kFourLocation),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, kThreeLocation),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, kTwoLocation),
          c: PlayerPiece.getColor(PieceType.Green)),
      CustomBox(getEndSlot(PieceType.Green, kOneLocation),
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
      CustomBox(getEndSlot(PieceType.Blue, kFiveLocation),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, kFourLocation),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, kThreeLocation),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, kTwoLocation),
          c: PlayerPiece.getColor(PieceType.Blue)),
      CustomBox(getEndSlot(PieceType.Blue, kOneLocation),
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
      CustomBox(getEndSlot(PieceType.Red, kFiveLocation),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, kFourLocation),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, kThreeLocation),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, kTwoLocation),
          c: PlayerPiece.getColor(PieceType.Red)),
      CustomBox(getEndSlot(PieceType.Red, kOneLocation),
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
      CustomBox(getEndSlot(PieceType.Yellow, kFiveLocation),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, kFourLocation),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, kThreeLocation),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, kTwoLocation),
          c: PlayerPiece.getColor(PieceType.Yellow)),
      CustomBox(getEndSlot(PieceType.Yellow, kOneLocation),
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

  static intListToString(List<int> intList) {
    if (intList.isEmpty) return '';
    String str = '';
    intList.forEach((element) => str += element.toString() + ',');
    str = str.substring(0, str.length - 1);
    return str;
  }

  static stringToIntList(String s) {
    if (s == '') return <int>[];
    List<dynamic> stringArray = s.split(',');
    List<int> intList = [];
    stringArray.forEach((element) => intList.add(int.tryParse(element)));
    return intList;
  }

// ------------------------------------------------------------------------------------------- HOME PAGE
  int _curPage = 3;

  get curPage => _curPage;

  PageOption _curPageOption = PageOption.JoinRoom;

//  PageOption _curPageOption;

  get curPageOption => _curPageOption;

  pageBack() {
    if (_curPage > 1) --_curPage;
    print(_curPageOption);
    if (_curPageOption == PageOption.InsideRoom) {
      // remove user
      Fire.instance.removeUserFromRoom(
          user.name, roomName); // todo check make roomName='' ?
    }
    notifyListeners();
  }

  pageForward(PageOption po) {
    if (_curPage < 4) ++_curPage;
//    switch (po) { // todo check this
//      case PageOption.CreateUsername:
//      case PageOption.SignIn:
//        _curPage = 2;
//        break;
//      case PageOption.CreateRoom:
//      case PageOption.JoinRoom:
//        _curPage = 4;
//        break;
//      case PageOption.StartGame:
//        break;
//      case PageOption.None:
//        ++_curPage;
//        break;
//      default:
//    }
    _curPageOption = po;
    notifyListeners();
  }

  bool _startGame = false;

  get startGame => _startGame;

  set startGame(bool val) {
    _startGame = val;
    notifyListeners();
  }

// ------------------------------------------------------------------------------------ ONLINE STUFF
  User _user = User(name: 'a');

//  User _user;

  get user => _user;

  set user(User val) {
    _user = val;
    notifyListeners();
  }

  String _userName = 'a';

//  String _userName = '';

  get userName => _userName;

  set userName(String val) {
    _userName = val;
    notifyListeners();
  }

  String _roomName = '';

  get roomName => _roomName;

  set roomName(String val) {
    _roomName = val;
    notifyListeners();
  }

  String _gameID = '';

  get gameID => _gameID;

  set gameID(String val) {
    _gameID = val;
    notifyListeners();
  }

  List<dynamic> _playerNamesList = [];

  get playerNamesList => _playerNamesList;

  set playerNamesList(List val) {
    _playerNamesList = val;
    notifyListeners();
  }

  var initialPlayerPieceTypeFormation = [
    PieceType.Green,
    PieceType.Red,
    PieceType.Blue,
    PieceType.Yellow
  ];

// ------------------------------------------------------------------------------------ LOCAL STUFF
//  PieceType _curPlayerPieceType = PieceType.Green;
  PieceType _curPlayerPieceType;

  get curPlayerPieceType => _curPlayerPieceType;

  set curPlayerPieceType(PieceType val) {
    _curPlayerPieceType = val;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
