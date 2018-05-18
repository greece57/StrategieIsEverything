class GameField {
  
  GridField[][] board;
  
  GameField(PVector pos, PVector size, PVector sizeInPixel) {
    board = new GridField[int(size.x)][int(size.y)];
    
    PVector gridFieldSize = new PVector(sizeInPixel.x/size.x, sizeInPixel.y/size.y);
    for (int row = 0; row < size.x; row++) {
      for (int column = 0; column < size.y; column++) {
        PVector gridFieldPos = new PVector(pos.x + (row * gridFieldSize.x), pos.y + (column * gridFieldSize.y));
        board[row][column] = new GridField(gridFieldPos, gridFieldSize, GridFieldType.GRAS);
      }
    }
  }
  
  void show() {
    for (GridField[] row : board) {
      for (GridField field : row) {
        field.show();
      }
    }
  }
  
}
