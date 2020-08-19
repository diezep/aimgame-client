import 'dart:async';
import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/game/base_game.dart';

import 'package:aimgame/main.dart';
import 'package:aimgame/src/game/components/point.dart';

class GameCanvas extends BaseGame with HasTapableComponents {
  static final Paint paint = Paint();
  Size screenSize;
  Timer timer;
  void generatePoint(String code, Offset porcentageOffset, void Function(String) pointCallback) async {
    Point newPoint = Point(code, pointCallback)
      ..x = porcentageOffset.dx * screenSize.width / 100
      ..y = porcentageOffset.dy * screenSize.height / 100;

    this.add(newPoint);
  }

  void removePoint(String code) => markToRemove(this
      .components
      .whereType<Point>()
      .singleWhere((p) => p.hitCode == code, orElse: () => null));

  @override
  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  void leaveRoom() {
    this.components.whereType<Point>().forEach((c) {
      markToRemove(c);
    });
  }

  @override
  void render(Canvas canvas) {
    // Change background color.
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = ColorPalette.background;
    canvas.drawRect(bgRect, bgPaint);

    super.render(canvas);
  }
}
