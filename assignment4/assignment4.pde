int[][] map = new int[10][9];
Open[][] revealed = new Open[10][9];
Closed[][] unrevealed = new Closed[10][9];
int difficulty = 16;
boolean isClassic = false;

void setup()
{
  size(400, 400);
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      revealed[i][j] = new Open(i, j);
      unrevealed[i][j] = new Closed(i, j);
    }
  }
  // TEMPORARY CODE
  generateLevel(0 ,0);
}

void draw()
{
  background(255);
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      revealed[i][j].update();
      unrevealed[i][j].update();
    }
  }
}

void generateLevel(int clickedX, int clickedY)
{
  for (int i = 0; i < difficulty; i++)
  {
    int mineX = int(random(0, 10));
    int mineY = int(random(0, 9));
    while (map[mineX][mineY] > 8 || (clickedX == mineX && clickedY == mineY))
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
        map[x + i][y + j] += increase;
      }
    }
  }
}
