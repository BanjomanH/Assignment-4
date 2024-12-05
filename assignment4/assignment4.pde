/*

 Project Name: Minesweeper
 Programmed by: Ben Hicken | 991789481
 
 CONTROLS:
 
 Left click on tiles to destroy them! Right click on tiles to place flags!
 The bottom bar has a bunch of extra function for your enjoyment:
  - Restart the game! 
  - Swap styles!
  - Adjust mine count with a slider!
 
 Clear every non-mine tile to win!
 
 Tip: A 1-2-2-1 on a flat side means mines hide behind the 2's!
 
 */

int[][] map = new int[10][9]; // The numerical value of each tile on the grid
Open[][] revealed = new Open[10][9]; // An array containing pointers to each open object
Closed[][] unrevealed = new Closed[10][9]; // An array containing pointers to each closed object
int difficulty = 16; // The current difficulty set by the sliders
int openedTiles = 0; // The amount of tiles opened so far
int mines = 16; // The amount of mines on the current board
int screenContext = 1; // What screen should currently be displayed
int time = 0; // The amount of time passed since the round has started
int record = 999; // The record for the amount of time passed since the round has started
boolean isClassic = false; // Whether the classic texture pack is being displayed
boolean lClick = false; // Whether the left click button is being pressed
boolean rClick = false; // Whether the right click button is being pressed
boolean gameStart = false; // Whether the current game has been started or not
boolean canClick = true; // Whether the player can click on the current games tiles or not

// The frame setup and game restart before the game continues
void setup()
{
  size(400, 400);
  frameRate(30);
  restart();
}

// Prepares variables needed to start a new game
void restart()
{
  time = 0;
  openedTiles = 0;
  lClick = false;
  rClick = false;
  gameStart = false;
  canClick = true;
  map = new int[10][9];
  // Iterates through the both arrays and creates new version of all
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      revealed[i][j] = new Open(i, j);
      unrevealed[i][j] = new Closed(i, j);
    }
  }
}

// The central draw function for the game
void draw()
{
  // Whether the game can increment the timer or not
  if (gameStart == true && frameCount % 30 == 0)
  {
    time++;
  }
  background(255);
  
  // The victory/loss calculations. Sets screenContext to the correct screen to display
  if (openedTiles + mines == 90)
  {
    screenContext = 3;
  } else if (openedTiles < 0)
  {
    screenContext = 2;
  }

  // Iterates through both the revealed an unrevealed tiles to update them
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      revealed[i][j].update();
      // Code ensures that only unpopped tiles are rendered
      if (unrevealed[i][j].isOpen == true && unrevealed[i][j].size > 0)
      {
        unrevealed[i][j].update();
      }
    }
  }

  // Secondary iteration to place the popped tiles in front of the test
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 9; j++)
    {
      // Code ensures only tiles with a visible size are rendered
      if (unrevealed[i][j].isOpen == false && unrevealed[i][j].size > 0)
      {
        unrevealed[i][j].update();
      }
    }
  }

  // The master statement for all click functionality
  if (lClick == true)
  {
    // If a screen is currently displayed then left click will set the game back to the start
    if (screenContext != 0)
    {
      screenContext = 0;
      lClick = false;
      restart();
    } else
    {
      // Tests to see whether the game has begun, and loads the level as soon as the button is pressed
      if (gameStart == false && canClick == true)
      {
        gameStart = true;
        generateLevel(mouseX/40, mouseY/40);
      }

      // Disables left click to prevent stick keys
      lClick = false;
      // Only opens tiles if the mouse is not on the bottom bar
      if (mouseY < height - 40  && canClick == true)
      {
        // Calls the correct tiles open code if it is moused over
        if (unrevealed[mouseX / 40][mouseY / 40].testMouse() == true && unrevealed[mouseX / 40][mouseY / 40].isFlagged == false)
        {
          unrevealed[mouseX / 40][mouseY / 40].open();
        }
        // Code that divides into the various bottom bar options
      } else if (mouseY > height - 40)
      {
        // Restart button
        if (mouseX < 40)
        {
          restart();
          // Style pack swapper
        } else if (mouseX < 120)
        {
          if (isClassic == true)
          {
            isClassic = false;
          } else
          {
            isClassic = true;
          }
          // Difficulty slider
        } else if (mouseX > 300)
        {
          difficulty = constrain((mouseX - 310)/2, 1, 31);
        }
      }
    }
    // The code responsible for flag placement functionality
  } else if (rClick == true && canClick == true)
  {
    rClick = false;
    // Alternates the flag state based on the currently selected tiles flag status
    if (unrevealed[mouseX / 40][mouseY / 40].isFlagged == true)
    {
      unrevealed[mouseX / 40][mouseY / 40].isFlagged = false;
    } else
    {
      unrevealed[mouseX / 40][mouseY / 40].isFlagged = true;
    }
  }

  // Displays the bottom bar in the correct style catagory
  PImage bottomBar = loadImage("minesweeperBottomBar.png");
  if (isClassic == true)
  {
    bottomBar = loadImage("ClassicBottomBar.png");
  }

  bottomBar.resize(400, 40);
  image(bottomBar, 0, 360);

  // Places the current timer in the center of the screen (USE 1)
  text(time, 200, 390);

  // The slider is manually constructed with the following shapes
  fill(200);
  rect(320, 378, difficulty * 2, 5); // The bar
  stroke(200);
  strokeWeight(3);
  rect((difficulty * 2) + 310, 375, 10, 10); // The playhead
  noStroke();

  // Code that displays a screen if one is selected
  if (screenContext !=0)
  {
    displayScreen();
  }
}

// Code that displays the correct pop-up screen if one is selected
void displayScreen()
{
  // Ensures that the players interaction is limited on the menu
  canClick = false;
  gameStart = false;
  // Prepares to produce the text functions.
  textAlign(CENTER);
  textSize(25);
  fill(0, 0, 0, 100);
  rect(0, 0, 400, 400);
  fill(255);
  // Assigns a string to the correct contents based on screenContext
  String thingSaid;
  if (screenContext == 1)
  {
    thingSaid = "Welcome to MINESWEEPER, baby! Click anywhere to play";
  } else if (screenContext == 2)
  {
    thingSaid = "GAME OVER. You had " + (90 - openedTiles - mines) + " spaces left to clear! Click anywhere to restart";
  } else
  {
    if (time < record)
    {
      record = time;
    }
    thingSaid = "VICTORY. You beat the level in " + time + ". Highscore: " + record + ". Click anywhere to restart";
  }
  text(thingSaid, 60, 120, 270, 280);
}

// The code to generate the level
void generateLevel(int clickedX, int clickedY)
{
  // Sets the mine count to the difficulty selected before continuing
  mines = difficulty;
  for (int i = 0; i < difficulty; i++)
  {
    // Starts by plotting to place a mine at a random spot
    int mineX = int(random(0, 10));
    int mineY = int(random(0, 9));
    // Runs a series of checks to ensure the position is not on another mine, and not within a 9 by 9 of the cursor
    while (map[mineX][mineY] > 8 || (clickedX - 2 < mineX && clickedX + 2 > mineX && clickedY - 2 < mineY && clickedY + 2 > mineY))
    {
      mineX = int(random(0, 10));
      mineY = int(random(0, 9));
    }
    // Upgrades that tile to a 9
    map[mineX][mineY] = 9;
    // Ups the surrounding tiles by 1
    surround(mineX, mineY, 1);
  }
}

// Effects the tiles in a 9 by 9 by a designated effect
void surround(int x, int y, int increase)
{
  // Iterates through the surrounding tiles
  for (int i = -1; i < 2; i++)
  {
    for (int j = -1; j < 2; j++)
    {
      // Only does anything if the tile is on the screen
      if (x + i > -1 && x + i < 10 && y + j > -1 && y + j < 9)
      {
        // Reveals the tiles if increase is set to -1 (found in open)
        if (increase < 0)
        {
          if (unrevealed[x + i][y + j].isOpen == true)
          {
            unrevealed[x + i][y + j].open();
          }
          // Increases the surrounding tiles by 1 (found in generateLevel)
        } else
        {
          map[x + i][y + j] += increase;
        }
      }
    }
  }
}

// Sets two variables corrosponding to mouse controls to the correct value
void mousePressed()
{
  if (mouseButton == LEFT) {
    lClick = true;
  } else if (mouseButton == RIGHT) {
    rClick = true;
  }
}
