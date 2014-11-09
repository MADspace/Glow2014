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
import gab.opencv.*;

String configFile = "quads.txt";
ProjectedQuads projectedQuads;
PGraphics main, warp;

Kinect kinect;
OpenCV opencv;
HScrollbar rangeClose, rangeFar;

boolean debug = true;
boolean kalibrate = true;
PImage mask;

 public int sketchWidth() {
    return displayWidth;
  }

  public int sketchHeight() {
    return displayHeight;
  }

  public String sketchRenderer() {
    return P3D; 
  }


boolean sketchFullScreen() {
  return true;
}

int main_width = 800;
int main_height = 600;

void setup() {
  
  projectedQuads = new ProjectedQuads();  
  projectedQuads.load(configFile);
  main = createGraphics(main_width, main_height, P2D);
  
  projectedQuads.getQuad(0).setTexture(main);
  projectedQuads.getQuad(1).setTexture(createGraphics(1, 1, P2D));
 
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.enableRGB(true);  
 
  opencv = new OpenCV(this, main_width, main_height);
  
  rangeClose = new HScrollbar(0, 50, 512, 16, 1);
  rangeFar = new HScrollbar(0, 100, 512, 16, 1);
  rangeClose.newspos = 132;
  rangeFar.newspos = 255;
  
  mask = createImage(640, 480, RGB);
  mask.loadPixels();
  for (int i = 0; i < mask.pixels.length; i++) {
    mask.pixels[i] = color(255, 255, 255); 
  }
  mask.updatePixels();
  src = new PImage(main_width, main_height);
  
}

class State {
  org.opencv.core.Mat m;
  int r = 204, g = 102, b = 0, a = 255;
}

ArrayList<State> history = new ArrayList<State>();
PImage src;

void draw() {
  PImage k = kinect.getDepthImage().get();
  if(!debug)
    k.mask(mask);
  
  
  src.blend(k, 0, 0, 640, 480, 0, 0, main_width, main_height, BLEND);
  
  
  int near = (int)(rangeClose.newspos);
  int far = (int)(rangeFar.newspos);
  background(0);
  main.beginDraw();
  
  
  opencv.loadImage(src);
  opencv.blur(20);
  opencv.inRange(near, far);
  
  if(debug) {
    
    
    if(kalibrate) {
      main.background(0, 0);
      main.image(kinect.getVideoImage().get(), 0, 0, displayWidth, displayHeight);
      
    } else {
      //main.image(src, 0, 0, main_width, main_height);
    //main.image(opencv.getSnapshot(), 0, 0, main_width, main_height);
      main.image(opencv.getSnapshot(), 0, 0, main_width, main_height);
  }
    
  } else {
    main.background(0);
    if(history.size() > 0) {
      State s = history.get(0); 
      s.m = opencv.matGray;
      s.r = (frameCount*5) % 255;
      s.g = 255;
      s.b = 255;
      
      main.stroke(s.r, s.g, s.b);
      main.rect(0, 0, main_width-1, main_height-1); 
    }
    
    if(frameCount % 3 == 0) {
      
      State state = new State();
      state.m = opencv.matGray.clone();
      
      history.add(0, state);
      while(history.size() > 15) {
        history.remove(history.size()-1);
      }
    }
    
    for(State s : history) {
      opencv.matGray = s.m;
      
      opencv.dilate();
      
      opencv.matGray = opencv.matGray.clone();
      ArrayList<Contour> contours = opencv.findContours();
      
      main.noFill();
      s.a -= 7;
      main.colorMode(HSB, 255);
      
      main.stroke(s.r, s.g, s.b, s.a);
      main.hint(ENABLE_STROKE_PURE);
      
      for(Contour c : contours) {
        main.beginShape();
        for (PVector p : c.getPoints()) {
          main.vertex(p.x, p.y);
        }
    
        main.endShape(PConstants.CLOSE);
      }
    }
  }
  main.endDraw();
  
  projectedQuads.draw();
  
  if(debug) {
        rangeClose.update();
    rangeFar.update();
    rangeClose.display();
    rangeFar.display();
    
        fill(255, 0, 0);
    textSize(10);
    text(near + " near", 300, 50);
    text(far + " far", 350, 50);
  }
  
  
  
  
}

void keyPressed() {
  if(key == 'd') {
    debug = !debug;
  }
  if(key == 'k') {
    kalibrate = !kalibrate;
  }
  projectedQuads.keyPressed();
}

void mousePressed() {
  projectedQuads.mousePressed();
}

void mouseDragged() {
  projectedQuads.mouseDragged();
}


