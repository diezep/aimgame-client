import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';

void main() {
  final game = MyGame();

  runApp(game.widget);
}

class TapableComponent extends PositionComponent with Tapable {

  // update and render omitted

  @override
  void onTapUp(TapUpDetails details) {
    print("tap up");
  }

  @override
  void onTapDown(TapDownDetails details) {
    print("tap down");
  }

  @override
  void onTapCancel() {
    print("tap cancel");
  }

  @override
  void render(Canvas c) {
    // TODO: implement render
  }
}

class MyGame extends BaseGame with HasTapableComponents {
  MyGame() {
    add(TapableComponent());
  }
}