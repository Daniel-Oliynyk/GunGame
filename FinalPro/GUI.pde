class GUI {
  boolean display = true;
  int option = 0, levelAmnt = 10;
  //All the different menus.
  String[] main = {"Play", "Levels", "Credits", "Exit"};
  String[] inGame = {"Resume", "Restart", "Shop", "Exit to Main"};
  String[] shop = {"Desert Eagle - $0", "P90 - $50", "G39C - $100", "Shotgun - $150", "AK47 - $200", "RPG - $250", "Grenade Launcher - $250", "LMG - $300", "Back"};
  String[] credits = {"Coding - Daniel", "Levels - Braedon, Aidan, and Ben", "Icons - Ben and Braedon", "Back"};
  String[] levels;
  String[] menu = main;
  
  GUI() {
    //Loops through and adds all the levels.
    levels = new String[levelAmnt];
    for (int i = 1; i < levelAmnt + 1; i++) {
      levels[i - 1] = "Level " + i;
    }
  }
  
  void drawGUI() {
    //Black background, blue and white text.
    background(0);
    //Top centers text vertically.
    int top = height / 2 - 20 * menu.length / 2;
    textAlign(CENTER);
    for (int i = 0; i < menu.length; i++) {
      //Draws all items in menu, colors blue if selected.
      if (i == option) fill(#3BB5C1);
      else fill(255);
      //Writes text.
      text(menu[i], width / 2, top + i * 20);
    }
    textAlign(LEFT);
  }
  
  void resetGame(boolean showMenu, int level) {
    //Resets all classes involved with gameplay.
    player = new Player();
    map = new Map();
    bots = new ArrayList<Bot>();
    bullets = new ArrayList<Projectile>();
    //Creates level specified.
    map.create(level);
    //Sets to in game menu and whether or not to hide the menu.
    setMenu(inGame);
    display = showMenu;
  }
  
  void submit() {
    if (menu == main) {
      //Main menu options. Read array on top for name of options.
      if (option == 0) resetGame(false, map.currentLevel);
      else if (option == 1) setMenu(levels);
      else if (option == 2) setMenu(credits);
      //Exits the game.
      else if (option == 3) exit();
    }
    else if (menu == inGame) {
      //In game menu options. Read array on top for name of options.
      if (option == 0) display = false;
      //Resarts current level.
      else if (option == 1) resetGame(false, map.currentLevel);
      else if (option == 2) setMenu(shop);
      else if (option == 3) setMenu(main);
    }
    else if (menu == shop) {
      //Shop options. Read array on top for name of options. Make temporary copy of gun.
      Gun temp = player.gun;
      //Changes gun if nessesary.
      if (option == 0) player.gun = new Gun();
      else if (option == 1 && money >= 50) {
        money -= 50;
        player.gun = new p90();
      }
      else if (option == 2 && money >= 100) {
        money -= 100;
        player.gun = new g39c();
      }
      else if (option == 3 && money >= 150) {
        money -= 150;
        player.gun = new shotgun();
      }
      else if (option == 4 && money >= 200) {
        money -= 200;
        player.gun = new ak47();
      }
      else if (option == 5 && money >= 250) {
        money -= 250;
        player.gun = new rpg();
      }
      else if (option == 6 && money >= 250) {
        money -= 250;
        player.gun = new greLaunch();
      }
      else if (option == 7 && money >= 300) {
        money -= 300;
        player.gun = new lmg();
      }
      else if (option == 8) setMenu(inGame);
      //If gun has changed, resets clip and reload.
      if (player.gun != temp) {
        player.gun.reset();
        display = false;
        setMenu(inGame);
      }
    }
    //Shows credits.
    else if (menu == credits && option == 3) setMenu(main);
    //If enter is pressed on levels, starts the level.
    else if (menu == levels) resetGame(false, option + 1);
  }
  
  void setMenu(String[] value) {
    //Sets the menu to show.
    menu = value;
    option = 0;
  }
  
}
