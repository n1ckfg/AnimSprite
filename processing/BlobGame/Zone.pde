class Zone extends AnimSprite {

  boolean playerHit = false;
  boolean trackerHit = false;
  String name = "";
  boolean showInGame = true;
  
Zone(String _name, int _fps){
   super(_name, _fps);
   init(); 
 }

Zone(String _name, int _fps, int _tdx, int _tdy, int _etx, int _ety){
   super(_name, _fps, _tdx, _tdy, _etx, _ety);
   init(); 
 }
 
 Zone(PImage[] _name, int _fps){
   super(_name, _fps);
   init();
 }
 
 void update(){
   super.update();
   //this checks if the player--that is, the animated graphic--is hitting a zone
   if(hitDetect(player.p.x,player.p.y,player.w,player.h,p.x,p.y,w,h)){
     playerHit=true; 
     println("Player has hit " + name + "!");
   }else{
     playerHit = false;
   }

   //this checks if the real person is hitting a zone
   if(hitDetect(blobScaled.x,blobScaled.y,10,10,p.x,p.y,w,h)){
     trackerHit=true; 
     //println("Tracker has hit " + name + "!");
   }else{
     trackerHit = false;
   }
   
 }
 
 void draw(){
   super.draw();
 }
 
 void run(){
   update();
   if(showInGame) draw();
 }

}
