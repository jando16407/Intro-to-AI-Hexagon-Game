/* class to store a player */
class Player extends Hexagon {
  /* values */
  boolean COM = false;
  /* constructor */
  Player(){
  }
  
  /* main draw function */
  void draw(){
  }
  
  
  /* check if given array makes a triangle */
  boolean hasTriangle( boolean[][] e, int[] pS ){
    /* search through 20 possible triangle */
    if( pS[0] >= 2 ){  //point1 has more than 2 edges
      if( pS[1] >= 2 ){//point2 has more than 2 edges
        if( (e[0][1] && e[0][2] && e[1][2]) || (e[0][1] && e[0][3] && e[1][3]) ||
            (e[0][1] && e[0][4] && e[1][4]) || (e[0][1] && e[0][5] && e[1][5]) ) {
          return true;}
      }
      else if( pS[2] >= 2 && pS[4] >= 2){ //point3 and point5 has more than 2 edges
        if( (e[0][2] && e[2][4] && e[0][4]) ) {
      return true;}
      }
    }
    if( pS[1] >= 2 ) {//point2 has more than 2 edges
      if( pS[2] >= 2 ){    //point3 has more thhan 2 edges
        if( (e[1][2] && e[1][3] && e[2][3]) || (e[1][2] && e[1][4] && e[2][4]) ||
            (e[1][2] && e[1][5] && e[2][5]) ) {
          return true;}
      }
      else if( pS[3] >= 2 && pS[5] >= 2 ) {//point4 and point6 has more than 2 edges
        if( (e[1][3] && e[3][5] && e[1][5]) ) {
      return true;}
      }
    }
    if( pS[2] >= 2 ) {//point3 has more than 2 edges
      if( pS[3] >= 2 ){    //point4 has more than 2 edges
        if( (e[2][3] && e[2][4] && e[3][4]) || (e[2][3] && e[2][5] && e[3][5]) ||
            (e[2][3] && e[2][0] && e[3][0]) ) 
          return true;}
      }
    }
    if( pS[3] >= 2 ) {//point4 has more than 2 edges
      if( pS[4] >= 2 ){    //point5 has more than 2 edges
        if( (e[3][4] && e[3][5] && e[4][5]) || (e[3][4] && e[3][0] && e[4][0]) ||
            (e[3][4] && e[3][1] && e[4][1]) ) {
          return true;}
      }
    }
    if( pS[4] >= 2 ){//point5 has more than 2 edges
      if( pS[5] >= 2 ){   //point6 has more than 2 edges
        if( (e[4][5] && e[4][0] && e[5][0]) || (e[4][5] && e[4][1] && e[5][1]) ||
            (e[4][5] && e[4][2] && e[5][2]) ) {
          return true;}
      }
    }
    if( pS[5] >= 2 ){//point6 has more than 2 edges
      if( pS[0] >= 2 ){   //point1 has more than 2 edges
        if( (e[5][0] && e[5][2] && e[0][2]) || (e[5][0] && e[5][3] && e[0][3]) ){
          return true;}
      }
    }
      return false;
  } 
  
  
  /* returns true if the current player made a triangle */
  /* use minimax to find the best move */
  /* pS1/tC1 is the player COM and pS2/tC2 is opponent */
    boolean agent( ArrayList<Edge> edges1, ArrayList<Edge> edges2, ArrayList<Edge> p_edges, int[] pS1, boolean[][] tC1, int[] pS2, boolean[][] tC2, boolean firstMove ){
    
      for(int i=0;i<150;i++){print("*");}println("");
      for(int i=0;i<150;i++){print("-");}println("");
      for(int i=0;i<150;i++){print("*");}println(""); //println("size of p_edges="+p_edges.size());
      
      int depth = dpt;
      boolean comTurn = true; //println();println("findBestMove, p_e.size() = "+p_edges.size());
      //rtn.p.x is return value for minimax
      //rtn.p.y is index value
      Point rtn = new Point(-1,-1,-1);
      
      if( firstMove ){
        firstMove = false;
        println("First move");
        boolean notFound = true;
        //find first random value and make sure it's not taken
        while( notFound ){
          rtn.p.y = int(random(0,15));//edge name
          for( Edge e : p_edges ){
            if( int(rtn.p.y) == e.name ) notFound = false;
          }
        }
        
      }
      else {
        /* find the best move */
        println("After Second move\n**************************************************************************");
        rtn = minimax( edges1, edges2, p_edges, pS1, tC1, pS2, tC2, depth, comTurn );
        println("\nReturned bestMoveIndex = "+int(rtn.p.y));
      } //println("Best move index :"+bestMoveIndex); //println("Error 2?")//;
      
//      println("AGENT SELECT EDGE ADDING... name="+int(rtn.p.y));
      
      
      selectedEdgeAdd( edges1, p_edges, int(rtn.p.y), pS1, tC1 );
//      println("AGENT SELECT EDGE ADDING...SUCCESS");
      int index = -1;
      for( int i=0; i<p_edges.size(); i++ ){
        if( p_edges.get(i).name == int(rtn.p.y) ) index = i;
      }
//      println("To be removed p_edge name = "+p_edges.get(index).name);
      p_edges.remove(index);//remove the edge from possible edge
      // return true if it maks a triangle 
      if( hasTriangle(tC1, pS1) ){
        return true;
      }
      return false;
    }
  
  Point minimax(ArrayList<Edge> edges1, ArrayList<Edge> edges2, ArrayList<Edge> p_edges, int[] pS1, boolean[][] tC1, int[] pS2, boolean[][] tC2, int depth, boolean comTurn ){
    //println("size of p_edgesMINI="+p_edges.size());
    //Create a point variable to store return value
    Point rtn = new Point(-1,-1,-1);
    
    /* Return if depth is 0 or there's no more child node */
    if( depth == 0 || p_edges.size() == 0 ){
      rtn.p.x = findUtility( pS1, tC1, pS2, tC2 );
//      print("d[0]\trtn["+int(rtn.p.x)+"]\t");
      return rtn;
    }
//    println("");
    // when COM's turn 
    if( comTurn ){
          int score_max = -1000;
          int rtnName = -1;
          for( int i=0; i<p_edges.size(); i++ ){
                ArrayList<Edge> _edges1 = new ArrayList<Edge>();for(Edge e:edges1){_edges1.add(e);}
                ArrayList<Edge> _edges2 = new ArrayList<Edge>();for(Edge e:edges2){_edges2.add(e);}
                ArrayList<Edge> _p_edges = new ArrayList<Edge>();for(Edge e:p_edges){_p_edges.add(e);}
                int[] _pS1 = new int[6];for(int j=0;j<6;j++){_pS1[j]=pS1[j];}
                int[] _pS2 = new int[6];for(int k=0;k<6;k++){_pS2[k]=pS2[k];}
                boolean[][] _tC1 = new boolean[6][6];for(int j=0;j<6;j++){;for(int k=0;k<6;k++){_tC1[j][k]=tC1[j][k];}}
                boolean[][] _tC2 = new boolean[6][6];for(int j=0;j<6;j++){for(int k=0;k<6;k++){_tC2[j][k]=tC2[j][k];}}
                int name = _p_edges.get(i).name;
                selectedEdgeAdd( _edges1, _p_edges, _p_edges.get(i).name, _pS1, _tC1 );
//                println("To be removed p_edge in comTurn = "+_p_edges.get(i).name);
                _p_edges.remove(i);
                //print("p_edgeIndex= "+i+", name= "+name);
                rtn = minimax( _edges1, _edges2, _p_edges, _pS1, _tC1, _pS2, _tC2, depth-1, !comTurn );
   //             _edges1.clear(); _edges2.clear(); _p_edges.clear();
                if( int(rtn.p.x) > score_max ){
                  score_max = int(rtn.p.x);
                  rtnName = name; //edge name
                }
                else if( int(rtn.p.x) == score_max ){
                //randomly selects min index if the score is the same
                if( int(random(0, 20)%2) == 1 ){
                  rtnName = name; //return _p_edge index
 //                 print("\tRandomly ["+rtnName+"]\t");
                }
              }
 //             println("d["+depth+"] i["+i+"]\tscore["+int(rtn.p.x)+"]\tname["+name+"]\tmax["+score_max+"]\trtnName["+rtnName+"] ");
          } 
          rtn.p.x = score_max;
          rtn.p.y = rtnName;
//          println("+++++depth["+depth+"]\tScore_max["+int(rtn.p.x)+"]\tName["+int(rtn.p.y)+"]\n");
          return rtn;
    }
    //* when opponent's turn 
    else {
        int score_min = 1000;
        int rtnName = -1;
        
        for( int i=0; i<p_edges.size(); i++ ){
              //selectedEdgeAdd( edges2, p_edges, index, pS2, tC2 );
              ArrayList<Edge> _edges1 = new ArrayList<Edge>();for(Edge e:edges1){_edges1.add(e);}
              ArrayList<Edge> _edges2 = new ArrayList<Edge>();for(Edge e:edges2){_edges2.add(e);}
              ArrayList<Edge> _p_edges = new ArrayList<Edge>();for(Edge e:p_edges){_p_edges.add(e);}
              int[] _pS1 = new int[6];for(int j=0;j<6;j++){_pS1[j]=pS1[j];}
              int[] _pS2 = new int[6];for(int k=0;k<6;k++){_pS2[k]=pS2[k];}
              boolean[][] _tC1 = new boolean[6][6];for(int j=0;j<6;j++){for(int k=0;k<6;k++){_tC1[j][k]=tC1[j][k];}}
              boolean[][] _tC2 = new boolean[6][6];for(int j=0;j<6;j++){for(int k=0;k<6;k++){_tC2[j][k]=tC2[j][k];}}
              int name = _p_edges.get(i).name;
              selectedEdgeAdd( _edges2, _p_edges, _p_edges.get(i).name, _pS2, _tC2 );
//              println("To be removed p_edge in !comTurn = "+_p_edges.get(i).name);
              _p_edges.remove(i);
              //print("p_edgeIndex= "+i+", name= "+name);
              rtn = minimax( _edges1, _edges2, _p_edges, _pS1, _tC1, _pS2, _tC2, depth-1, !comTurn );
     //         _edges1.clear(); _edges2.clear(); _p_edges.clear();
              if( int(rtn.p.x) < score_min ){
                score_min = int(rtn.p.x);
                rtnName = name;
              }
              else if( int(rtn.p.x) == score_min ){
                //randomly selects min index if the score is the same
                if( int(random(0, 20)%2) == 0 ){
                  rtnName = name;
 //                 print("\tRandomly ["+rtnName+"]\t");
                }
              }
//              println("d["+depth+"]i["+i+"]\tscore["+int(rtn.p.x)+"]\tname["+name+"]\tmin["+score_min+"]\trtnName["+rtnName+"] \n");
        } //println("\nScore_min :"+score_min+", index :"+index);
        rtn.p.x = score_min;
        rtn.p.y = rtnName;
//      println("-----depth["+depth+"]\tScore_min["+int(rtn.p.x)+"]\tName["+int(rtn.p.y)+"]\n\n");
        return rtn;
    } //return 0;
  }
  
 
  /* find utility value */
  int findUtility( int[] pS1, boolean[][] tC1, int[] pS2, boolean[][] tC2 ){
    int rtn = 0;
    //Check player1's edge
    if( hasTriangle( tC2, pS2 )){
      rtn += 50;
    }
    else {
      for( int i=0; i<6; ++i ){
        if( pS2[i] > 1 ){
          rtn += pS2[i];
        }
      }
    }
    //Check player2's edge
    if( hasTriangle( tC1, pS1 )){
      rtn -= 50;
    }
    else {
      for( int i=0; i<6; ++i ){
        if( pS1[i] > 1 ){
          rtn -= pS1[i];
        }
      }
    }
    return rtn;
  }


  /* helper function */
  ArrayList<Edge> selectedEdgeAdd( ArrayList<Edge> edges, ArrayList<Edge> p_edges, int name, int[] pS, boolean[][] tC ){
    int index = -1;
    for( int i=0; i<p_edges.size(); i++ ){
      if( p_edges.get(i).name == name ) index = i;
    }
    edges.add( p_edges.get(index) );//add the edge to current player
    int p1 = p_edges.get(index).p0.name-1;//point name in the edge
    int p2 = p_edges.get(index).p1.name-1;//point name in the edge
    pS[p1]++; pS[p2]++;//update point info for the current player
    tC[p1][p2]=true; tC[p2][p1]=true;//update edge info for the current player
    return edges;
  }
}
