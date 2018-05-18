class GridField {
  PVector pos;
  PVector size;
  GridFieldType type;
  
  boolean isOccupied = false;

  GridField(PVector pos, PVector size, GridFieldType type) {
    this.pos = pos;
    this.size = size;
    this.type = type;
    
    if (type == GridFieldType.MOUNTAIN) isOccupied = true;
  }

  PVector getCenter() {
    return new PVector(pos.x+(size.x/2), pos.y+(size.y/2));
  }

  private color getColorByGridFieldType(GridFieldType type) {
    switch(type) {
    case GRAS:  
      return color(0, 255, 0);
    case MOUNTAIN: 
      return color(180, 180, 0);
    }
    return color(0, 0, 0);
  }


  // ------------------------------------------
  void show() {
    color fieldColor = getColorByGridFieldType(type);
    fill(fieldColor);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
