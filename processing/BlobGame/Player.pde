class Player extends AnimSprite {

  float ease = 4;
  boolean dead = true;
  boolean marshes = false;
  
Player(String _name, int _fps){
   super(_name, _fps);
   init(); 
 }

Player(String _name, int _fps, int _tdx, int _tdy, int _etx, int _ety){
   super(_name, _fps, _tdx, _tdy, _etx, _ety);
   init(); 
 }
 
 Player(PImage[] _name, int _fps){
   super(_name, _fps);
   init();
 }
 
 void update(){
   super.update();
   if(trackingPlayer){
     //follow the Kinect blob
     if(marshes){
       p.x = tween(p.x,blobScaled.x,5 * ease);
       p.y = tween(p.y,blobScaled.y,5 * ease);
     }else{
       p.x = tween(p.x,blobScaled.x,ease);
       p.y = tween(p.y,blobScaled.y,ease);       
     }
   }else{
     //go back to the start zone
     p.x = tween(p.x,zone[0].p.x,ease);
     p.y = tween(p.y,zone[0].p.y,ease);
   }
   if(blobScaled.x > 2 * width || blobScaled.x < -2 * width || blobScaled.y > 2 * height || blobScaled.y < -2 * height) dead = true;
   p.x = boundary(p.x,0,float(width));
   p.y = boundary(p.y,0,float(height));
 }
 
 void draw(){
   super.draw();
 }
 
 void run(){
   update();
   draw();
 }

}
