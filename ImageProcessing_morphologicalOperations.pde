import processing.video.*;

// -----------------------------------  GLOBAL VARIABLES -----------------------------------
enum FACE_COLOR{ RED, GREEN, BLUE, YELLOW, ORANGE, MAGENTA }

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
      findFaceCenter(imgHSV, 40,  10, 9), // FACE_COLOR.ORANGE
      findFaceCenter(imgHSV, 70,  10, 9), // FACE_COLOR.YELLOW   
      findFaceCenter(imgHSV, 120, 30, 6), // FACE_COLOR.GREEN      
      findFaceCenter(imgHSV, 240, 20, 6), // FACE_COLOR.BLUE      
      findFaceCenter(imgHSV, 300, 20, 6), // FACE_COLOR.MAGENTA   
      findFaceCenter(imgHSV, 355, 15, 9)  // FACE_COLOR.RED  
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
