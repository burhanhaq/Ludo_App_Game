import 'package:flutter/material.dart';
import 'dart:math' as math;

const double kEndSpacing = 30.0;
const Color grey = Color(0xff343437);
const Color grey2 = Color(0xff1F1F21);
const Color yellow = Color(0xffF7CE47);
const Color yellow2 = Color(0xffE2BD42);
const Color red1 = Color(0xffA83535);
const Color red12 = Color(0xff872929);
const Color red2 = Color(0xff610404);
const Color red3 = Color(0xff400303);
const Color blue = Colors.blue;
const Color white = Colors.white;
const Color green = Colors.green;
const Color trans = Colors.transparent;
const Color pink = Color(0xff85203b);
const Color orange = Color(0xffff9f68);

const kBoxWidth = 25.0;
const kBoxBorderWidth = 1.0;
const kHomeWidth = 160.0;
const kPieceSize = 20.0;
const kHomePieceOffset = 25.0;

enum PieceType { Green, Blue, Red, Yellow }

const kPieceHomeLocation = 0;

const kStyle = TextStyle(
    fontSize: 15, color: Colors.black, decoration: TextDecoration.none);

const kSmallDiceSize = 40.0;
const kNumPlayerPieces = 4;
const kSelectedIconSize = 20.0;

const kEndLocation = 106;
const kOneLocation = 101;
const kTwoLocation = 102;
const kThreeLocation = 103;
const kFourLocation = 104;
const kFiveLocation = 105;

const kMaxDiceNum = 6;
const kSix = 6;

const kGreenHomeLocation = 9;
const kBlueHomeLocation = 22;
const kRedHomeLocation = 35;
const kYellowHomeLocation = 48;

// ----------------------------------------------------------------------------- Page Content

const kPageContentStyle = TextStyle(
    fontSize: 22, color: Colors.black, decoration: TextDecoration.none);
const kPageFourStyle = TextStyle(
    fontSize: 22, color: Colors.white, decoration: TextDecoration.none);
const kHeightMultiplier = 0.8;

enum PageOption {
  None,
  CreateUsername,
  SignIn,
  CreateRoom,
  JoinRoom,
  InsideRoom,
  StartGame
}

const kPageOpenWidthMultiplier = 0.85;
const kPageClosedWidthMultiplier = 0.05;

String kHash(element) {
  element = element.toString().toLowerCase();
  if (element.length < 1) return '-1';
  int multiplier = 31;
  int hash = 0;
  for (int i = 0; i < element.length; i++) {
    hash += math.pow(element.codeUnitAt(i), (element.length - i));
    print('$hash >');
    if (hash.abs() > math.pow(10, 10)) {
      if (hash < 0) hash *= -1;
      hash ~/= (math.pow(10, 5));
    }
    print('$hash <');
  }
  hash *= multiplier;
  print('$hash <<<<');
  String str = hash.toString();
return str;
//  return str.length > 10 ? str.substring(str.length - 10) : str;
}
