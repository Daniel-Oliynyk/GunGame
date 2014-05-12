class Player {
  int x, y, speed = 3, health = 100;
  float angle;
  int gunCool, clip = 0, reload = 1;
  int greCool, grenades;
  Gun gun = new Gun();
  
  void update() {
    //Backs up the x and y for collision.
    int px = x;
    int py = y;
    //Key controls for moving player.
    if (keys.contains(83)) y = y + speed; //S key.
    else if (keys.contains(87)) y = y - speed; //W key.
    if (keys.contains(68)) x = x + speed; //D key.
    else if (keys.contains(65)) x = x - speed; //A key.
    //Reloads gun if R is pressed and mag not full.
    if (keys.contains(82) && clip < gun.clipMax) reload = gun.reloadMax;
    //Throws grenade if Q is pressed and grenade cooled down.
    greCool--;
    if (keys.contains(81) && greCool < 1) {
      //Explodes at mouse location.
      bullets.add(new Explosive(x + 10, y + 10, 4, angle, int(dist(width / 2, height / 2, mouseX, mouseY) / 4), false, false, 30, 15, 32));
      greCool = 500;
    }
    //Resets x and y if player collides.
    if (map.checkCollision(x, py, 20)) x = px;
    else if (map.checkCollision(px, y, 20)) y = py;
    if (map.checkCollision(x, y, 20)) {
      x = px;
      y = py;
    }
    //Calculates the angle the player is looking in relation to cursor.
    angle = atan2(mouseY - (height / 2), mouseX - (width / 2));
    //Shoots if mouse is pressed.
    if (mousePressed) shoot();
    //Cools weapon down and reloads it.
    gunCool--;
    reload--;
    //Refills clip when reload timer hits zero. If lower than zero doesn't refill.
    if (reload == 0) clip = gun.clipMax;
    //Checks if player picked up any items in each corner, adds to health if not full.
    if (health < 100) {
      if (map.type[x / 20][y / 20] == 2) {
        map.type[x / 20][y / 20] = 0;
        health = health + 30 > 100? 100 : health + 30;
      }
      if (map.type[x / 20 + 1][y / 20] == 2) {
        map.type[x / 20 + 1][y / 20] = 0;
        health = health + 30 > 100? 100 : health + 30;
      }
      if (map.type[x / 20][y / 20 + 1] == 2) {
        map.type[x / 20][y / 20 + 1] = 0;
        health = health + 30 > 100? 100 : health + 30;
      }
      if (map.type[x / 20 + 1][y / 20 + 1] == 2) {
        map.type[x / 20 + 1][y / 20 + 1] = 0;
        health = health + 30 > 100? 100 : health + 30;
      }
    }
    //Draws the player.
    drawPerson(x, y, 20, angle, #0C2DCB, #9DADF7, health, 100);
  }
  
  void shoot() {
    //Shoots the player's weapon.
    if (gunCool < 1 && reload < 1) {
      //Shoots only if the gun cooled down and not reloading.
      gun.shoot();
      //Resets gun cooling time.
      gunCool = gun.gunCoolMax;
      //Subracts from the clip.
      clip--;
      //If empty, reloads.
      if (clip < 1) reload = gun.reloadMax;
    }
  }
  
}
