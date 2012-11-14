int sW = 640;
int sH = 480;
int fps = 60;
Bacterium bacterium;
Bacterium[] bacteria = new Bacterium[100];

void setup(){
  size(sW,sH,P3D);
  frameRate(fps);
  // You can load your sprite from a folder of images like this:
  //example = new AnimSprite("runner",12);
  // ...or from a spritesheet like this:
  //example = new AnimSprite("walksequence",12,150,185,6,5);
  // ...and here's a subclass with behaviors already included:
  bacterium = new Bacterium();
  for(int i=0;i<bacteria.length;i++){
    bacteria[i] = new Bacterium(bacterium.frames);
    bacteria[i].p = new PVector(random(width),random(height),0);
    bacteria[i].index = random(bacteria[i].frames.length);
    bacteria[i].r = new PVector(0,0,random(100));
  }
  }
  
void draw() {
  background(0);
  for(int i=0;i<bacteria.length;i++){
  bacteria[i].run();
  }
}

void keyPressed(){
  for(int i=0;i<bacteria.length;i++){
    bacteria[i].loopIn = 10;
    bacteria[i].loopOut = 12;
  }
}
