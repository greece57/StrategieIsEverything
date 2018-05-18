class Knight extends Unit {
  Knight(PVector boardPos, PVector size, Direction perspective, Game game) {
    super(boardPos, size, perspective, game);
    
    hp = 15;
    attackRange = 1;
    damage = 2;
    speed = 3;
    
    unitColor = color(230, 230, 230);
  }
}
