/* class to store a point */
class Point extends Hexagon {
  /* values */
  public PVector p;
  public int name;
  
  /* constructor */
  Point( float x, float y, int s ){
    p = new PVector(x, y);
    name = s;
  }
  
  /* main draw function */
  void draw(){
    ellipse( p.x, p.y, 10, 10);
    text(name, p.x+4, p.y-4); 
  }

}
