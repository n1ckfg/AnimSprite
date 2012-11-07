class Bacterium extends Sprite{
 
 Bacterium(){
   super("bacterium",3,true,50,50,10,10);
 }
 
 void update(){
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
