import 'dart:async';
import 'package:flame/components.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<RabbitsChallenge> {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    position,
  }) : super(
          position: position,
        );

  final double scrollSpeed = 0.3; //if faster, dizzy

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(
        64.6); //if use new backgrounds, make sure to make them all 64x64 bits!
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollHeight = (game.size.y / tileSize).floor();
    if(position.y > scrollHeight * tileSize) position.y = -tileSize;
    super.update(dt);
  }
}
