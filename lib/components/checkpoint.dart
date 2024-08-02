import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tcc_rabbits_challenge/components/player.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameReference<RabbitsChallenge>, CollisionCallbacks {
  Checkpoint({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    //TODO: make this dynamic

    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(18, 32),
      size: Vector2(12, 46),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

//TODO: clean this code using methods since its the same as above,
// and see if there is a callback function to end animations on Flame

  void _reachedCheckpoint() async {
    animation = animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    await animationTicker?.completed;
    animation = animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
  }
}
