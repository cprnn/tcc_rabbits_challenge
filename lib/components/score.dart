class Score {
  int fruitsCollected = 0;

  void incrementFruitsCollected() {
    fruitsCollected++;
  }

  int getFruitsCollected() {
    return fruitsCollected;
  }

  void resetScore() {
    fruitsCollected = 0;
  }
}
