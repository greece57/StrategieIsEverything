class Knight extends Unit {
  Knight(PVector boardPos, PVector size, Direction perspective, Tribe tribe) {
    super(boardPos, size, perspective, tribe);
    
    hp = 15;
    attackRange = 10;
    damage = 5;
    speed = 3;
    
    maxShots = 1;
    shotSpeed = 50;
    
    unitColor = color(230, 230, 230);
  }
}
