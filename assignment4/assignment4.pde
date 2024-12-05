int[][] map = new int[10][9];
Open[][] revealed = new Open[10][9];
Closed[][] unrevealed = new Closed[10][9];
int difficulty = 16;
int openedTiles = 0;
boolean isClassic = false;
boolean lClick = false;
boolean rClick = false;
boolean gameStart = false;
boolean canClick = true;

void setup()
{
  size(400, 400);
  restart();
}

void restart()
{
  openedTiles = 0;
  isClassic = false;
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
  background(255);
  if (openedTiles + difficulty == 90)
  {
    displayScreen(0);
  } else if (openedTiles < 0)
  {
    displayScreen(1);
  }
  println(openedTiles);

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
    if (gameStart == false)
    {
      gameStart = true;
      generateLevel(mouseX/40, mouseY/40);
    }

    lClick = false;
    if (mouseY < height - 40)
    {
      if (unrevealed[mouseX / 40][mouseY / 40].testMouse() == true && unrevealed[mouseX / 40][mouseY / 40].isFlagged == false)
      {
        unrevealed[mouseX / 40][mouseY / 40].open();
      }
    } else
    {
      if (mouseX < 40)
      {
        restart();
      }
    }
  } else if (rClick == true)
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
}

void displayScreen(int context)
{
  canClick = false;
  if (context == 0)
  {
    println("Victory!");
  } else if (context == 1)
  {
    println("Defeat!");
  } else
  {
    println("New Game");
  }
}

void generateLevel(int clickedX, int clickedY)
{
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
  if (canClick == true)
  {
    if (mouseButton == LEFT) {
      lClick = true;
    } else if (mouseButton == RIGHT) {
      rClick = true;
    }
  }
}
