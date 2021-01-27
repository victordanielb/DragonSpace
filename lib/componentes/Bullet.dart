import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_base/main.dart';

import 'Dragon.dart';
import 'Explosion.dart';
import 'Smyle.dart';

const ComponentSize = 30.0;
const SPEED = 150.0;

class Bullet extends SpriteComponent {
  bool explode = false;
  double direction = 0.0;
  Offset initialDirection;
  List<Dragon> dragonList = <Dragon>[];
  List<Smyle> smyleList = <Smyle>[];
  List<Bullet> bulletList = <Bullet>[];

  Bullet(this.dragonList, this.smyleList, this.initialDirection)
      : super.square(ComponentSize, 'bullet.png');

  @override
  void update(double t) {
    super.update(t);
    this.y -= t * SPEED;

    if (dragonList.isNotEmpty) {
      List<Dragon> removeDragonList = <Dragon>[];

      dragonList.forEach((dragon) {
        if (!dragon.remove) {
          bool remove = this.toRect().contains(dragon.toRect().bottomCenter) ||
              this.toRect().contains(dragon.toRect().bottomLeft) ||
              this.toRect().contains(dragon.toRect().bottomRight);
          if (remove) {
            removeDragonList.add(dragon);
            dragon.remove = true;
            points += 1;
            this.explode = true;
            game.add(new Explosion(dragon));
          }
        }
      });

      dragonList.removeWhere((element) => false);
    }
  }

  @override
  bool destroy() {
    if (explode) {
      return true;
    }
    return false;
  }

  @override
  void resize(Size size) {
    this.x = this.initialDirection.dx + 15;
    this.y = size.height - 55;
  }
}
