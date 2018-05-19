interface UnitInterface extends GameObject, Shooting, Moveable, Hitable {
  
  boolean isDead();
  int getHP();
  int getSpeed();
  
  void update();
  void show();
}

interface Moveable extends GameObject {
  Direction getOrientation();
  
  void turn(MoveDirection direction);
  void move();
  void shoot();
}

abstract class Unit implements UnitInterface {
  
  private UUID uuid;
  
  PVector boardPos;
  PVector size;
  Direction orientation;
  
  Game game;
  Tribe tribe;
  
  // ------- STATS -------------
  int hp;
  int attackRange;
  int damage;
  int speed;
  
  int maxShots;
  int shotSpeed;
  
  // ------- LOOK --------------
  color unitColor = color(0, 255, 255);
  
  // ------ MOVMENT HELPER ----------
  static final int maxSpeed = 100;
  PVector boardDestination;
  boolean moving = false;
  int movementStep = 0;
  
  // ----- SHOOT HELPER ----------
  ArrayList<Shot> shots = new ArrayList<Shot>();
  
  Unit(PVector boardPos, PVector size, Direction orientation, Tribe tribe, int speed, int hp, int attackRange, int damage, int shotSpeed, int maxShots) {
    this(boardPos, size, orientation, tribe);
    this.speed = speed;
    this.hp = hp;
    this.attackRange = attackRange;
    this.damage = damage;
    this.maxShots = maxShots;
    this.shotSpeed = shotSpeed;
  }
  
  Unit(PVector boardPos, PVector size, Direction orientation, Tribe tribe) {
    this.uuid = UUID.randomUUID();
    
    this.boardPos = boardPos;
    this.size = size;
    this.orientation = orientation;
    this.tribe = tribe;
    this.game = tribe.game;
  }
  
  // ------------- MOVEMENT --------------
  
  void turn(MoveDirection direction) {
    if (moving) return;

    int currentAngle = getAngleFromDirection(orientation);
    currentAngle += getAngleFromMoveDirection(direction);
    Direction boardDirection = getDirectionFromAngle(currentAngle);
    
    orientation = boardDirection;
  }
  
  void move() {
    if (moving) return;
    PVector boardDestination;
    switch (orientation) {
      case NORTH: boardDestination = new PVector(boardPos.x, boardPos.y - 1);
                  break;
      case EAST: boardDestination = new PVector(boardPos.x + 1, boardPos.y);
                 break;
      case SOUTH: boardDestination = new PVector(boardPos.x, boardPos.y + 1);
                  break;
      case WEST: boardDestination = new PVector(boardPos.x - 1, boardPos.y);
                 break;
      default: boardDestination = null;
    }
    move(boardDestination);
  }
  
  private void move(PVector boardDestination) {
    if (moving) return;
    
    // Is Destination on GameBoard?
    if (boardDestination.x < 0 || boardDestination.y < 0) {
      return;
    }
    if (!(game.map.board.length > boardDestination.x) || !(game.map.board[int(boardDestination.x)].length > boardDestination.y)) {
      return;
    }
    
    // Is Destination Occupied?
    if (game.map.board[int(boardDestination.x)][int(boardDestination.y)].isOccupied) {
      return;
    }
    
    
    moving = true;
    game.map.board[int(boardDestination.x)][int(boardDestination.y)].isOccupied = true;
    movementStep = 0;
    this.boardDestination = boardDestination;
  }
  
  private void performMove() {
    if (!moving) return;
    
    movementStep += speed;
    if (movementStep >= Unit.maxSpeed) {
      game.map.board[int(boardPos.x)][int(boardPos.y)].isOccupied = false;
      boardPos = boardDestination;
      boardDestination = null;
      movementStep = 0;
      moving = false;
    }
  }
  
  // -------------- SHOOTING ------------------
  
  void shoot() {
    if (shots.size() < maxShots) { //<>//
      shots.add(new Shot(this)); 
    }
  }
  
  boolean didCollide(PVector point) {
    PVector realPosition = getUnitPos(); 
    return (Math.pow((point.x - realPosition.x), 2) + Math.pow((point.y - realPosition.y), 2) <= Math.pow(size.x, 2));
  }
  
  void hit(Shot shot) {
    hp -= shot.damage;
  }
  
  private void updateShots() {
    Iterator<Shot> i = shots.iterator();
    while (i.hasNext()) {
      Shot s = i.next();
      s.update();
      if (s.dead) {
        i.remove();
      }
    }
  }
  
  // ------------------------------
  
  void update() {
    if (moving) {
      performMove(); 
    }
    
    updateShots();
  }
  
  void show() {
    fill(unitColor);
    ellipseMode(CENTER);
    PVector pos = getUnitPos();
    PVector realSize = getUnitSize();
    if (moving) {
      PVector destPos = getDestinationPos();
      float distanceX = ((destPos.x - pos.x) / Unit.maxSpeed) * movementStep;
      float distanceY = ((destPos.y - pos.y) / Unit.maxSpeed) * movementStep;
      pos = new PVector(pos.x + distanceX, pos.y + distanceY);
    }
    ellipse(pos.x, pos.y, realSize.x, realSize.y);
    PVector teamColorPosition = getTeamColorPosition(pos, realSize);
    fill(tribe.tribeColor);
    ellipse(teamColorPosition.x, teamColorPosition.y, realSize.x/10, realSize.y/10);
    
    for (Shot shot : shots) {
      shot.show();
    }
  }
  
  // ---------------- HELPER ----------------
  
  private PVector getUnitPos() {
    return game.map.board[int(boardPos.x)][int(boardPos.y)].getCenter(); 
  }
  
  private PVector getDestinationPos() {
    return game.map.board[int(boardDestination.x)][int(boardDestination.y)].getCenter(); 
  }
  
  private PVector getUnitSize() {
    return new PVector(size.x * game.unitSize.x, size.y * game.unitSize.y); 
  }
  
  private int getAngleFromDirection(Direction direction) {
    switch(direction) {
      case NORTH: return 0;
      case EAST: return 90;
      case SOUTH: return 180;
      case WEST: return 270;
    }
    throw new RuntimeException("Could not convert Direction to Angle");
  }
  
  private Direction getDirectionFromAngle(int angle) {
    if (angle % 360 == 0) return Direction.NORTH;
    if ((angle - 90) % 360 == 0) return Direction.EAST;
    if ((angle - 180) % 360 == 0) return Direction.SOUTH;
    if ((angle - 270) % 360 == 0) return Direction.WEST;
    throw new RuntimeException("Could not convert Angle to Direction");
  }
  
  private int getAngleFromMoveDirection(MoveDirection direction) {
    switch(direction) {
      case STRAIGHT: return 0;
      case RIGHTHAND: return 90;
      case BACK: return 180;
      case LEFTHAND: return 270;
    }
    throw new RuntimeException("Could not convert MoveDirection to Angle");
  }
  
  private PVector getTeamColorPosition(PVector unitPosition, PVector unitSize) {
    switch(orientation) {
      case NORTH: return new PVector(unitPosition.x, unitPosition.y - unitSize.y/4);
      case EAST: return new PVector(unitPosition.x + unitSize.x/4, unitPosition.y);
      case SOUTH: return new PVector(unitPosition.x, unitPosition.y + unitSize.y/4);
      case WEST: return new PVector(unitPosition.x - unitSize.x/4, unitPosition.y);
    }
    throw new RuntimeException("Ran out of orientations when trying to locate TeamColorPosition of Unit");
  }
  
  // ---------- GETTER ---------------
  
  UUID getUUID() {
    return uuid;
  }
  
  PVector getRealPos() {
    return getUnitPos();
  }
  
  Game getGameInstance() {
    return game;
  }
  
  Direction getOrientation() {
    return orientation;
  }
  
  boolean isDead() {
    return hp <= 0;
  }
  
  int getHP() {
    return hp;
  }
  
  int getSpeed() {
    return speed;
  }
  
  int getDamage() {
    return damage;
  }
  
  int getAttackRange() {
    return attackRange;
  }
  
  int getShotSpeed() {
    return shotSpeed;
  }
  
  Direction getShotDirection() {
    return orientation;
  }
  
}
