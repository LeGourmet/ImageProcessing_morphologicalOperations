public class ImageHSV{
  // ---------- ATTRIBUTS ----------
  public float[] H;
  public float[] S;
  public float[] V;
  public int w;
  public int h;
  
  // ---------- CONSTRUCTEUR ----------
  public ImageHSV(PImage img){
    img.loadPixels();
    
    H = new float[img.pixels.length];
    S = new float[img.pixels.length];
    V = new float[img.pixels.length];
    
    w = img.width;
    h = img.height;
    
    float max, min, delta, r, g, b;
    for(int i=0; i<img.pixels.length ;i++){
      // https://processing.org/reference/rightshift.html
      r = (img.pixels[i] >> 16) & 0xFF;
      g = (img.pixels[i] >> 8) & 0xFF;
      b = img.pixels[i] & 0xFF;

      max = max(r,max(g,b));
      min = min(r,min(g,b));
      delta = max-min;

      H[i] = (min==max ? 0.f :
             (max==r ? (60*((g-b)/delta)+360)%360 :
             (max==g ?  60*((b-r)/delta)+120 : 
                        60*((r-g)/delta)+240 )));
    
      S[i] = (max==0 ? 0.f : delta/max);
      V[i] = max;
    }
  }
}
