// SE3011 Lab 05 - Processing Animation Basics
// Final Task: Catch the Orb Game
// Created for lab submission

int state = 0; // 0 = START, 1 = PLAY, 2 = END

// Player
float px, py;
float pr = 22;
float playerSpeed = 6;

// Helper dot
float hx, hy;
float ease = 0.10;

// Orb
float ox, oy;
float or = 18;
float oxSpeed = 4;
float oySpeed = 3;

// Game
int score = 0;
int startTime;
int duration = 30;

// Trails
boolean trails = false;

void setup() {
  size(700, 350);
  resetGame();
}

void draw() {
  if (state == 0) {
    drawStartScreen();
  } else if (state == 1) {
    drawPlayScreen();
  } else if (state == 2) {
    drawEndScreen();
  }
}

void drawStartScreen() {
  background(235, 245, 255);

  textAlign(CENTER, CENTER);
  fill(30, 60, 120);
  textSize(34);
  text("Catch the Orb", width/2, height/2 - 55);

  fill(0);
  textSize(18);
  text("Use ARROW KEYS to move the player", width/2, height/2 - 10);
  text("Catch the bouncing orb to score points", width/2, height/2 + 20);
  text("Press T to toggle trails", width/2, height/2 + 50);

  fill(40, 120, 220);
  textSize(22);
  text("Press ENTER to Start", width/2, height/2 + 100);
}

void drawPlayScreen() {
  if (!trails) {
    background(245);
  } else {
    noStroke();
    fill(245, 35);
    rect(0, 0, width, height);
  }

  movePlayer();
  moveHelper();
  moveOrb();
  checkCatch();

  drawOrb();
  drawHelper();
  drawPlayer();
  drawHUD();

  int elapsed = (millis() - startTime) / 1000;
  int timeLeft = duration - elapsed;

  if (timeLeft <= 0) {
    state = 2;
  }
}

void drawEndScreen() {
  background(255, 240, 230);

  textAlign(CENTER, CENTER);
  fill(120, 40, 30);
  textSize(32);
  text("Time Over!", width/2, height/2 - 50);

  fill(0);
  textSize(24);
  text("Final Score: " + score, width/2, height/2);

  textSize(18);
  text("Press R to Restart", width/2, height/2 + 55);
}

void movePlayer() {
  if (keyPressed) {
    if (keyCode == RIGHT) px += playerSpeed;
    if (keyCode == LEFT)  px -= playerSpeed;
    if (keyCode == DOWN)  py += playerSpeed;
    if (keyCode == UP)    py -= playerSpeed;
  }

  px = constrain(px, pr, width - pr);
  py = constrain(py, pr, height - pr);
}

void moveHelper() {
  hx = hx + (px - hx) * ease;
  hy = hy + (py - hy) * ease;
}

void moveOrb() {
  ox += oxSpeed;
  oy += oySpeed;

  if (ox > width - or || ox < or) {
    oxSpeed *= -1;
  }

  if (oy > height - or || oy < or) {
    oySpeed *= -1;
  }
}

void checkCatch() {
  float d = dist(px, py, ox, oy);

  if (d < pr + or) {
    score++;
    resetOrb();

    // Increase speed slightly after every catch
    oxSpeed *= 1.08;
    oySpeed *= 1.08;
  }
}

void drawPlayer() {
  noStroke();
  fill(50, 120, 220);
  ellipse(px, py, pr*2, pr*2);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("YOU", px, py);
}

void drawHelper() {
  noStroke();
  fill(80, 200, 120);
  ellipse(hx, hy, 16, 16);
}

void drawOrb() {
  noStroke();
  fill(255, 120, 70);
  ellipse(ox, oy, or*2, or*2);
}

void drawHUD() {
  int elapsed = (millis() - startTime) / 1000;
  int timeLeft = max(0, duration - elapsed);

  fill(0);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Score: " + score, 20, 20);
  text("Time Left: " + timeLeft, 20, 42);
  text("Trails: " + (trails ? "ON" : "OFF") + " (Press T)", 20, 64);
}

void resetGame() {
  px = width/2;
  py = height/2;
  hx = px;
  hy = py;

  score = 0;
  oxSpeed = 4;
  oySpeed = 3;

  resetOrb();
}

void resetOrb() {
  ox = random(or, width - or);
  oy = random(or, height - or);

  // Random direction
  if (random(1) < 0.5) oxSpeed = abs(oxSpeed);
  else oxSpeed = -abs(oxSpeed);

  if (random(1) < 0.5) oySpeed = abs(oySpeed);
  else oySpeed = -abs(oySpeed);
}

void keyPressed() {
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
  }

  if (state == 2 && (key == 'r' || key == 'R')) {
    resetGame();
    state = 0;
  }

  if (key == 't' || key == 'T') {
    trails = !trails;
  }
}
