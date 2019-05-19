/* class to store a player */
class Player extends Hexagon {
  /* values */
  boolean COM = false;
  /* constructor */
  Player(){
  }
  
  /* main draw function */
  void draw(){ }
  
  
  /* check if given array makes a triangle */
  boolean hasTriangle( boolean[][] e, int[] pS ){
    /* search through 20 possible triangle */
    if( pS[0] >= 2 ){  //point1 has more than 2 edges
      if( pS[1] >= 2 ){//point2 has more than 2 edges
        if( (e[0][1] && e[0][2] && e[1][2]) || (e[0][1] && e[0][3] && e[1][3]) ||
            (e[0][1] && e[0][4] && e[1][4]) || (e[0][1] && e[0][5] && e[1][5]) ) return true;
      }
      else if( pS[2] >= 2 && pS[4] >= 2){ //point3 and point5 has more than 2 edges
        if( (e[0][2] && e[2][4] && e[0][4]) ) return true;
      }
    }
    if( pS[1] >= 2 ) {//point2 has more than 2 edges
      if( pS[2] >= 2 ){    //point3 has more thhan 2 edges
        if( (e[1][2] && e[1][3] && e[2][3]) || (e[1][2] && e[1][4] && e[2][4]) ||
            (e[1][2] && e[1][5] && e[2][5]) ) return true;
      }
      else if( pS[3] >= 2 && pS[5] >= 2 ) {//point4 and point6 has more than 2 edges
        if( (e[1][3] && e[3][5] && e[1][5]) ) return true;
      }
    }
    if( pS[2] >= 2 ) {//point3 has more than 2 edges
      if( pS[3] >= 2 ){    //point4 has more than 2 edges
        if( (e[2][3] && e[2][4] && e[3][4]) || (e[2][3] && e[2][5] && e[3][5]) ||
            (e[2][3] && e[2][0] && e[3][0]) ) return true;
      }
    }
    if( pS[3] >= 2 ) {//point4 has more than 2 edges
      if( pS[4] >= 2 ){    //point5 has more than 2 edges
        if( (e[3][4] && e[3][5] && e[4][5]) || (e[3][4] && e[3][0] && e[4][0]) ||
            (e[3][4] && e[3][1] && e[4][1]) ) return true;
      }
    }
    if( pS[4] >= 2 ){//point5 has more than 2 edges
      if( pS[5] >= 2 ){   //point6 has more than 2 edges
        if( (e[4][5] && e[4][0] && e[5][0]) || (e[4][5] && e[4][1] && e[5][1]) ||
            (e[4][5] && e[4][1] && e[5][2]) ) return true;
      }
    }
    if( pS[5] >= 2 ){//point6 has more than 2 edges
      if( pS[0] >= 2 ){   //point1 has more than 2 edges
        if( (e[5][0] && e[5][2] && e[0][2]) || (e[5][0] && e[5][3] && e[0][3]) )
          return true;
      }
    }
      return false;
  } 

}
