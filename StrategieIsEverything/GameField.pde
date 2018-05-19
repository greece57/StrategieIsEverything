class GameField {
  
  GridField[][] board;
  
  PVector pos;
  PVector size;
  PVector sizeInPixel;
  PVector gridFieldSize;
  
  GameField(PVector pos, PVector size, PVector sizeInPixel) {
    this.pos = pos;
    this.size = size;
    this.sizeInPixel = sizeInPixel;
    
    board = new GridField[int(size.x)][int(size.y)];
    
    gridFieldSize = new PVector(sizeInPixel.x/size.x, sizeInPixel.y/size.y);
    for (int row = 0; row < size.x; row++) {
      for (int column = 0; column < size.y; column++) {
        PVector gridFieldPos = new PVector(pos.x + (row * gridFieldSize.x), pos.y + (column * gridFieldSize.y));
        board[row][column] = new GridField(gridFieldPos, gridFieldSize, GridFieldType.GRAS);
      }
    }
  }
  
  GridField getFieldFromPosition(PVector realPos) {
    PVector gridFieldPosition = calcGridPosition(realPos);
    return board[int(gridFieldPosition.x)][int(gridFieldPosition.y)];
  }
  
  PVector calcGridPosition(PVector realPos) {
    realPos = new PVector(realPos.x - pos.x, realPos.y - pos.y);
    int x = int(realPos.x/gridFieldSize.x);
    int y = int(realPos.y/gridFieldSize.y);
    return new PVector(x, y);
  }
  
  boolean isOutsideBoard(PVector realPos) {
    return realPos.x < pos.x || realPos.x > (pos.x + sizeInPixel.x) || realPos.y < pos.y || realPos.y > (pos.y + sizeInPixel.y);
  }
  
  void show() {
    for (GridField[] row : board) {
      for (GridField field : row) {
        field.show();
      }
    }
  }
  
}
