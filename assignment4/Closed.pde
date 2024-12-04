class Closed
{
  PVector position;
  boolean isOpen;
  boolean isFlagged;
  int mapX;
  int mapY;

  Closed(int i, int j)
  {
    mapX = i;
    mapY = j;
    isFlagged = false;
    isOpen = true;
    position = new PVector(i * 40, j * 40);
  }

  void update()
  {
    if (isOpen == true)
    {
      render();
    }
  }

  void open()
  {
    isOpen = false;
  }

  boolean testMouse()
  {
    boolean hovering = false;

    if (mouseX > mapX * 40 && mouseX < (mapX * 40) + 40 && mouseY > mapY * 40 && mouseY < (mapY * 40) + 40)
    {
      hovering = true;
    }

    return hovering;
  }

  void render()
  {
    int filePosition;
    if (isFlagged == false)
    {
      filePosition = 1;
    } else
    {
      filePosition = 2;
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
