class Bacterium extends AnimSprite{
 
 Bacterium(){
   super("bacterium",12,50,50,10,10);
 }

 Bacterium(PImage[] _name){
   super(_name,12);
 }
 
 void init(){
   p = new PVector(width/2,height/2,0);
 }
 
 void update(){
   if(mousePressed) p = tween3D(p, new PVector(mouseX,mouseY,0), new PVector(10,10,10));
   super.update();
 }
 
 void draw(){
   super.draw();
 }
 
 void run(){
   update();
   draw();
 }
  
}
