abstract class Unit {
  
  PVector boardPos;
  PVector size;
  Direction perspective;
  
  Game game;
  
  // ------- STATS -------------
  int hp;
  int attackRange;
  int damage;
  int speed;
  
  // ------- LOOK --------------
  color unitColor = color(0, 255, 255);
  
  // ------ MOVMENT HELPER ----------
  PVector boardDestination;
  boolean moving = false;
  int movementStep = 0;
  
  Unit(PVector boardPos, PVector size, Direction perspective, Game game, int speed, int hp, int attackRange, int damage) {
    this.boardPos = boardPos;
    this.size = size;
    this.perspective = perspective;
    this.game = game;
    this.speed = speed;
    this.hp = hp;
    this.attackRange = attackRange;
    this.damage = damage;
  }
  
  Unit(PVector boardPos, PVector size, Direction perspective, Game game) {
    this.boardPos = boardPos;
    this.size = size;
    this.perspective = perspective;
    this.game = game;
  }
  
  void move(MoveDirection direction) {
    if (moving) return;

    int currentAngle = getAngleFromDirection(perspective);
    currentAngle += getAngleFromMoveDirection(direction);
    Direction boardDirection = getDirectionFromAngle(currentAngle);
    PVector boardDestination;
    switch (boardDirection) {
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
  
  void move(PVector boardDestination) {
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
  
  void performMove() {
    if (!moving) return;
    
    movementStep++;
    if (movementStep >= (10 / speed)) {
      game.map.board[int(boardPos.x)][int(boardPos.y)].isOccupied = false;
      boardPos = boardDestination;
      boardDestination = null;
      movementStep = 0;
      moving = false;
    }
  }
  
  // ------------------------------
  
  void update() {
    if (moving) {
      performMove(); 
    }
    
    
  }
  
  void show() {
    fill(unitColor);
    ellipseMode(CENTER);
    PVector pos = getUnitPos();
    PVector realSize = getUnitSize();
    ellipse(pos.x, pos.y, realSize.x, realSize.y);
  }
  
  // ---------------- HELPER ----------------
  
  PVector getUnitPos() {
    return game.map.board[int(boardPos.x)][int(boardPos.y)].getCenter(); 
  }
  
  PVector getUnitSize() {
    return new PVector(size.x * game.unitSize.x, size.y * game.unitSize.y); 
  }
  
  int getAngleFromDirection(Direction direction) {
    switch(direction) {
      case NORTH: return 0;
      case EAST: return 90;
      case SOUTH: return 180;
      case WEST: return 270;
    }
    throw new RuntimeException("Could not convert Direction to Angle");
  }
  
  Direction getDirectionFromAngle(int angle) {
    if (angle % 360 == 0) return Direction.NORTH;
    if ((angle - 90) % 360 == 0) return Direction.EAST;
    if ((angle - 180) % 360 == 0) return Direction.SOUTH;
    if ((angle - 270) % 360 == 0) return Direction.WEST;
    throw new RuntimeException("Could not convert Angle to Direction");
  }
  
  int getAngleFromMoveDirection(MoveDirection direction) {
    switch(direction) {
      case STRAIGHT: return 0;
      case RIGHTHAND: return 90;
      case BACK: return 180;
      case LEFTHAND: return 270;
    }
    throw new RuntimeException("Could not convert MoveDirection to Angle");
  }
  
}
