import processing.video.*;

// -----------------------------------  GLOBAL VARIABLES -----------------------------------
PShape model;
Movie movie;
PImage image;
boolean isDrawable = false;

// ------------------------------------------ SETUP -----------------------------------------
void setup(){
  size(640,480,P3D);
  model = loadShape("datas/cat.obj");
  movie = new Movie(this, "../datas/webcam.mov");
  movie.loop();
}

// ------------------------------------------ DRAW ------------------------------------------
void draw(){
  if(isDrawable){
    background(image);
    ImageHSV imgHSV = new ImageHSV(image);
    
    Point[] facesCenter = {
      findFaceCenter(imgHSV, 40,  10, 9), // ORANGE
      findFaceCenter(imgHSV, 70,  10, 9), // YELLOW   
      findFaceCenter(imgHSV, 120, 30, 6), // GREEN      
      findFaceCenter(imgHSV, 240, 20, 6), // BLUE      
      findFaceCenter(imgHSV, 300, 20, 6), // MAGENTA   
      findFaceCenter(imgHSV, 355, 15, 9)  // RED  
    };
    
    displayModel(facesCenter,model,5);
    
    isDrawable = false;
  } 
}

void movieEvent(Movie m) {
  m.read();
  image = m;
  isDrawable = true;
}
