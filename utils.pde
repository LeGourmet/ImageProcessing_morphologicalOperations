// ------------------------------------------ UTILS FUNCTION ------------------------------------------
float computeDistSq(Point a, Point b){
  return (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y);
}

boolean isValid(int posX, int posY, boolean[][] image, int kernelSize){
  for(int k=-kernelSize; k<=kernelSize ;k++){
    if(posX+k<0 || posX+k>=image.length) continue; // out of bound
    for(int l=-kernelSize; l<=kernelSize ;l++){
      if(posY+l<0 || posY+l>=image[0].length) continue;  // out of bond
      if(!image[posX+k][posY+l]) return false;
    }
  }
  return true;
}

// ------------------------------------------ FIND FACE CENTER ------------------------------------------
Point findFaceCenter(ImageHSV hsv, float phase, float threshold, int erosionFactor){  
  boolean[][] imageBoolean = new boolean[hsv.w][hsv.h];
  ArrayList<Point> whitePixels = new ArrayList<Point>(); 
  Point sum = new Point();
  
  // ---------- double threshold ----------    
  for(int i=0; i<hsv.w*hsv.h ;i++){
    int x=i%hsv.w, y=i/hsv.w;
    imageBoolean[x][y] = (abs((hsv.H[i]+180-phase)%360-180)<=threshold && hsv.V[i]>115.f && hsv.S[i]>0.4f);
    if(imageBoolean[x][y]) whitePixels.add(new Point(x,y,0));
  }
  
  // ---------- erosion ---------- 
  for(int x=whitePixels.size()-1; x>=0 ;x--){
    Point tmp = whitePixels.get(x);
    if(isValid(tmp.x, tmp.y, imageBoolean, erosionFactor)){ sum.add(tmp); }
    else{ whitePixels.remove(x); }
  }
  
  // ---------- compute gravity center  ---------- 
  if(whitePixels.isEmpty()) return new Point(); 
  int nb = whitePixels.size();
    
  // compute the average square distance from each elements and the gravity center
  Point tmp = new Point(int(sum.x/float(nb)),int(sum.y/float(nb)),0.);
  for(Point p : whitePixels) { 
    p.weight = computeDistSq(tmp,p);
    sum.weight += p.weight;
  }
  sum.weight = (sum.weight/nb)*2.f;
  
  // delete all pixel with are to far of the gravity center
  for (int i=nb-1; i>=0 ;i--) {
    tmp = whitePixels.get(i);
    if(tmp.weight>sum.weight){ 
      sum.sub(tmp);
      nb--;
    }
  }
  
  // return the new gravity center
  if(nb==0) return new Point();
  return new Point(sum.x/nb,sum.y/nb,nb);
}

// ------------------------------------------ DISPLAY MODEL ------------------------------------------
void displayModel(Point[] facesCenter, PShape obj, int idFace){ 
  if(idFace<0 || idFace>5 || facesCenter[idFace].weight<=0.f) return;
    
  PVector r = new PVector(0,0,0);
  for(int i=0; i<6 ;i++){
    if(i==idFace || facesCenter[i].weight<=0.f) continue;
    PVector FC = new PVector(facesCenter[idFace].x-facesCenter[i].x,facesCenter[idFace].y-facesCenter[i].y).normalize();
    r.add(PVector.mult(FC,facesCenter[i].weight/(facesCenter[idFace].weight+facesCenter[i].weight)));
    r.z++;
  }
  
  float rad = PI/((r.z+1.f)*2.f); 
  
  obj.resetMatrix();
  obj.scale(0.2);
  obj.rotateX(PI*0.5);
  obj.rotateX(-rad*r.x);
  obj.rotateY(rad*r.y);
  obj.translate(facesCenter[idFace].x,facesCenter[idFace].y);
  
  shape(model);
}
