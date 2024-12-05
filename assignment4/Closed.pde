class Closed
{
  PVector position;
  PVector acceleration = new PVector(0, 0);
  PVector velocity = new PVector(0, 0);
  boolean isOpen;
  boolean isFlagged;
  int size = 40;
  int mapX;
  int mapY;

  Closed(int i, int j)
  {
    mapX = i;
    mapY = j;
    size = 40;
    isFlagged = false;
    isOpen = true;
    position = new PVector(i * 40, j * 40);
  }

  void update()
  {
    if (isOpen == true)
    {
      render();
    } else
    {
      acceleration = new PVector(acceleration.x, acceleration.y += 1);
      velocity = velocity.add(acceleration);
      position = position.add(velocity);
      size--;
      render();
    }
  }

  void open()
  {
    acceleration = new PVector(random(-2, 2), -5);
    size = 35;

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
    if (size > 0)
    {
      tile.resize(size, size);
    } 
    image(tile, position.x, position.y);
  }
}
