class Cavalry extends Unit {
  Cavalry(PVector boardPos, PVector size, Direction perspective, Game game) {
    super(boardPos, size, perspective, game);
    
    hp = 6;
    attackRange = 1;
    damage = 3;
    speed = 10;
    
    unitColor = color(40, 230, 230);
  }
}
