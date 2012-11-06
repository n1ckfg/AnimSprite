int sW = 640;
int sH = 480;
Sprite anim;

void setup(){
  size(sW,sH,P3D);
  //anim = new Sprite("runner",3,false,0,0,0,0);
  //anim = new Sprite("walksequence",3,true,150,185,6,5);
  anim = new Sprite("bacterium",3,true,50,50,10,10);
  }
  
void draw() {
  background(0);
  if(mousePressed){
    anim.p.x = mouseX;
    anim.p.y = mouseY;
  }
  anim.run();
}

void keyPressed(){
anim.loopIn = 10;
anim.loopOut = 12;
}
