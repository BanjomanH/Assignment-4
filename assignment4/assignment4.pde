int[][] map = new int[10][9];
Open[][] revealed = new Open[10][9];
Closed[][] unrevealed = new Closed[10][9];
int difficulty = 16;
int openedTiles = 0;
int mines = 16;
int screenContext = 1;
int time = 0;
int record = 999;
boolean isClassic = false;
boolean lClick = false;
boolean rClick = false;
boolean gameStart = false;
boolean canClick = true;

void setup()
{
  size(400, 400);
  frameRate(30);
  restart();
}

void restart()
{
  time = 0;
  openedTiles = 0;
  lClick = false;
  rClick = false;
  gameStart = false;
  canClick = true;
  map = new int[10][9];
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      revealed[i][j] = new Open(i, j);
      unrevealed[i][j] = new Closed(i, j);
    }
  }
}

void draw()
{
  println(gameStart);
  if (gameStart == true && frameCount % 30 == 0)
  {
    time++;
  }
  background(255);
  if (openedTiles + mines == 90)
  {
    screenContext = 3;
  } else if (openedTiles < 0)
  {
    screenContext = 2;
  }

  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      revealed[i][j].update();
      if (unrevealed[i][j].isOpen == true && unrevealed[i][j].size > 0)
      {
        unrevealed[i][j].update();
      }
    }
  }

  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      if (unrevealed[i][j].isOpen == false && unrevealed[i][j].size > 0)
      {
        unrevealed[i][j].update();
      }
    }
  }

  if (lClick == true)
  {
    if (screenContext != 0)
    {
      screenContext = 0;
      lClick = false;
      restart();
    } else
    {
      if (gameStart == false && canClick == true)
      {
        gameStart = true;
        generateLevel(mouseX/40, mouseY/40);
      }

      lClick = false;
      if (mouseY < height - 40  && canClick == true)
      {
        if (unrevealed[mouseX / 40][mouseY / 40].testMouse() == true && unrevealed[mouseX / 40][mouseY / 40].isFlagged == false)
        {
          unrevealed[mouseX / 40][mouseY / 40].open();
        }
      } else if (mouseY > height - 40)
      {
        if (mouseX < 40)
        {
          restart();
        } else if (mouseX < 120)
        {
          if (isClassic == true)
          {
            isClassic = false;
          } else
          {
            isClassic = true;
          }
        } else if (mouseX > 300)
        {
          difficulty = constrain((mouseX - 310)/2, 1, 31);
          println(difficulty);
        }
      }
    }
  } else if (rClick == true && canClick == true)
  {
    rClick = false;
    if (unrevealed[mouseX / 40][mouseY / 40].isFlagged == true)
    {
      unrevealed[mouseX / 40][mouseY / 40].isFlagged = false;
    } else
    {
      unrevealed[mouseX / 40][mouseY / 40].isFlagged = true;
    }
  }

  PImage bottomBar = loadImage("minesweeperBottomBar.png");
  if (isClassic == true)
  {
    bottomBar = loadImage("ClassicBottomBar.png");
  }

  bottomBar.resize(400, 40);
  image(bottomBar, 0, 360);

  text(time, 200, 390);

  fill(200);
  rect(320, 378, difficulty * 2, 5);
  stroke(200);
  strokeWeight(3);
  rect((difficulty * 2) + 310, 375, 10, 10);
  noStroke();

  if (screenContext !=0)
  {
    displayScreen();
  }
}

void displayScreen()
{
  canClick = false;
  gameStart = false;
  textAlign(CENTER);
  textSize(25);
  fill(0, 0, 0, 100);
  rect(0, 0, 400, 400);
  fill(255);
  if (screenContext == 1)
  {
    text("Welcome to MINESWEEPER, baby! Click anywhere to play", 60, 120, 270, 280);
  } else if (screenContext == 2)
  {
    text("GAME OVER. You had " + (90 - openedTiles - mines) + " spaces left to clear! Click anywhere to restart", 60, 120, 270, 280);
  } else
  {
    if (time < record)
    {
      record = time;
    }
    text("VICTORY. You beat the level in " + time + ". Highscore: " + record + ". Click anywhere to restart", 60, 120, 270, 280);
  }
}

void generateLevel(int clickedX, int clickedY)
{
  mines = difficulty;
  for (int i = 0; i < difficulty; i++)
  {
    int mineX = int(random(0, 10));
    int mineY = int(random(0, 9));
    while (map[mineX][mineY] > 8 || (clickedX - 2 < mineX && clickedX + 2 > mineX && clickedY - 2 < mineY && clickedY + 2 > mineY))
    {
      mineX = int(random(0, 10));
      mineY = int(random(0, 9));
    }
    map[mineX][mineY] = 9;
    surround(mineX, mineY, 1);
  }
}

void surround(int x, int y, int increase)
{
  for (int i = -1; i < 2; i++)
  {
    for (int j = -1; j < 2; j++)
    {
      if (x + i > -1 && x + i < 10 && y + j > -1 && y + j < 9)
      {
        if (increase < 0)
        {
          if (unrevealed[x + i][y + j].isOpen == true)
          {
            unrevealed[x + i][y + j].open();
          }
        } else
        {
          map[x + i][y + j] += increase;
        }
      }
    }
  }
}

void mousePressed()
{
  if (mouseButton == LEFT) {
    lClick = true;
  } else if (mouseButton == RIGHT) {
    rClick = true;
  }
}
