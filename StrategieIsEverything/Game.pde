class Game {
  Tribe[] tribes;
  GameField map;
  
  // ----------- PREFERENCES ------------------
  PVector unitSize;
  
  Game(Tribe[] tribes, GameField gameField, PVector unitSize) {
    this.tribes = tribes;
    this.map = gameField;
    this.unitSize = unitSize;
  }
  
  void init() {
    for (Tribe tribe : tribes) {
      tribe.setGameInstance(this); 
    }
  }
  
  boolean isOver() {
    int aliveCounter = 0;
    for (Tribe tribe : tribes) {
      if (!tribe.dead) { aliveCounter++; } 
    }
    if (aliveCounter <= 1) {
      return true; 
    } else {
      return false; 
    }
  }
  
  // ---------------------------------
  void update() {
    for (Tribe tribe : tribes) {
      tribe.update(); 
    }
  }
  
  void show() {
    map.show();
    for (Tribe tribe : tribes) {
      tribe.show(); 
    }
  }
}
