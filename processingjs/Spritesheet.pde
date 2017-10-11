/* @pjs preload="data/bacterium.png, data/bg_5.gif, data/walksequence.png"; */

PImage bg;
color bgColor = color(10,0,20);
int fade = 100;
int numParticles = 10;
float gravityNum = 8;
float floorNum = 350;
Bacterium[] bacteria = new Bacterium[numParticles];
Human bob;
PFont font;
int fontSize = 14;

boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;

void setup() {
  size(640,480);
  frameRate(30);
  bg = loadImage("data/bg_5.gif");
  for(int i=0;i<bacteria.length;i++) {
    bacteria[i] = new Bacterium(random(width),random(height));
  }
  bob = new Human(0,300);
  font = createFont("Arial", fontSize);
}

void draw() {
  background(0);
  imageMode(CORNER);
  image(bg,0,0,width,height);
  noStroke();
  fill(bgColor);
  rect(0,floorNum+50,width,height);

  bob.y = bob.gravity(bob.y, floorNum, gravityNum);

  bob.update();

  for(int i=0;i<bacteria.length;i++) {
    bacteria[i].y = bacteria[i].gravity(bacteria[i].y, floorNum+75, gravityNum);
    bacteria[i].update();
  }
  
  
fill(255,0,0);
textFont(font,fontSize);
text("left: " + left,10,20);
text("right: " + right,90,20);
text("jump: " + (!bob.jumpReady),180,20);
text("click: " + (mousePressed),270,20);
}


void mousePressed() {
  for(int i=0;i<bacteria.length;i++) {
    bacteria[i].goTo("play");
  }
}

void mouseReleased() {
  for(int i=0;i<bacteria.length;i++) {
    bacteria[i].goTo("stop");
  }
}

void keyPressed(){
  if (keyCode==LEFT&&!left) {
    left=true;
    right=false;
    bob.goTo("runLeft");
  } 
  else if(keyCode==RIGHT&&!right) {
    left=false;
    right=true;
    bob.goTo("runRight");
  }
  if(key==' '&&bob.jumpReady==true) {
    bob.jump = true;
  }
}

void keyReleased() {
  if (keyCode==LEFT&&left) {
    left=false;
        bob.goTo("stop");
  } 
  else if(keyCode==RIGHT&&right) {
    right=false;
          bob.goTo("stop");
        }
          if(key==' ') {
            bob.jumpReady = true;
    bob.jump = false;
  }
}


