Tribe[] players;
Game g;

void setup() {
  size(1024, 1024);
  GameField gF = new GameField(new PVector(312,0), new PVector(10, 20), new PVector(400, 800));
  PVector unitSize = gF.board[0][0].size;
  players = new Tribe[2];
  players[0] = new Tribe();
  players[1] = new Tribe();
  g = new Game(players, gF, unitSize);
  g.init();
  
  players[0].spawnRandomUnit();
}

void draw() {
  g.update();
  g.show();
}
