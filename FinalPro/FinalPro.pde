import java.util.Iterator;

ArrayList keys = new ArrayList();
Player player = new Player();
Map map = new Map();
GUI gui = new GUI();
ArrayList<Bot> bots = new ArrayList<Bot>();
ArrayList<Projectile> bullets = new ArrayList<Projectile>();
ArrayList<Projectile> addBullets = new ArrayList<Projectile>();
PImage[] guns = new PImage[7];
PImage bullet, bulletGrey, bulletSM, bulletGreySM, grenade;
int money = 1000;

void setup() {
  size(800, 800);
  ellipseMode(CORNER);
  map.create(1);
  //Loads all the gun icons and bullet images.
  guns[0] = loadImage("Guns/AK47.png");
  guns[1] = loadImage("Guns/DesertE.png");
  guns[2] = loadImage("Guns/G39C.png");
  guns[3] = loadImage("Guns/M249SAW.png");
  guns[4] = loadImage("Guns/P90.png");
  guns[5] = loadImage("Guns/RPG.png");
  guns[6] = loadImage("Guns/Shotgun.png");
  bullet = loadImage("Guns/BulletS.png");
  bulletGrey = loadImage("Guns/BulletOS.png");
  grenade = loadImage("Guns/Grenade.png");
  //Sets the font.
  PFont font = loadFont("ArialUnicodeMS-48.vlw");
  textFont(font, 16);
}

void draw() {
  //If in game, draws game.
  if (!gui.display) {
    background(255);
    //Moves the drawing so the player is always in the center.
    pushMatrix();
    translate((player.x * -1) + width / 2 - 10, (player.y * -1) + height / 2 - 10);
    //Updates all the classes.
    map.drawFile();
    player.update();
    //Loops through the bots and deletes them if nessesary.
    Iterator<Bot> itBot = bots.iterator();
    while(itBot.hasNext()) {
      Bot temp = itBot.next();
      temp.update();
      if(temp.del) itBot.remove();
    }
    //Loops through the bullet classes and deletes them if nessesary.
    Iterator<Projectile> itBul = bullets.iterator();
    while(itBul.hasNext()) {
      Projectile temp = itBul.next();
      temp.update();
      if(temp.del) itBul.remove();
    }
    //After iterating over bullets, adds in bullets from temporay array.
    bullets.addAll(addBullets);
    addBullets.clear();
    //Draws the clip size.
    popMatrix();
    for (int i = 0; i < player.gun.clipMax; i++) {
      //Draws grey bullet if not in clip, colored otherwise.
      if (i < player.clip) image(bullet, 10 + i * 6, height - 50);
      else image(bulletGrey, 10 + i * 6, height - 50);
    }
    //Writes if player is reloading.
    fill(#B91616);
    if (player.reload > 0) text("Reloading " + int(float(player.gun.reloadMax - player.reload) / player.gun.reloadMax * 100) + "%", 10, height - 50);
    //Draws gun icon and money.
    image(guns[player.gun.gunInt], width - 110, height - 60);
    text("$" + money, 5, 15);
    //Draws the grenade icon if player has one.
    if (player.greCool < 1) image(grenade, width - 160, height - 60);
    //M is pause, B is shop.
    if (keys.contains(77)) gui.display = true;
    else if (keys.contains(66)) {
      gui.setMenu(gui.shop);
      gui.display = true;
    }
  }
  //If gui is shown.
  else gui.drawGUI();
}

void keyPressed() {
  //Adds key to list so program can detect multiple keystrokes.
  if (!keys.contains(keyCode)) keys.add(keyCode);
  //Moves items up and down and submits the GUI.
  if (gui.display && (keyCode == 40 || keyCode == 83)) gui.option = gui.option >= gui.menu.length - 1? 0 : gui.option + 1;
  else if (gui.display && (keyCode == 38 || keyCode == 87)) gui.option = gui.option < 1? gui.menu.length - 1 : gui.option - 1;
  else if (gui.display && keyCode == 10) gui.submit();
}

void keyReleased() {
  //Removes all instances of the key from list.
  int index = keys.indexOf(keyCode);
  while (index != -1) {
    keys.remove(index);
    index = keys.indexOf(keyCode);
  }
}

void drawPerson(int xPos, int yPos, int size, float angle, color main, color outline, float health, float maxHealth) {
  //Draws a default character facing a certain way.
  strokeWeight(2);
  stroke(outline);
  fill(main);
  //Draws the circle.
  ellipse(xPos, yPos, size, size);
  strokeWeight(1);
  //Draws the line.
  lineAngle(xPos + size / 2, yPos + size / 2, size, angle, 2, outline);
  //Draws the health bar.
  noStroke();
  fill(#41BC1C);
  rect(xPos, yPos + size + 5, size, 2);
  fill(#FF0000);
  rect(xPos, yPos + size + 5, size * ((maxHealth - health) / maxHealth), 2);
  stroke(0);
}

void lineAngle(int xPos, int yPos, int dist, float angle, int strokeWidth, color col) {
  //Draws a line a certain distance on an certain angle.
  //Calculates the two endpoints.
  int xEnd = xPos + int(dist * cos(angle));
  int yEnd = yPos + int(dist * sin(angle));
  //Draws the line.
  strokeWeight(strokeWidth);
  stroke(col);
  line(xPos, yPos, xEnd, yEnd);
  strokeWeight(1);
}
