import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tcc_rabbits_challenge/components/custom_hitbox.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<RabbitsChallenge>, CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = 'Apple',
    super.position,
    super.size,
  });

  bool _collected = false;
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    //fruit hitbox
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    priority = -1;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      _collected = true;
    }
    Future.delayed(const Duration(milliseconds: 400), () => removeFromParent());
  }
}