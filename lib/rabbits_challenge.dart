import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:tcc_rabbits_challenge/components/player.dart';
import 'package:tcc_rabbits_challenge/components/level.dart';
import 'dart:js';

class RabbitsChallenge extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Smoke');
  late JoystickComponent joystick;
  bool showJoystick = false;
  bool playSounds =
      true; //TODO: turn it off when coding if debugging in Windows
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-01',
    'Level-03',
    'Level-02', //TODO: add here all the levels
  ];
  int currentLevelIndex = 0;
  Level? currentLevel;

  @override
  FutureOr<void> onLoad() async {
    //loading all images to cache
    await images.loadAllImages();

    _loadLevel();

    // if (showJoystick) {
    //    addJoystick();
    // }
    return super.onLoad();
  }

//joystick
/*
  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
*/

//Functions that control the level system, add loading screens and control access by the
//home buttons and between levels, on a loading/continue screen

  void loadNextLevel() {
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      //no more levels TODO: make it go to home screen, not the first level
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      // TODO: on this delay, add a loading screen
      // Create a new Level instance and assign it to currentLevel
      currentLevel = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      // Create a camera component with fixed resolution
      cam = CameraComponent.withFixedResolution(
        world: currentLevel!,
        width: 480,
        height: 560,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      // Add the camera and the current level to the game
      addAll([cam, currentLevel!]);
    });
  }

  void clearBlocklyWorkspace() {
    context['Blockly'].callMethod('getMainWorkspace').callMethod('clear');
    player.resetPosition();
    currentLevel?.resetFruits();
  }
}
