class Demon extends Enemy {

  Demon(String _name, int _fps){
   super(_name, _fps);
   init(); 
 }

  Demon(String _name, int _fps, int _tdx, int _tdy, int _etx, int _ety){
   super(_name, _fps, _tdx, _tdy, _etx, _ety);
   init(); 
 }
 
  Demon(PImage[] _name, int _fps){
   super(_name, _fps);
   init();
 }

  void init(){
    ease = 50;
    attack = false;
    home = new PVector(-1 * (w/2),height/2);
    vOrig = new PVector(8, 10);
    v = vOrig;
    aOrig = new PVector(0.1,1);
    a = aOrig;
    //--
    super.init();
  }

  void update(){
    super.update();
       if(attack && p.x < width+50){
     p.x += v.x;
     v.x += a.x;
     p.y += v.y * sin(p.x); //-1 * makes it head up
   }else{
     reset();
   }
  }
  
  void draw(){
    super.draw();
  }
  
  void run(){
    update();
    draw();
  }
 
}
