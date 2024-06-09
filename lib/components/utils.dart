bool checkCollision(player, block) {
//TODO: if possible, refactorate this code here

  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < blockY + blockHeight && //bottom of the block
      playerY + playerHeight > blockY && //bottom of the player
      fixedX < blockX + blockWidth && //left of the player
      fixedX + playerWidth > blockX); //right of the player
}
