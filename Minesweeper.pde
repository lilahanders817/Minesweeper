import de.bezier.guido.*;
public final static int NUM_MINES = 30;
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private boolean gameOver = false;
private boolean gameWon = false;
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
  size(800, 800);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];//your code to initialize buttons goes here
  for (int row = 0; row< NUM_ROWS; row++) {
    for (int col = 0; col< NUM_COLS; col++) {
      buttons[row][col] = new MSButton(row, col);
    }
  }
  setMines();
}
public void setMines()
{
  while (mines.size() < NUM_MINES) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
      //System.out.println(r + "," + c);
    }
  }
}

public void draw ()
{
  for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c].show();
      }
    }
  if (gameOver == true)
    displayLosingMessage();
  if (gameWon == true)
    displayWinningMessage();
  if (gameOver == true || gameWon == true){
    noStroke();
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c].clicked = true;
      }
    }
  }
}
public void displayLosingMessage(){
  fill(0, 0, 0, 120);
  rect(0, 0, width, height);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("YOU LOST", 0, 0, width, height);
}
public void displayWinningMessage(){
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("YOU WON", 0, 0, width, height);
}

public boolean isValid(int r, int c){
  return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 800/NUM_COLS;
    height = 800/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged = !flagged;
    } else if (mines.contains(this)) {
      gameOver = true;
    } else if (countMines(myRow, myCol) > 0) {
      myLabel = ""+ countMines(myRow, myCol);
    } else {
      for (int r = myRow-1; r<=myRow+1; r++) {
        for (int c = myCol-1; c<=myCol+1; c++) {
          if (isValid(r, c) && !mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
    int clickCount = 0;
    int mineFlagCount = 0;
    for (int row = 0; row < NUM_ROWS; row++) {
      for (int col = 0; col < NUM_COLS; col++) {
        if (buttons[row][col].clicked == true) {
          clickCount++;
        }
        if (mines.contains(buttons[row][col]) && buttons[row][col].flagged == true) {
          mineFlagCount++;
        }
      }
    }
    if((clickCount == NUM_ROWS*NUM_COLS)&& mineFlagCount == NUM_MINES){
      gameWon = true;
    }
  }
  public void show(){    
    if(flagged){
      fill(0); 
    }
    else if(clicked && mines.contains(this)){
      fill(150, 45, 45); 
    }
    else if(clicked){
      fill( 0, 250, 0 ); 
      }
    else 
    fill(0, 0, 250); 
    rect(x, y, width, height);
    fill(0);
    textSize(12);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel){
    myLabel = newLabel;
  }
  public void setLabel(int newLabel){
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged(){
    return flagged;
  }
}
