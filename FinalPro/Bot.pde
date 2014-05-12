class Bot {
  float x = 250, y = 250;
  int size, time, speed = 2;
  float angle, angleDir, playerAngle, health, maxHealth = 100;
  boolean del, grenade = false;
  
  Bot(float xStart, float yStart) {
    //Inintializes the variables for the starting position.
    x = xStart;
    y = yStart;
    //Sets the size.
    size = 20;
    //Juggernaut creates 1 out of 10 times.
    if (random(1) > 0.9) {
      size = 40;
      maxHealth = 300;
      grenade = true;
    }
    health = maxHealth;
  }
  
  void update() {
    //Moves if the timer counted down.
    if (time > 0) {
      //Checks for collision on the new x and y co-ordinates.
      if (map.checkCollision(x + cos(angle) * speed, y + sin(angle) * speed, size)) time = 0;
      else {
        //Updates x and y if no collision.
        x = x + cos(angle) * speed;
        y = y + sin(angle) * speed;
      }
      //Changes the direction the bot will be turning to a random number.
      angleDir = random(-0.2, 0.2);
      //Counts down the time.
      time--;
    }
    else {
      //If the timer has not counted down, turns bot around.
      angle = angle + angleDir;
      //One out of thiry chance of reseting the time and moving.
      if (int(random(30)) == 3) time = int(random(100));
    }
    //Sets the angle needed to look at player.
    playerAngle = atan2((player.y + 10) - y - (size / 2), (player.x + 10) - x - (size / 2));
    //If player within 200px, turns toward him.
    if (dist(x + size / 2, y + size / 2, player.x + 10, player.y + 10) < 200) angle = playerAngle;
    //One out of seventy chance of shooting, with a random deviation.
    if (!grenade && int(random(70)) == 3) bullets.add(new Projectile(x + 10, y + 10, 15, angle + random(-0.1, 0.1), 0, true, false, 15));
    else if (grenade && int(random(100)) == 3) bullets.add(new Explosive(x + 10, y + 10, 4, angle + random(-0.1, 0.1), 0, true, false, 20, 10, 32));
    drawPerson(int(x), int(y), size, angle, #F01818, #E86767, health, maxHealth);
  }
  
}
