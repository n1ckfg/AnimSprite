class Rock extends Enemy {

  Rock(String _name, int _fps){
   super(_name, _fps);
   init(); 
 }

  Rock(String _name, int _fps, int _tdx, int _tdy, int _etx, int _ety){
   super(_name, _fps, _tdx, _tdy, _etx, _ety);
   init(); 
 }
 
  Rock(PImage[] _name, int _fps){
   super(_name, _fps);
   init();
 }

  void init(){
    ease = 50;
    attack = false;
    home = new PVector(width/2,height/2);
    vOrig = new PVector(0, 0.5);
    v = vOrig;
    aOrig = new PVector(0,0.5); //orig 0.2
    a = aOrig;
    //--
    super.init();
  }

  void update(){
    super.update();
    if(attack && p.y<height){
      p.add(v);
      v.add(a);
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
