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

String configFile = "quads.txt";
ProjectedQuads projectedQuads;
PGraphics main;

void setup() {
  size(800, 600, P3D);
  
  projectedQuads = new ProjectedQuads();  
  projectedQuads.load(configFile);  
  main = createGraphics(800, 600, P2D);
  projectedQuads.getQuad(0).setTexture(main); 
}

void draw() {
  background(0);
  
  //animation code is here
  main.beginDraw();
  main.background(0, 00255);
  main.stroke(255);
  main.strokeWeight(10);
  main.noFill();
  main.rect(0, 0, main.width, main.height);
  main.noStroke();
  main.strokeWeight(3);
  main.fill(255);
  float[] speeds = {1, 1.25, 1.5, 2.0, 2.5, 3};
  for(int i=0; i<speeds.length; i++) {
    float x = main.width * (0.5 + 0.5*sin(frameCount/100.0*speeds[i]));
    main.rect(x, 0, 10*speeds[i], main.height);  
  }
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


