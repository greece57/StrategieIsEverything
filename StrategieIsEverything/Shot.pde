interface Shooting extends GameObject {
  int getDamage();
  int getShotSpeed();
  int getAttackRange();
  
  Direction getShotDirection();
}

interface Hitable extends GameObject {
  boolean didCollide(PVector point);
  void hit(Shot shot);
}

class Shot {
  
  boolean dead;
  
  PVector origin;
  PVector pos;
  Direction direction;
  Unit shooter;
  Game game;
  
  // ------- STATS ---------
  int damage;
  int range;
  int speed;
  
  // ----- HELPER -----
  static final int maxShotSpeed = 100;
  
  Shot(Unit shooter) {
    this.shooter = shooter;
    game = shooter.getGameInstance();
    
    origin = shooter.getUnitPos().copy();
    pos = origin.copy();
    
    direction = shooter.getShotDirection();
    
    damage = shooter.getDamage();
    range = shooter.getAttackRange();
    speed = shooter.getShotSpeed();
  }
  
  void update() {
    if (dead) {
      return;
    }
    moveShot();
    
    // Shot too far?
    PVector gridFieldSize = game.map.gridFieldSize;
    if ((Math.pow(dist(pos.x, pos.y, origin.x, origin.y), 2) > range * range * gridFieldSize.x * gridFieldSize.y) || game.map.isOutsideBoard(pos)) {
      dead = true;
      return;
    }
    
    checkForHit();
  }
  
  void show() {
    fill(255);
    //point(pos.x, pos.y);
    rect(pos.x, pos.y, 10, 10);
  }
  
  
  // --- HELPER ------
  
  private void moveShot() {
    PVector gridFieldSize = game.map.gridFieldSize;
    float traveledDistanceX = gridFieldSize.x/Shot.maxShotSpeed * speed;
    float traveledDistanceY = gridFieldSize.y/Shot.maxShotSpeed * speed;
    switch (direction) {
      case NORTH: pos.y -= traveledDistanceY;
                  break;
      case EAST:  pos.x += traveledDistanceX;
                  break;
      case SOUTH: pos.y += traveledDistanceY;
                  break;
      case WEST:  pos.x -= traveledDistanceX;
                  break;
       default:   throw new RuntimeException("Did run out of Direction-Possibilities when moving Shot");
    }
  }
  
  private void checkForHit() {
    for (GameObject gameObject : game.getGameObjects()) {
      if (gameObject instanceof Hitable) {
        Hitable hitableGameObject = (Hitable)gameObject;
        if (!(hitableGameObject.getUUID() == shooter.getUUID())) {
          if (hitableGameObject.didCollide(pos.copy())) {
            hitableGameObject.hit(this);
            dead = true;
          }
        }
      }
    }
  }
}
