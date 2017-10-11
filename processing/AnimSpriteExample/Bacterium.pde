class Bacterium extends AnimSprite{
 
 Bacterium(){
   super("bacterium",12,50,50,10,10);
   init();
 }

 Bacterium(PImage[] _name){
   super(_name,12);
   init();
 }
 
 void init(){
   super.init();
   p = new PVector(sW/2,sH/2,0);
 }
 
 void update(){
   if(mousePressed){
     p = tween3D(p, new PVector(mouseX,mouseY,0), new PVector(random(10,100),random(10,100),10));
     t = new PVector(random(sW),random(sH),random(sD)-(sD/2));
   }else{
     p = tween3D(p, t, new PVector(random(10,100),random(10,100),10));
   }
   if(hitDetect(p.x,p.y,s.x,s.x,t.x,t.y,s.x,s.y)){
       t = new PVector(random(sW),random(sH),random(sD)-(sD/2));
     }

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
