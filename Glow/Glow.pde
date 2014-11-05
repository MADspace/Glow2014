/*
  Keyboard:
  - 'd' toggle debug mode
  - 'S' save settings
  - 'L' load settings
  - '>' select next quad in debug mode
  - '<' select prev quad in debug mode
  - '1', '2', '3', '4' select one of selected quad's corners 
  - Arrow keys (left, right, up, down) move selected corner's position (you can also use mouse for that)  
*/

import org.openkinect.*;
import org.openkinect.processing.*;

String configFile = "quads.txt";
ProjectedQuads projectedQuads;
PGraphics main;

Kinect kinect;

// Size of kinect image
int w = 640;
int h = 480;
float[] depthLookUp = new float[2048];

void setup() {
  size(800, 600, P3D);
  
  projectedQuads = new ProjectedQuads();  
  projectedQuads.load(configFile);  
  main = createGraphics(800, 600, P2D);
  projectedQuads.getQuad(0).setTexture(main);
 
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true); 
 
}

void draw() {
  background(0);
  
  //animation code is here
  main.beginDraw();
  main.image(kinect.getDepthImage(), 0, 0, 800, 600);
  main.endDraw();
  
  //draw projected quads on the screen
  projectedQuads.draw();
}

void keyPressed() {
  projectedQuads.keyPressed();
}

void mousePressed() {
  projectedQuads.mousePressed();
}

void mouseDragged() {
  projectedQuads.mouseDragged();
}


