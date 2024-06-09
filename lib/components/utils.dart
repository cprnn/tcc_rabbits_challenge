bool checkCollision(player, block) {
//TODO: if possible, refactorate this code here

  final hitBox = player.hitbox;
  final playerX = player.position.x + hitBox.offsetX;
  final playerY = player.position.y + hitBox.offsetY;
  final playerWidth = hitBox.width;
  final playerHeight = hitBox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0 ? playerX - (hitBox.offsetX * 2) - playerWidth : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight && //bottom of the block
      fixedY + playerHeight > blockY && //bottom of the player
      fixedX < blockX + blockWidth && //left of the player
      fixedX + playerWidth > blockX); //right of the player
}
