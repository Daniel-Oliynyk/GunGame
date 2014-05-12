class Map {
  String[] strings;
  int[][] type;
  int size, maxWidth, maxHeight, currentLevel = 1;
  
  void create(int level) {
    //Loads the level and defines the variables.
    strings = loadStrings("levels/level" + level + ".txt");
    size = int(strings[0]);
    maxWidth = size * 20;
    maxHeight = (strings.length - 1) * 20;
    type = new int[size][strings.length];
    currentLevel = level;
    //Reads each character.
    for (int y = 1; y < strings.length; y++) {
      for (int x = 0; x < size; x++) {
        if (strings[y].charAt(x) == 'x') type[x][y - 1] = 1; //X is the wall.
        else if (strings[y].charAt(x) == 'h') type[x][y - 1] = 2; //H is the item.
        else if (strings[y].charAt(x) == '|') type[x][y - 1] = 3; //| is a horzontal door.
        else if (strings[y].charAt(x) == '-') type[x][y - 1] = 4; //- is a vertical door.
        else if (strings[y].charAt(x) == 'o') bots.add(new Bot(x * 20, (y - 1) * 20)); //O is a bot.
        //S is the start position for the player.
        if (strings[y].charAt(x) == 's') {
          player.x = x * 20;
          player.y = (y - 1) * 20;
        }
      }
    }
  }
  
  void drawFile() {
    //Draws the surrounding box.
    fill(200);
    stroke(0);
    rect(0, 0, maxWidth, maxHeight);
    //Draws each box for the wall and items.
    for (int y = 0; y < strings.length - 1; y++) {
      for (int x = 0; x < size; x++) {
        fill(0);
        stroke(127);
        if (type[x][y] == 1) {
          //Draws the box wall.
          rect(x * 20, y * 20, 20, 20);
        }
        else if (type[x][y] == 2) {
          //Draws the item.
          fill(#1CA51B);
          stroke(#1CA51B);
          ellipse(x * 20 + 5, y * 20 + 5, 10, 10);
        }
        else if (type[x][y] == 3) {
          //Draws vertical door.
          rect(x * 20 + 7, y * 20, 6, 20);
        }
        else if (type[x][y] == 4) {
          //Draws horzontal door.
          rect(x * 20, y * 20 + 7, 20, 6);
        }
      }
    }
  }
  
  boolean checkCollision(float x, float y, int size) {
    //Checks collision for each corner and returns true if colliding.
    if (x + size >= maxWidth || x < 0 || y + size >= maxHeight || y < 0) return true;
    else if (type[int(x / 20)][int(y / 20)] == 1) return true;
    else if (type[int((x + size) / 20)][int(y / 20)] == 1) return true;
    else if (type[int(x / 20)][int((y + size) / 20)] == 1) return true;
    else if (type[int((x + size) / 20)][int((y + size) / 20)] == 1) return true;
    else return false;
  }
  
}
