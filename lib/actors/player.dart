import 'dart:async';

import 'package:flame/components.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

enum PlayerState {
  //TODO: add more player states
  idle,
  running,
  doubleJumpAnimation,
  fallAnimation,
  jumpAnimation,
  wallJumpAnimation
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<RabbitsChallenge> {
  
  String character;
  //constructor
  Player({position, required this.character}) : super(position: position); //super extends the SpriteAnimationGroupComponent
  
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation fallAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation wallJumpAnimation;

  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

//TODO: change the image to the bunny animation
  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    doubleJumpAnimation = _spriteAnimation('Double Jump', 6);
    fallAnimation = _spriteAnimation('Fall', 1);
    jumpAnimation = _spriteAnimation('Jump', 1);
    wallJumpAnimation = _spriteAnimation('Wall Jump', 5);

    animations = {
      //list of animations, add more as implemented
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.doubleJumpAnimation: doubleJumpAnimation,
      PlayerState.fallAnimation: fallAnimation,
      PlayerState.jumpAnimation: jumpAnimation,
      PlayerState.wallJumpAnimation: wallJumpAnimation,
    };

//set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
