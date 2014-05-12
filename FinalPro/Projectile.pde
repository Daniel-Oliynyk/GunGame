class Projectile {
  float x, y, speed, angle;
  int time, damage;
  boolean atPlayer, noTime, del, penetration;
  color col;
  
  Projectile(float xPos, float yPos, float newSpeed, float newAngle, int newtime, boolean isBot, boolean newPen, int newDam) {
    //Initializes all the values.
    x = xPos; //X position.
    y = yPos; //Y position.
    speed = newSpeed; //The speed of the projectile.
    angle = newAngle; //The angle the projectile is going.
    time = newtime; //How long before the projectile times out.
    if (time <= 0) noTime = true; //If time is 0, then bullet goes until collision.
    atPlayer = isBot; //Checks whether to detect collision with player or bots.
    col = !atPlayer? #0C2DCB : #F01818; //Sets the color of the bullet, red if to player, blue if from.
    penetration = newPen; //Sets whether or not the bullet penetrates.
    damage = newDam; //Sets the damage.
  }
  
  void update() {
    ellipseMode(CENTER);
    //Counts down timer and deletes bullet if expired.
    if (!noTime) {
      time--;
      if (time < 1) del = true;
    }
    //Moves the bullet at the defined speed.
    x = x + speed * cos(angle);
    y = y + speed * sin(angle);
    //Deletes the bullet if it hits a surface or a door.
    if (map.checkCollision(x -1, y - 1, 2)) del = true;
    else if (map.type[int(x / 20)][int(y / 20)] == 3 || map.type[int(x / 20)][int(y / 20)] == 4) del = true;
    //Checks if it hits a bot if player is shooting.
    if (!atPlayer) {
      for (Bot temp : bots) {
        if (dist(x, y, temp.x + (temp.size / 2), temp.y + (temp.size / 2)) < temp.size / 2) {
          //Deletes bullet if it hits a bot and is not penetrating.
          if (!penetration) del = true;
          //Deletes health from the bot and deletes it if no health.
          temp.health -= damage;
          //If no health, delete from game.
          if (temp.health < 1) {
            //Adds money for kills, more for juggernauts.
            if (!temp.del) money += (int(random(5, 25)) * temp.maxHealth / 100);
            temp.del = true;
            //If no other bots left, game is won.
            if (bots.size() <= 1) gui.resetGame(false, map.currentLevel + 1 > gui.levelAmnt? 1 : map.currentLevel + 1);
          }
        }
      }
    }
    //Checks if it hits the player if a bot is shooting.
    else if (dist(x, y, player.x + 10, player.y + 10) < 12) {
      //Subtracts from health and goes to main menu if dead.
      player.health -= damage;
      if (player.health < 1) {
        gui.resetGame(true, map.currentLevel);
        gui.setMenu(gui.main);
      }
      del = true;
    }
    //Draws the bullet.
    if (!del) {
      fill(col);
      noStroke();
      ellipse(x, y, 4, 4);
      stroke(0);
    }
    ellipseMode(CORNER);
  }
  
}

class Explosive extends Projectile {
  int radius, amnt;
  
  Explosive(float xPos, float yPos, float newSpeed, float newAngle, int newtime, boolean isBot, boolean newPen, int newDam, int newRad, int newAmnt) {
    //Initializes all the values.
    super(xPos, yPos, newSpeed, newAngle, newtime, isBot, newPen, newDam);
    x = xPos; //X position.
    y = yPos; //Y position.
    speed = newSpeed; //The speed of the projectile.
    angle = newAngle; //The angle the projectile is going.
    time = newtime; //How long before the projectile times out.
    if (time <= 0) noTime = true; //If time is 0, then bullet goes until collision.
    atPlayer = isBot; //Checks whether to detect collision with player or bots.
    col = !atPlayer? #0C2DCB : #F01818; //Sets the color of the bullet, red if to player, blue if from.
    damage = newDam; //Sets the damage.
    radius = newRad; //Sets the color of the bullet.
    amnt = newAmnt; //Sets the damage.
  }
  
  void update() {
    ellipseMode(CENTER);
    //Counts down timer and explodes if expired.
    if (!noTime) {
      time--;
      if (time < 1) explode();
    }
    //Moves the explosive at the defined speed.
    x = x + speed * cos(angle);
    y = y + speed * sin(angle);
    //Explodes if it hits a surface or a door.
    if (map.checkCollision(x -1, y - 1, 2)) explode();
    else if (map.type[int(x / 20)][int(y / 20)] == 3 || map.type[int(x / 20)][int(y / 20)] == 4) {
      //Breaks doors on contact.
      map.type[int(x / 20)][int(y / 20)] = 0;
      explode();
    }
    //Checks if it hits a bot if player is shooting.
    if (!atPlayer) {
      for (Bot temp : bots) {
        if (dist(x, y, temp.x + (temp.size / 2), temp.y + (temp.size / 2)) < temp.size / 2 + 5) {
          //Explodes on hit.
          explode();
          //Deletes health from the bot and deletes it if no health.
          temp.health -= damage;
          //If no health, delete from game.
          if (temp.health < 1) {
            //Adds money for kills, more for juggernauts.
            if (!temp.del) money += (int(random(5, 25)) * temp.maxHealth / 100);
            temp.del = true;
            //If no other bots left, game is won.
            if (bots.size() <= 1) gui.resetGame(false, map.currentLevel + 1 > gui.levelAmnt? 1 : map.currentLevel + 1);
          }
        }
      }
    }
    //Checks if it hits the player if a bot is shooting.
    else if (dist(x, y, player.x + 10, player.y + 10) < 15) {
      //Subtracts from health and goes to main menu if dead.
      player.health -= damage;
      if (player.health < 1) {
        gui.resetGame(true, map.currentLevel);
        gui.setMenu(gui.main);
      }
      explode();
    }
    //Draws the explosive (bigger).
    if (!del) {
      fill(col);
      noStroke();
      ellipse(x, y, 10, 10);
      stroke(0);
    }
    ellipseMode(CORNER);
  }
  
  void explode() {
    //Replaces explosive with bullets in all directions.
    del = true;
    //Calculates difference in angle.
    float step = (2 * PI) / amnt;
    //Creates all projectiles into temporary array.
    for (int i = 0; i < amnt; i++) {
      addBullets.add(new Projectile(x - speed * cos(angle), y - speed * sin(angle), int(random(5, 10)), angle + i * step, radius, atPlayer, true, 15));
    }
  }
  
}
