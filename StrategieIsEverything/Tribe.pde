class Tribe {
  boolean ready = false;
  boolean dead = false;
  
  Game game;
  
  ArrayList<Unit> units;
  
  Tribe() {
    units = new ArrayList<Unit>();
    
  }
  
  void setGameInstance(Game game) {
    this.game = game;
    ready = true;
  }
  
  void spawnRandomUnit() {
    int x = round(random(0, game.map.board.length - 1));
    int y = round(random(0, game.map.board[x].length - 1));
    PVector spawnPos = new PVector(x, y);
    PVector size = new PVector(1,1);
    if (random(1) < 0.01) {
      units.add(new Knight(spawnPos, size, Direction.NORTH, game));
    } else if (random(1) < 0.01) {
      units.add(new Cavalry(spawnPos, size, Direction.NORTH, game));
    }
  }
  
  // -----------------------------
  void update() {
    spawnRandomUnit();
    for (Unit unit : units) {
      switch (round(random(7))) {
        case 0: unit.move(MoveDirection.STRAIGHT);
                break;
        case 1: unit.move(MoveDirection.RIGHTHAND);
                break;
        case 2: unit.move(MoveDirection.BACK);
                break;
        case 3: unit.move(MoveDirection.LEFTHAND);
                break;
        default: break;
      }
      unit.update();
    }
  }
  
  void show() {
    for (Unit unit : units) {
      unit.show();
    }
  }
}
