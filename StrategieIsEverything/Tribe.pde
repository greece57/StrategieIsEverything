interface TribeInterface {
  Unit[] getUnits();
}

class Tribe implements TribeInterface {
  color tribeColor;
  
  boolean ready = false;
  boolean dead = false;
  
  Game game;
  
  ArrayList<Unit> units;
  
  Tribe(color tribeColor) {
    this.tribeColor = tribeColor;
    
    units = new ArrayList<Unit>();
  }
  
  void setGameInstance(Game game) {
    this.game = game;
    ready = true;
  }
  
  void spawnRandomUnit(int i) {
    int x = round(random(0, game.map.board.length - 1));
    int y = round(random(0, game.map.board[x].length - 1));
    PVector spawnPos = new PVector(x, y);
    PVector size = new PVector(1,1);
    if (random(i) < 0.01) {
      units.add(new Knight(spawnPos, size, Direction.NORTH, this));
    } else if (random(i) < 0.01) {
      units.add(new Cavalry(spawnPos, size, Direction.NORTH, this));
    }
  }
  
  // -----------------------------
  void update() {
    Iterator<Unit> iter = units.iterator();
    while(iter.hasNext()) {
      Unit unit = iter.next();
      switch (round(random(20))) {
        case 0: unit.turn(MoveDirection.STRAIGHT);
                break;
        case 1: unit.turn(MoveDirection.RIGHTHAND);
                break;
        case 2: unit.turn(MoveDirection.BACK);
                break;
        case 3: unit.turn(MoveDirection.LEFTHAND);
                break;
        case 4:
        case 5:
        case 6:
        case 7: unit.move();
                break;
        case 8: //spawnRandomUnit(1);
                break;
        case 9:
        case 10:
        case 11:
        case 12: unit.shoot();
                 break;
        default: break;
      }
      unit.update();
      if (unit.isDead()) {
        iter.remove();
      }
    }
    
    if (units.isEmpty()) {
      dead = true;
    }
  }
  
  void show() {
    for (Unit unit : units) {
      unit.show();
    }
  }
  
  // ----------- GETTER ----------------
  
  Unit[] getUnits() {
    return units.toArray(new Unit[units.size()]);
  }
}
