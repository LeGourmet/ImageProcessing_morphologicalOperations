public class Point{
  // ---------- ATTRIBUTS ----------
  public int x;
  public int y;
  public float weight;
  
  // ---------- CONSTRUCTEUR ----------
  public Point(){
    this.x = 0;
    this.y = 0;
    this.weight = 0;
  } 
  
  public Point(int x, int y, float weight){
    this.x = x;
    this.y = y;
    this.weight = weight;
  }  
  
  // ---------- METHODE ----------
  public void add(Point that){
    this.x += that.x;
    this.y += that.y;
  }
  
  public void sub(Point that){
    this.x -= that.x;
    this.y -= that.y;
  }
  
  public void mul(float number){
    this.x *= number;
    this.y *= number;
  }
}
