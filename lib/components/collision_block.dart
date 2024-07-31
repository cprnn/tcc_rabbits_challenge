import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;

  // ignore: use_super_parameters
  CollisionBlock({
    super.position,
    super.size,
    this.isPlatform = false,
  }) {
    //debugMode = true;  //TODO: do not forget to remove this
  }
}
