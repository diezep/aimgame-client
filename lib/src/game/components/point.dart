import 'package:flutter/cupertino.dart';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flutter/material.dart';

class Point extends PositionComponent with Tapable {
  String hitCode;

  double radius = 30;
  static const double SPEED = 8;
  bool removed = false;
  Function(String) callbackOnTap;
  static final Paint _white = Paint()..color = const Color(0xFFFFFFFF);

  Point(String hitCode, void Function(String) callback, {double x, double y}) {
    
    this.callbackOnTap = callback;
    this.hitCode = hitCode;
    width = height = radius;
  }

  @override
  void render(Canvas c) {
    // c.drawRect(toRect(), _white);

    // c.drawRect(toRect(), _white);
    c.drawArc(toRect(), 0.0, 360, true, _white);
  }

  @override
  void update(double dt) {
    if (radius <= .5)
      removed = true;
    else{
      width = height = radius -= dt * SPEED;
      x += (dt * SPEED) / 2;
      y += (dt * SPEED) / 2;
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownDetails details) {

    removed = true;
    callbackOnTap(hitCode);

    super.onTapDown(details);
  }

  @override
  void onTapUp(TapUpDetails details) {
    print('Tap up');

    removed = true;
    super.onTapUp(details);
  }

  @override
  void onTapCancel() {
    print('Tap up');
    removed = true;

    // TODO: implement onTapCancel
    super.onTapCancel();
  }

  @override
  bool destroy() => removed;
}
