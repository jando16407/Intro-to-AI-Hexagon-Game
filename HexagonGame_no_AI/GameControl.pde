/* main class for the hexagon game */
class GameControl extends Hexagon {
  /* constructor */
  GameControl(){
    set_init();
  }
  
  /* this function will keep executing anything inside of it */
  void draw(){
    background(255); // set the background color to white
    surface.setTitle(int(frameRate) + " fps  : " + mouseOnHexagon()+"X: "+mouseX+", Y: "+mouseY); //dislpay title
    
    //set drawing format
    fill(0);
    stroke(0);
    
    /* draw solid lines */
    for( Edge e : s_edges ){
      e.draw();
    }
    /* draw dotted line */
    for( Edge e : d_edges ){
      e.drawDotted();
    }
    /* draw possible lines and highlight it when mouse is over */
    if( mouseOnHexagon() && !gameEnd && !gameBegin ) drawMouseOver(possible_edges, playerTurn);
    
    /* draw the points */
    for( Point p : points ){
      stroke(0);
      fill(0);
     p.draw();
    }
    
    /* display texts */
    /* display winner and ask player to restart the game */
    if( gameEnd ){
      textSize(30);
      text(winner, 15, 35);
      textSize(20);
      text("Press 's' to restart the game", 15, 70);
    }
    /* ask player to choose from player1 or player2 */
    /* also highlight the player when mouse is over */
    if( gameBegin ){
      text("Choose player number:", 15, 20);
      textSize(50);
      if( mouseOn1() )fill(255,0,0);
      text("1",120,80);fill(0);fill(0);
      if( mouseOn2() )fill(255,0,0);
      text("2",240,80);;fill(0);
      textSize(20);
    }
    /* during game display show who's turn */
    else {
      if(!gameEnd) text(((playerTurn)?"Player1":"Player2")+"'s Turn", 15, 20);
    }
  }
  
  
  /* when mouse is clicked */
  void mouseClicked(){
    if(!gameEnd && !gameBegin){
      int index = drawMouseOver(possible_edges, playerTurn);//get index of current edge that mouse is over
      if( index>=0 ) {//this means a user clicked on a possible edge
        if( playerTurn ) 
        { 
                           s_edges.add( possible_edges.get(index) );//add the edge to current player
                           int p1 = Integer.parseInt(possible_edges.get(index).p0.name)-1;//point name in the edge
                           int p2 = Integer.parseInt(possible_edges.get(index).p1.name)-1;//point name in the edge
                           pointStats1[p1]++;//update point info
                           pointStats1[p2]++;//for player1
                           triCheck1[p1][p2] = true;//update edge info
                           triCheck1[p2][p1] = true;//for player1
                           if( player1.hasTriangle(triCheck1, pointStats1) ){
                             println("Player 2 win");
                             winner = "Player2 win!!";
                             gameEnd = true;
                           }
                           playerTurn = false;                      
        }
        else             
        { 
                           d_edges.add( possible_edges.get(index) );//for player2
                           int p1 = Integer.parseInt(possible_edges.get(index).p0.name)-1;//point name in the edge
                           int p2 = Integer.parseInt(possible_edges.get(index).p1.name)-1;//point name in the edge
                           pointStats2[p1]++;//update point info
                           pointStats2[p2]++;//for player2
                           triCheck2[p1][p2] = true;//update edge info
                           triCheck2[p2][p1] = true;//for player2
                           if( player2.hasTriangle(triCheck2, pointStats2) ){
                             println("Player 1 win");
                             winner = "Player1 win!!";
                             gameEnd = true;
                           }
                           playerTurn = true; 
        }
        possible_edges.remove(index); //remove the edge from possible index
      }
    }
    /* when game starts ask player to go first or second */
    else if( gameBegin && mouseOn1() ){//when a user clicks player1
      playerTurn = true;
      gameBegin = false;
    }
    else if( gameBegin && mouseOn2() ){//when a user clicks player2
      playerTurn = false;
      gameBegin = false;
    }
  }
  
  /* return true if mouse position is on hexagon */
  boolean mouseOnHexagon(){
    //don't check if not in hexagon
    if ((mouseY < 155) || (445 < mouseY) ||
        (mouseX < 35 ) || (365 < mouseX) )  return false;
    else return true;
  }
  
  /* return true if mouse position is on player 1 */
  boolean mouseOn1(){
    if( (110 < mouseX) && (mouseX < 160) &&
        (40 < mouseY) && (mouseY < 80) )  return true;
    return false;
  }
  /* return true if mouse position is on player 2 */
  boolean mouseOn2(){
    if( (210 < mouseX) && (mouseX < 260) &&
        (40 < mouseY) && (mouseY < 80) )  return true;
    return false;
  }
  
  
  /* draw possible lines and highlight it when mouse is over */
  /* returns index of highlighted edge, -1 otherwise  */
  int drawMouseOver( ArrayList<Edge> possible_edges, boolean playerTurn ){
    int index = 0, mouseOnEdge = -1; //index of current edge and return value
    /* check each line in possible edges */
    for( Edge e : possible_edges ){
      float step = PVector.dist(e.p0.p, e.p1.p)/3; //break the line into 3 pixels long
      /* check every 3 pixels if mouse is over */
      for( int i=0; i<step; i++ ){
        float x = lerp(e.p0.p.x, e.p1.p.x, i/step);
        float y = lerp(e.p0.p.y, e.p1.p.y, i/step);
        /* when mouse is over current edge */
        if( (x-3) < mouseX && mouseX < (x+3) &&
            (y-3) < mouseY && mouseY < (y+3) ){
          stroke(100,200,100); //change line color to green
          fill(100,200,100);
          mouseOnEdge = index;
          break;//get out of loop
        } 
        /* else keep the color grey */
        else { stroke(242, 242, 242); fill(242,242,242); }
      }
      if( playerTurn ) e.draw();//draw the possible line
      else e.drawDotted();
      index++; //increment index
    }
    return mouseOnEdge; /* return actual index if found, or -1 if not */
  }
  
  /* handle keypressed */
  void keyPressed(){
    if( key == 's' && gameEnd ){
      set_init();
    }
  }
  
  /* initialization */
  void set_init(){
    /* create players */
    if( player1==null ) player1 = new Player();
    if( player2==null ) player2 = new Player();
    /* initialize points */
    points.clear();
    points.add( new Point(120,160, "1") );
    points.add( new Point(280,160, "2") );
    points.add( new Point(360,300, "3") );
    points.add( new Point(280,440, "4") );
    points.add( new Point(120,440, "5") );
    points.add( new Point(40, 300, "6") );
    /* initialize s_edges and d_edges */
    s_edges.clear();
    d_edges.clear();
    /* initialize possible edges */
    possible_edges.clear();
    int k = 0;
    for( int i=0; i<6; i++ ){
      for( int j=i+1; j<6; j++ ){
        possible_edges.add( new Edge(points.get(i), points.get(j), Integer.toString(k)) );
        k++;
      }
    }
    /* initialize pointStats */
    for( int i=0; i<6; i++ ){
      pointStats1[i] = 0;
      pointStats2[i] = 0;
    }
    /* initialize tiChecks that is 2D array to store edge existing */
    for( int i=0; i<6; i++ ){
      for( int j=0; j<6; j++ ){
        triCheck1[i][j] = false;
        triCheck2[i][j] = false;
      }
    }
    /* initialize playerTurn */
    playerTurn = true;
    /* initialize gameEnd */
    gameEnd = false;
    /* initialize winner */
    winner = "";
    /* initialize gameBegin */
    gameBegin = true;
    
  }
  
}
