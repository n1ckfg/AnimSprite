class Human extends Sprite {
  float speed = 10;
  float jumpHeight = 80;
  float jumpSpeed = 20;
  boolean jump = false;
  boolean jumpReady = true;
  
  Human(float pX, float pY) {
    super("data/walksequence.png",150,185, pX, pY); // filename, tilewidth, tileheight, x pos, y pos
      internalFps = 24;
      goTo("stop");
  }

  void goTo(String c) {
    command = c;
    if(command=="runLeft"){
    setTiles(0,0,5,4);
    flipX = true;
    }
    if(command=="runRight"){
    setTiles(0,0,5,4);
    flipX = false;
    }
    if(command=="stop"){
    setTiles(0,0,0,0);
      }
  }

  void behaviors() {
    if(command=="runLeft") {
      x -= speed;      
    }

    if(command=="runRight"){
    x += speed;
  }
    
    if(command=="stop") {
    }
    
    if(jump){
      jumpReady=false;
      if(y>floorNum-jumpHeight){
      y-=jumpSpeed;
      }
      if(y<=floorNum-jumpHeight){
      jump=false;
      }
    } else {
      if(y<floorNum-jumpHeight){
      jumpReady = true;
      }
    }
    
    x = boundary(x,0,width);
    y = boundary(y,0,height);
  }

  void update() {
    frameTileMotor(frameRate/internalFps);
    behaviors();
    display("NORMAL");
  }
}

