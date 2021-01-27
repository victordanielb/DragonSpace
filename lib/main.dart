// https://flame-engine.org/docs/input.md

import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_base/componentes/Spaceship.dart';
import 'package:game_base/componentes/button_left.dart';
import 'package:game_base/componentes/button_rigth.dart';
import 'componentes/Bullet.dart';
import 'componentes/Dragon.dart';
import 'componentes/Smyle.dart';
import 'package:flame/gestures.dart';

const DRAGON_SIZE = 40.0;

var game;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.images.loadAll([
    'smiley.png',
    'dragon.png',
    'spaceship.png',
    'play-button_rigth.png',
    'play-button_left.png',
    'bullet.png',
    'explosion-1.png'
  ]);
  Flame.audio.load('explosion.mp3');
  var dimensions = await Flame.util.initialDimensions();

  game = JogoBase(dimensions);

  runApp(game.widget);
}

Smyle smyle;
Dragon dragon;
Spaceship spaceship;
ButtonLeft buttonLeft;
ButtonRigth buttonRigth;

bool isaAddNave = false;
bool isAddButton = false;
List<Dragon> dragonList;
List<Smyle> smyleList;
var points = 0;

class JogoBase extends BaseGame with TapDetector {
  Size dimensions;
  Random random = new Random();

  JogoBase(this.dimensions) {
    spaceship = new Spaceship(dimensions);
    buttonLeft = new ButtonLeft(dimensions);
    buttonRigth = new ButtonRigth(dimensions);
    dragonList = <Dragon>[];
    smyleList = <Smyle>[];
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  double creationTimer = 0.0;
  @override
  void update(double t) {
    if (!isaAddNave) {
      add(spaceship);
      isaAddNave = true;
    }

    creationTimer += t;
    if (creationTimer >= 0.5) {
      creationTimer = 0.0;
      int escolha = random.nextInt(2);
      print(escolha);
      if (escolha > 0) {
        smyle = new Smyle(dimensions);
        smyleList.add(smyle);
        add(smyle);
      } else {
        dragon = new Dragon(dimensions);
        dragonList.add(dragon);
        add(dragon);
      }
    }

    print('Placar: $points');

    super.update(t);
  }

  void stopMoving() {
    spaceship.direction = 0;
  }

  void movingRight() {
    spaceship.direction = 1;
  }

  void movingLeft() {
    spaceship.direction = -1;
  }

  @override
  void onTapDown(TapDownDetails details) {
    print(
        "Player tap down on ${details.globalPosition.dx} - ${details.globalPosition.dy}");
    spaceship.direction = details.globalPosition.dx;
    tapInput(details.globalPosition);
  }

  @override
  void onTapUp(TapUpDetails details) {
    print(
        "Player tap up on ${details.globalPosition.dx} - ${details.globalPosition.dy}");
  }

  void tapInput(Offset position) {
    Bullet bullet = new Bullet(dragonList, smyleList, position);
    add(bullet);
  }
}
