interface GameObject {
  UUID getUUID();
  PVector getRealPos();
  Game getGameInstance();
  
}

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
  
  // ---------------------------------
  void update() {
    if (isOver()) { return; }
    
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
  
  // ------------- GETTER ------------------
  
  
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
  
  GameObject[] getGameObjects() {
    ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
    for (TribeInterface tribe : tribes) {
      for (UnitInterface unit : tribe.getUnits()) {
        gameObjects.add(unit);
      }
    }
    return gameObjects.toArray(new GameObject[gameObjects.size()]);
  }
}
