class Gun {
  //The default values for defualt pistol.
  int gunCoolMax = 30, clipMax = 8, reloadMax = 100, gunInt = 1, damage = 35, speed = 7;
  
  void shoot() {
    //The default code shoots one bullet.
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle, 0, false, false, damage));
  }
  
  void reset() {
    //Resets the clip and reload time.
    player.gunCool = 0;
    player.clip = clipMax;
    player.reload = 0;
  }
}

class p90 extends Gun {
  p90 () {
    //The default values for p90. Shoots faster.
    gunCoolMax = 10;
    clipMax = 30;
    reloadMax = 75;
    gunInt = 4;
    damage = 25;
    speed = 10;
  }
}

class shotgun extends Gun {
  shotgun() {
    //The default values for shotgun.
    clipMax = 4;
    reloadMax = 60;
    gunInt = 6;
    damage = 20;
    speed = 5;
  }
  
  void shoot() {
    //Shoots 5 slower bullets instead. Specifies range as well as penetration.
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle + 0.2, 30, false, true, damage));
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle + 0.1, 30, false, true, damage));
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle, 30, false, true, damage));
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle - 0.1, 30, false, true, damage));
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle - 0.2, 30, false, true, damage));
  }
}

class g39c extends Gun {
  g39c() {
    //The default values for g39c.
    gunCoolMax = 2;
    clipMax = 3;
    reloadMax = 40;
    gunInt = 2;
    damage = 20;
    speed = 10;
  }
  
  void shoot() {
    //Shoots with pentration.
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle, 0, false, true, damage));
  }
}

class ak47 extends Gun {
  ak47() {
    //The default values for ak47.
    gunCoolMax = 5;
    clipMax = 25;
    reloadMax = 150;
    gunInt = 0;
    damage = 30;
    speed = 7;
  }
  
  void shoot() {
    //Shoots with pentration, though a bit inaccurate.
    bullets.add(new Projectile(player.x + 10, player.y + 10, speed, player.angle + random(-0.08, 0.08), 0, false, true, damage));
  }
}

class lmg extends Gun {
  lmg() {
    //The default values for LMG.
    gunCoolMax = 5;
    clipMax = 60;
    reloadMax = 300;
    gunInt = 3;
  }
}

class rpg extends Gun {
  rpg() {
    //The default values for RPG.
    gunCoolMax = 1;
    clipMax = 1;
    reloadMax = 100;
    gunInt = 5;
    speed = 8;
    damage = 30; 
  }
  
  void shoot() {
    //Shoots explosives.
    bullets.add(new Explosive(player.x + 10, player.y + 10, speed, player.angle, 0, false, false, damage, 15, 32));
  }
}

class greLaunch extends Gun {
  greLaunch() {
    //The default values for RPG.
    gunCoolMax = 35;
    clipMax = 3;
    reloadMax = 150;
    gunInt = 5;
    speed = 4;
    damage = 30;
  }
  
  void shoot() {
    //Shoots explosives.
    bullets.add(new Explosive(player.x + 10, player.y + 10, speed, player.angle, int(dist(width / 2, height / 2, mouseX, mouseY) / 4), false, false, damage, 15, 32));
  }
}
