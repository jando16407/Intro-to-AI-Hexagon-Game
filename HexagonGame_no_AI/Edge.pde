/* class to store en edge */
class Edge extends Hexagon {
  /* values */
  Point p0, p1;
  String name;
  
  /* constructor */
  Edge( Point _p0, Point _p1, String s ){
    p0 = _p0; p1 = _p1;
    name = s;
  }
  
  /* main draw function */
  void draw(){
    line( p0.p.x, p0.p.y, p1.p.x, p1.p.y );
    //text(name, (p0.p.x+p1.p.x)*0.5, (p0.p.y+p1.p.y)*0.5);
  }
  
  /* function to draw dotted line */
  void drawDotted(){
    float steps = PVector.dist(p0.p, p1.p)/6;
    for( int i=0; i<steps; i++ ){
      float x = lerp(p0.p.x, p1.p.x, i/steps);
      float y = lerp(p0.p.y, p1.p.y, i/steps);
      ellipse(x, y, 2, 2);
    }
    //text(name, (p0.p.x+p1.p.x)*0.5, (p0.p.y+p1.p.y)*0.5);
  }
  
}
