import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;

  // ignore: use_super_parameters
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(
          position: position,
          size: size,
        ) {
          //debugMode = true;  //TODO: do not forget to remove this
        }
}
