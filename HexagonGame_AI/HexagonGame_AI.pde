// create a main game class
Hexagon hexagon = new GameControl();
int dpt = 5;

/* initial set up functin for the main frame */
void setup(){
  size(400,500); //frame size
  frameRate(60); //frame rate is 60 per second
  strokeWeight(3);
  textSize(20);
}

/* this function will keep executing anything inside of it */
void draw(){
  hexagon.draw();
}

/* call function in main game class when mouse clicked */
void mouseClicked(){
  hexagon.mouseClicked();
}

/* handle keypress */
void keyPressed(){
  hexagon.keyPressed();
}


/* main game class */
abstract class Hexagon {
  
  /* declare values */
  Player player1;//player1 class
  Player player2;//player2 class
  ArrayList<Point>   points    = new ArrayList<Point>(); //store points
  ArrayList<Edge>    s_edges   = new ArrayList<Edge >(); //store solid edges
  ArrayList<Edge>    d_edges   = new ArrayList<Edge >(); //store dotted edges
  ArrayList<Edge>    possible_edges = new ArrayList<Edge>(); //store not-yet-taken edges
  int[] pointStats1 = new int[6]; //store number of edges on each point
  int[] pointStats2 = new int[6]; //store number of edges on each point
  boolean[][] triCheck1 = new boolean[6][6];//store edge info
  boolean[][] triCheck2 = new boolean[6][6];//store edge info
  boolean playerTurn;//True = player1 : False = player2
  boolean gameEnd;   //True = game finished
  String winner;//"" as default
  boolean gameBegin, player1IsCOM;
  boolean firstMove1 = true;
  boolean firstMove2 = true;
  
  /* functions */
  abstract void draw();
  void mouseClicked() { }
  void keyPressed() { } 
}
