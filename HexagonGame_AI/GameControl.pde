/* main class for the hexagon game */
class GameControl extends Hexagon {
  /* constructor */
  GameControl(){
    set_init();
  }
  
  /* this function will keep executing anything inside of it */
  void draw(){
    background(255); // set the background color to white
    surface.setTitle(int(frameRate) + " fps  : " + mouseOnHexagon()+", X: "+mouseX+", Y: "+mouseY); //dislpay title
    
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
    
    /* let AI move if its turn */
    //when player1 is COM
    if( player1IsCOM && playerTurn && !gameEnd && !gameBegin ) {
      println("Psize Original"+possible_edges.size());
      /* return true when it makes a triangle */
      if( player1.agent(s_edges, d_edges, possible_edges, pointStats1, triCheck1, pointStats2, triCheck2, firstMove1) ){
        println("Player 2 win");
        winner = "Player2 win!!";
        gameEnd = true;
      }
      firstMove1 = false;
      playerTurn = false;
    }
    //when player2 is COM
    else if( !player1IsCOM && !playerTurn && !gameEnd && !gameBegin ) {
      println("Psize Original"+possible_edges.size());
      /* return true when it makes a triangle */
      if( player2.agent(d_edges, s_edges, possible_edges, pointStats2, triCheck2, pointStats1, triCheck1, firstMove2) ){
        println("Player 1 win");
        winner = "Player1 win!!";
        gameEnd = true;
      }
      firstMove2 = false;
      playerTurn = true;
    }
  }
  
  
  /* when mouse is clicked */
  void mouseClicked(){
    if(!gameEnd && !gameBegin && ((player1IsCOM && !playerTurn) || (!player1IsCOM && playerTurn)) ){
      int name = drawMouseOver(possible_edges, playerTurn);//get index of current edge that mouse is over
      println("Clicked name = "+name);
      if( name>=0 ) {//this means a user clicked on a possible edge
        if( playerTurn ) 
        { 
          s_edges = player1.selectedEdgeAdd(s_edges, possible_edges, name, pointStats1, triCheck1); 
                           if( player1.hasTriangle(triCheck1, pointStats1) ){
                             println("Player 2 win");
                             winner = "Player2 win!!";
                             gameEnd = true;
                           }
                           playerTurn = false;       
        }
        else             
        { 
          d_edges = player2.selectedEdgeAdd(d_edges, possible_edges, name, pointStats2, triCheck2);
                           if( player2.hasTriangle(triCheck2, pointStats2) ){
                             println("Player 1 win");
                             winner = "Player1 win!!";
                             gameEnd = true;
                           }
                           playerTurn = true; 
        }
        int index = -1;
        for( int i=0; i<possible_edges.size(); i++ ){
          if( possible_edges.get(i).name == name ) index = i;
        }
        println("To be removed p_edge name = "+possible_edges.get(index).name);
        possible_edges.remove(index); //remove the edge from possible index
      }
    }
    /* when game starts ask player to go first or second */
    else if( gameBegin && mouseOn1() ){//when a user clicks player1
      playerTurn = true;
      player2.COM = true;
      player1IsCOM = false;
      gameBegin = false;
    }
    else if( gameBegin && mouseOn2() ){//when a user clicks player2
      playerTurn = false;
      player1.COM = true;
      player1IsCOM = true;
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
    int mouseOnEdge = -1; //index of current edge and return value
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
          mouseOnEdge = e.name;
          break;//get out of loop
        } 
        /* else keep the color grey */
        else { stroke(242, 242, 242); fill(242,242,242); }
      }
      if( playerTurn ) e.draw();//draw the possible line
      else e.drawDotted();
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
    points.add( new Point(120,160, 1) );
    points.add( new Point(280,160, 2) );
    points.add( new Point(360,300, 3) );
    points.add( new Point(280,440, 4) );
    points.add( new Point(120,440, 5) );
    points.add( new Point(40, 300, 6) );
    /* initialize s_edges and d_edges */
    s_edges.clear();
    d_edges.clear();
    /* initialize possible edges */
    possible_edges.clear();
    int k = 0;
    for( int i=0; i<6; i++ ){
      for( int j=i+1; j<6; j++ ){
        possible_edges.add( new Edge(points.get(i), points.get(j), k ));//Integer.toString(k)) );
        k++;
      }
    }
    println("Size of possible_edges :"+possible_edges.size());
    for( Edge e:possible_edges){
      println("name="+e.name+", p0="+e.p0.name+", p1="+e.p1.name);
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
    /* initialize who is COM */
    if( !gameBegin ) player1IsCOM = true;
    /* initialize firstMove */
    firstMove1 = true;
    firstMove2 = true;
  }
  
}
