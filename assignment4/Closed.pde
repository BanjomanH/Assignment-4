// The class responsible for the closed tiles
class Closed
{
  PVector position; // The place where the tile is placed
  PVector acceleration = new PVector(0, 0); // The static forces applied to the velocity.
  PVector velocity = new PVector(0, 0); // The current momentum applied to the acceleration
  boolean isOpen; // Whether the tile covers or doesn't cover the tile underneath it
  boolean isFlagged; // Whether this tile has a flag on it or not
  int size = 40; // The size of the square. Shrinks when the player opens the tile
  int mapX; // The X position in regards to the map array
  int mapY; // The Y position in regards to the map array

  // The constructor for closed.
  Closed(int i, int j)
  {
    mapX = i;
    mapY = j;
    size = 40;
    // Starts both open and flagged
    isFlagged = false;
    isOpen = true;
    // Assigns the position uniformly across the 3 scripts
    position = new PVector(i * 40, j * 40);
  }

  // The update code for the open tiles
  void update()
  {
    if (isOpen == true)
    {
      render();
    } else
    {
      // If the tile is closed, then pop off in the correct direction
      acceleration = new PVector(acceleration.x, acceleration.y += 1);
      velocity = velocity.add(acceleration);
      position = position.add(velocity);
      size--;
      render();
    }
  }

  // The code responsible for opening the tile and doing the correct animation
  void open()
  {
    // Launches upward in a random horizontal direction
    acceleration = new PVector(random(-2, 2), -5);
    size = 35;
    // If the tile opens on a non 9 tile, then it increments the open tiles int
    if (map[mapX][mapY] < 9)
    {
      openedTiles++;
    } else
    {
      // If the tile ones on a 9 tile, then sets it to a neutral.
      openedTiles = -1;
    }
    isOpen = false;
  }

  // Returns as true if the mouse falls within the tiles boundaries
  boolean testMouse()
  {
    boolean hovering = false;

    if (mouseX > mapX * 40 && mouseX < (mapX * 40) + 40 && mouseY > mapY * 40 && mouseY < (mapY * 40) + 40)
    {
      hovering = true;
    }

    return hovering;
  }

  // How the tile renders itself
  void render()
  {
    // A guide to find the right ending to the file
    int filePosition;
    // Ensures that mines scored as above 9 still render properly
    if (isFlagged == false)
    {
      filePosition = 1;
    } else
    {
      filePosition = 2;
    }
    PImage tile;

    // Selects which type of tile to render
    if (isClassic == false)
    {
      tile = loadImage("minesweeper tiles" + filePosition + ".png");
    } else
    {
      tile = loadImage("alt tiles-Sheet" + filePosition + ".png");
    }
    // Resizes the tile appropriately, and places the tile in the right position
    if (size > 0)
    {
      tile.resize(size, size);
    }
    image(tile, position.x, position.y);
  }
}
