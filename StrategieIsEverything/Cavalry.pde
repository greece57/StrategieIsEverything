class Cavalry extends Unit {
  Cavalry(PVector boardPos, PVector size, Direction perspective, Tribe tribe) {
    super(boardPos, size, perspective, tribe);
    
    hp = 6;
    attackRange = 1;
    damage = 5;
    speed = 10;
    
    maxShots = 1;
    shotSpeed = 30;
    
    unitColor = color(40, 230, 230);
  }
}
