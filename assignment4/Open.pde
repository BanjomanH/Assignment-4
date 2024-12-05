class Open
{
  PVector position;
  int mapX;
  int mapY;

  Open(int i, int j)
  {
    mapX = i;
    mapY = j;
    position = new PVector(i * 40, j * 40);
  }

  void update()
  {
    if (unrevealed[mapX][mapY].isOpen == false)
    {
      render();
      if (map[mapX][mapY] == 0)
      {        
        surround(mapX, mapY, 0);
      }
    }
  }

  void render()
  {
    int filePosition = map[mapX][mapY] + 3;
    if (filePosition > 12)
    {
      filePosition = 12;
    }
    PImage tile;

    if (isClassic == false)
    {
      tile = loadImage("minesweeper tiles" + filePosition + ".png");
    } else
    {
      tile = loadImage("alt tiles-Sheet" + filePosition + ".png");
    }
    tile.resize(40, 40);
    image(tile, position.x, position.y);
  }
}
