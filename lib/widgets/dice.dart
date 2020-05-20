import 'package:flutter/material.dart';

import '../constants.dart';

class Dice extends StatefulWidget {
  double size;
  Color c;
  int num;

  Dice({this.size = 50, this.c = white, this.num = 2}) {
    if (this.num < 1 || this.num > 6) {
      this.num = 3;
    }
  }

  @override
  _DiceState createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  @override
  Widget build(BuildContext context) {
    List<Widget> diceList = [
      One(size: widget.size, c: widget.c, num: ''),
      Two(size: widget.size, c: widget.c, num: ''),
      Three(size: widget.size, c: widget.c, num: ''),
      Four(size: widget.size, c: widget.c, num: ''),
      Five(size: widget.size, c: widget.c, num: ''),
      Six(size: widget.size, c: widget.c, num: ''),
    ];
//    print(widget.num);
    return Container(
      height: widget.size,
      width: widget.size,
//      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(widget.size / 7)),
        border: Border.all(
          color: widget.c,
          width: 5.0,
        ),
      ),
      child: diceList[widget.num - 1],
    );
  }
}

class One extends StatelessWidget {
  final String num;
  final double size;
  final Color c;

  One({this.num, this.size, this.c});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Icon(
          Icons.fiber_manual_record,
          color: c,
          size: size / 2.5,
        ),
        Text(num.toString(), style: kStyle),
      ],
    );
  }
}

class Two extends StatelessWidget {
  final String num;
  final double size;
  final Color c;

  Two({this.num, this.size, this.c});

  @override
  Widget build(BuildContext context) {
    double offsetVal = size / 15;
    double newSize = size / 4;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          bottom: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Text(num.toString(), style: kStyle),
      ],
    );
  }
}

class Three extends StatelessWidget {
  final String num;
  final double size;
  final Color c;

  Three({this.num, this.size, this.c});

  @override
  Widget build(BuildContext context) {
    double offsetVal = size / 15;
    double newSize = size / 4.5;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Icon(
          Icons.fiber_manual_record,
          color: c,
          size: newSize,
        ),
        Positioned(
          bottom: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Text(num.toString(), style: kStyle),
      ],
    );
  }
}

class Four extends StatelessWidget {
  final String num;
  final double size;
  final Color c;

  Four({this.num, this.size, this.c});

  @override
  Widget build(BuildContext context) {
    double offsetVal = size / 15;
    double newSize = size / 4.5;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          top: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          bottom: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          bottom: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Text(num.toString(), style: kStyle),
      ],
    );
  }
}

class Five extends StatelessWidget {
  final String num;
  final double size;
  final Color c;

  Five({this.num, this.size, this.c});

  @override
  Widget build(BuildContext context) {
    double offsetVal = size / 15;
    double newSize = size / 4.5;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          top: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Icon(
          Icons.fiber_manual_record,
          color: c,
          size: newSize,
        ),
        Positioned(
          bottom: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          bottom: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Text(num.toString(), style: kStyle),
      ],
    );
  }
}

class Six extends StatelessWidget {
  final String num;
  final double size;
  final Color c;

  Six({this.num, this.size, this.c});

  @override
  Widget build(BuildContext context) {
    double offsetVal = size / 15;
    double newSize = size / 4.5;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          top: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          bottom: offsetVal,
          right: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Positioned(
          bottom: offsetVal,
          left: offsetVal,
          child: Icon(
            Icons.fiber_manual_record,
            color: c,
            size: newSize,
          ),
        ),
        Text(num.toString(), style: kStyle),
      ],
    );
  }
}
