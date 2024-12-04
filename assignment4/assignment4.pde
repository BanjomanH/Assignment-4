int[][] map = new int[10][9];
Open[][] revealed = new Open[10][9];
Closed[][] unrevealed = new Closed[10][9];
int difficulty = 16;

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
}

void draw()
{
  background(255);
}
