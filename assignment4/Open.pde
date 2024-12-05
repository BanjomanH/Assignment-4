// The class responsible for the open tiles
class Open
{
  PVector position;  // The place where the tile is placed
  int mapX; // The X position in regards to the map array
  int mapY; // The Y position in regards to the map array

  // The constructor for open.
  Open(int i, int j)
  {
    mapX = i;
    mapY = j;
    // Assigns the position uniformly across the 3 scripts
    position = new PVector(i * 40, j * 40);
  }

  // The update code for the open tiles
  void update()
  {
    // If the corrosponding closed tile is gone, then render itself.
    if (unrevealed[mapX][mapY].isOpen == false)
    {
      render();
      // If this tile is blank, then destroy the surrounding covers
      if (map[mapX][mapY] == 0)
      {        
        surround(mapX, mapY, -1);
      }
    }
  }

  // How the tile renders itself
  void render()
  {
    // A guide to find the right ending to the file
    int filePosition = map[mapX][mapY] + 3;
    // Ensures that mines scored as above 9 still render properly
    if (filePosition > 12)
    {
      filePosition = 12;
    }
    // The PImage for the tile
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
    tile.resize(40, 40);
    image(tile, position.x, position.y);
  }
}
