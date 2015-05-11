int sW = 640;
int sH = 480;
int sD = (sW+sH)/2;
int fps = 60;
int numParticles = 100;
Bacterium[] bacteria = new Bacterium[numParticles];

void setup() {
  //hint( ENABLE_OPENGL_4X_SMOOTH );
  size(sW, sH, P3D);//GLConstants.GLGRAPHICS);
  frameRate(fps);
  // You can load your sprite from a folder of images like this:
  //example = new AnimSprite("runner",12);
  // ...or from a spritesheet like this:
  //example = new AnimSprite("walksequence",12,150,185,6,5);
  // ...and here's a subclass with behaviors already included:
  Bacterium bacterium = new Bacterium();
  for (int i=0;i<bacteria.length;i++) {
    bacteria[i] = new Bacterium(bacterium.frames);
    bacteria[i].make3D(); //adds a Z axis and other features. You can also makeTexture to control individual vertices.
    bacteria[i].p = new PVector(random(sW), random(sH), random(sD)-(sD/2));
    bacteria[i].index = random(bacteria[i].frames.length);
    bacteria[i].r = 0;
    bacteria[i].t = new PVector(random(sW), random(sH), random(sD)-(sD/2));
  }
  //May not be supported in Processing 2.
  //setupGl(); //goes LAST in setup
background(0);
}

void draw() {
  //May not be supported in Processing 2.
  //drawGl(); //goes FIRST in draw
  drawMain();
  println(frameRate);
}

void drawMain(){
  noStroke();
  fill(0,70);
  rectMode(CORNER);
  rect(0,0,width,height);
  for (int i=0;i<bacteria.length;i++) {
    bacteria[i].run();
    if(mousePressed){
      noFill();
      strokeWeight(random(1,5));
      stroke(255,50,0,random(1,5));
      beginShape();
      vertex(bacteria[i].p.x,bacteria[i].p.y,bacteria[i].p.z);
      vertex(mouseX,mouseY,0);
      endShape();
    }
  }
}
void keyPressed() {
  for (int i=0;i<bacteria.length;i++) {
    bacteria[i].loopIn = 10;
    bacteria[i].loopOut = 12;
  }
}

