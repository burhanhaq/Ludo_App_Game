import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'column_area.dart';
import 'constants.dart';
import 'slot.dart';
import 'custom_box.dart';
import 'player_piece.dart';

class GameState extends ChangeNotifier {
//  int _sheesh = 0;
//
//  get sheesh => _sheesh;
//
//  set sheesh(int sh) {
//    _sheesh = sh;
//    notifyListeners();
//  }

  List<Slot> slotList = List.generate(13 * 4, (index) => Slot(id: index + 1));
  List<Slot> redEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));
  List<Slot> blueEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));
  List<Slot> yellowEndList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));
  List<Slot> greenGreenList =
      List.generate(6, (index) => Slot(id: index + 1, isEnd: true));

  setStop(int id) {
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
    return greenGreenList[id - 1];
  }

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

  List<Widget> _redColumn1 = [];
  List<Widget> _redColumn2 = [];
  List<Widget> _redColumn3 = [];

  List<Widget> _yellowColumn1 = [];
  List<Widget> _yellowColumn2 = [];
  List<Widget> _yellowColumn3 = [];

  List<Widget> _greenColumn1 = [];
  List<Widget> _greenColumn2 = [];
  List<Widget> _greenColumn3 = [];

  List<Widget> _blueColumn1 = [];
  List<Widget> _blueColumn2 = [];
  List<Widget> _blueColumn3 = [];

  updateColDate(PieceType piece) {
//    sheesh += 1;
    switch (piece) {
      case PieceType.Red:
//        addPlayerPiece(2);
        break;
      case PieceType.Blue:
        break;
      case PieceType.Green:
        break;
      case PieceType.Yellow:
        break;
    }
    notifyListeners();
  }

  initialize() {
    initColumn();
    // 1 - 13 green
    setStop(4);
    setStop(9);
    // 14 - 26 blue
    setStop(17);
    setStop(22);
    // 27 - 39 red
    setStop(30);
    setStop(35);
    // 40 - 52 yellow
    setStop(43);
    setStop(48);
  }

  List<PlayerPiece> redPlayerPieces = List.generate(
    4,
    (index) => PlayerPiece(
      pieceId: index,
      pieceType: PieceType.Red,
    ),
  );
  List<PlayerPiece> bluePlayerPieces = List.generate(
    4,
    (index) => PlayerPiece(
      pieceId: index,
      pieceType: PieceType.Blue,
    ),
  );
  List<PlayerPiece> yellowPlayerPieces = List.generate(
    4,
    (index) => PlayerPiece(
      pieceId: index,
      pieceType: PieceType.Yellow,
    ),
  );
  List<PlayerPiece> greenPlayerPieces = List.generate(
    4,
    (index) => PlayerPiece(
      pieceId: index,
      pieceType: PieceType.Green,
    ),
  );

  List<PieceType> pieceTurn = [
    PieceType.Green,
    PieceType.Blue,
    PieceType.Red,
    PieceType.Yellow
  ];

  PieceType getTurn() {
    return pieceTurn[0];
  }

  playTurn() {}

  bool canDelete(PlayerPiece topPiece, int slotId) {
    if (getSlot(slotId).isStop) return false;
    var pieceList = getSlot(slotId).playerPieceList;
    if (pieceList.length == 0) return false;
    int playerPieceCount = 0;
    int otherPieceCount = 0;
    for (int i = 0; i < pieceList.length; i++) {
      if (pieceList[i].pieceType == topPiece.pieceType) {
        ++playerPieceCount;
      } else {
        ++otherPieceCount;
      }
    }
    if (playerPieceCount >= otherPieceCount) {
      print('hahahah');
//      print(topPiece);
//      deletePiece(topPiece, slotId);
    }
    return playerPieceCount >= otherPieceCount;
  }

  deleteBottomPiece(int slotId) {
    var pieceList = getSlot(slotId).playerPieceList;
    PlayerPiece topPiece = pieceList.last;
//    print('before');
//    print(list);
    getSlot(slotId)
        .playerPieceList
        .removeWhere((element) => element.pieceType != topPiece.pieceType);
//    print('after');
//    print(list);
    notifyListeners();
  }

  PlayerPiece addPiece(PieceType pt) {
    PlayerPiece pp;
    Iterable<PlayerPiece> availablePieces;
    int homePosition;
    switch (pt) {
      case PieceType.Green: // 9
        availablePieces = greenPlayerPieces
            .where((element) => element.location == kHomeLocation);
        homePosition = 9;
        break;
      case PieceType.Blue: // 22
        availablePieces = bluePlayerPieces
            .where((element) => element.location == kHomeLocation);
        homePosition = 22;
        break;
      case PieceType.Red: // 35
        availablePieces = redPlayerPieces
            .where((element) => element.location == kHomeLocation);
        homePosition = 35;
        break;
      case PieceType.Yellow: // 48
        availablePieces = yellowPlayerPieces
            .where((element) => element.location == kHomeLocation);
        homePosition = 48;
        break;
    }
    if (availablePieces.length > 0) {
      if (availablePieces.length > 0) {
        pp = availablePieces.first;
        pp.location = homePosition;
        getSlot(homePosition).playerPieceList.add(pp);
      }
    } else {
      print('AddPiece() No available pieces found');
    }
    notifyListeners();
    return pp;
  }

  movePiece(PlayerPiece pp, int moveDistance) {
    int curLocation = pp.location;
    int newLocation = curLocation + moveDistance;
    if (newLocation > 52) {
      newLocation -= 52;
    }
    pp.location = newLocation;
    getSlot(curLocation).playerPieceList.removeLast();
    getSlot(newLocation).playerPieceList.add(pp);
    notifyListeners();
  }

  int throwDice() {
    return math.Random().nextInt(6) + 1;
  }

  initColumn() {
    _redColumn1 = [
      CustomBox(getSlot(27)),
      CustomBox(getSlot(28)),
      CustomBox(getSlot(29)),
      CustomBox(getSlot(30), c: red1),
      CustomBox(getSlot(31)),
      CustomBox(getSlot(32)),
    ];
    _redColumn2 = [
      CustomBox(getRedEndSlot(5), c: red1),
      CustomBox(getRedEndSlot(4), c: red1),
      CustomBox(getRedEndSlot(3), c: red1),
      CustomBox(getRedEndSlot(2), c: red1),
      CustomBox(getRedEndSlot(1), c: red1),
      CustomBox(getSlot(33)),
    ];
    _redColumn3 = [
      CustomBox(getSlot(39)),
      CustomBox(getSlot(38)),
      CustomBox(getSlot(37)),
      CustomBox(getSlot(36)),
      CustomBox(getSlot(35), c: red1),
      CustomBox(getSlot(34)),
    ];
    _yellowColumn1 = [
      CustomBox(getSlot(40)),
      CustomBox(getSlot(41)),
      CustomBox(getSlot(42)),
      CustomBox(getSlot(43), c: yellow),
      CustomBox(getSlot(44)),
      CustomBox(getSlot(45)),
    ];
    _yellowColumn2 = [
      CustomBox(getRedEndSlot(5), c: yellow),
      CustomBox(getRedEndSlot(4), c: yellow),
      CustomBox(getRedEndSlot(3), c: yellow),
      CustomBox(getRedEndSlot(2), c: yellow),
      CustomBox(getRedEndSlot(1), c: yellow),
      CustomBox(getSlot(46)),
    ];
    _yellowColumn3 = [
      CustomBox(getSlot(52)),
      CustomBox(getSlot(51)),
      CustomBox(getSlot(50)),
      CustomBox(getSlot(49)),
      CustomBox(getSlot(48), c: yellow),
      CustomBox(getSlot(47)),
    ];

    _greenColumn1 = [
      CustomBox(getSlot(1)),
      CustomBox(getSlot(2)),
      CustomBox(getSlot(3)),
      CustomBox(getSlot(4), c: green),
      CustomBox(getSlot(5)),
      CustomBox(getSlot(6)),
    ];
    _greenColumn2 = [
      CustomBox(getRedEndSlot(5), c: green),
      CustomBox(getRedEndSlot(4), c: green),
      CustomBox(getRedEndSlot(3), c: green),
      CustomBox(getRedEndSlot(2), c: green),
      CustomBox(getRedEndSlot(1), c: green),
      CustomBox(getSlot(7)),
    ];
    _greenColumn3 = [
      CustomBox(getSlot(13)),
      CustomBox(getSlot(12)),
      CustomBox(getSlot(11)),
      CustomBox(getSlot(10)),
      CustomBox(getSlot(9), c: green),
      CustomBox(getSlot(8)),
    ];

    _blueColumn1 = [
      CustomBox(getSlot(14)),
      CustomBox(getSlot(15)),
      CustomBox(getSlot(16)),
      CustomBox(getSlot(17), c: blue),
      CustomBox(getSlot(18)),
      CustomBox(getSlot(19)),
    ];
    _blueColumn2 = [
      CustomBox(getRedEndSlot(5), c: blue),
      CustomBox(getRedEndSlot(4), c: blue),
      CustomBox(getRedEndSlot(3), c: blue),
      CustomBox(getRedEndSlot(2), c: blue),
      CustomBox(getRedEndSlot(1), c: blue),
      CustomBox(getSlot(20)),
    ];
    _blueColumn3 = [
      CustomBox(getSlot(26)),
      CustomBox(getSlot(25)),
      CustomBox(getSlot(24)),
      CustomBox(getSlot(23)),
      CustomBox(getSlot(22), c: blue),
      CustomBox(getSlot(21)),
    ];
  }
}
