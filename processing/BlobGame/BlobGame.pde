//CoLab 2013 Blob Tracking Game

//KVL Tracker settings
//first try: min distance: 0.45   max distance: 13.0   BG Subtract: on   Tracking: off   min blob size: 297   distance threshold: 0.2   frame buffer: 5
//second try: min distance: 0.45   max distance: 13.0   BG Subtract: on   Tracking: off   min blob size: 297   distance threshold: 0.2   frame buffer: 5

boolean debug = false;

//~~~~  real-world calibration  ~~~
//first try 0.45,  5.8, -0.53, 0.2;
float realXmin = 0.45;
float realXmax = 6.80;
float realYmin = -0.53;
float realYmax = 0.2;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int numzones = 9;
Zone[] zone = new Zone[numzones];
int numReferences = 10;
AnimSprite[] reference = new AnimSprite[numReferences];
Player player;
Demon demon;
AnimSprite backgroundHeaven, backgroundHell;
Rock rock1, rock2, rock3;
PVector blob = new PVector(0,0);
PVector blob2 = new PVector(0,0);
PVector blobScaled = new PVector(0,0);
PVector blobScaledLast = new PVector(0,0);
PVector blobScaledDiff = new PVector(0,0);
PVector blob2Scaled = new PVector(0,0);
boolean kinectMode = true;
color bgColorHell = color(90,0,0);
color bgColorHeaven = color(0,127,187);
color bgColorDebug = color(0,0,255);
int fontSize = 14;
PFont font;
int pulsebgTarget = int(random(127));
int pulsebgCurrent = pulsebgTarget;
boolean kidMode = false;

//--
boolean hellMode = true;
boolean trackingPlayer = false;

void setup(){
  size(1600,600,P2D);
  font = createFont("Arial",fontSize);
  textFont(font, fontSize);
  soundSetup();
  noCursor();

  //~~~~~~~~~~~~~~~~~~~~
  //load references into memory so you can make copies later
  reference[0] = new AnimSprite("demon-heaven",6);
  reference[1] = new AnimSprite("demon-hell",6);
  //--
  reference[2] = new AnimSprite("rock-heaven",1);
  reference[3] = new AnimSprite("rock-hell",1); 
  //--
  reference[4] = new AnimSprite("marshZone-heaven",1);
  reference[5] = new AnimSprite("marshZone-hell",1); 
  //--
  reference[6] = new AnimSprite("crackZone1-heaven",1);
  reference[7] = new AnimSprite("crackZone1-hell",1); 
  //--
  reference[8] = new AnimSprite("crackZone2-heaven",1);
  reference[9] = new AnimSprite("crackZone2-hell",1); 

  //~~~~~~~~~~~~~~~~~~~~
  //zones
  zone[0] = new Zone("startZone",1);
  zone[0].p = new PVector(width-50, height/2);
  zone[0].showInGame = false;

  zone[1] = new Zone("demonZone",1);
  zone[1].p = new PVector(width-400, 400);
  zone[1].showInGame = false;
  //--
  //marsh
  zone[2] = new Zone(reference[5].frames,1);
  zone[2].p = new PVector(width-600, height/2);
  //--
  zone[3] = new Zone("rockZone1",1);
  zone[3].p = new PVector(400, 500);
  zone[3].showInGame = false;
  //--
  zone[4] = new Zone("rockZone2",1);
  zone[4].p = new PVector(300, 300);
  zone[4].showInGame = false;
  //--
  zone[5] = new Zone("rockZone3",1);
  zone[5].p = new PVector(200, 400);
  zone[5].showInGame = false;
  //--
  //crack1
  zone[6] = new Zone(reference[7].frames,1);
  zone[6].p = new PVector(600, 520);
  //--
  //crack2
  zone[7] = new Zone(reference[9].frames,1);
  zone[7].p = new PVector(500, 100);
  //--
  zone[8] = new Zone("endZone",1);
  zone[8].p = new PVector(50, height/2);
  zone[8].showInGame = false;

  //sprites
  player = new Player("player",6);
  player.p = new PVector(width-50,height/2);
  
  demon = new Demon(reference[1].frames,6);
  demon.p = demon.home;

  backgroundHeaven = new AnimSprite("backgroundHeaven",1);
  backgroundHeaven.p = new PVector(width/2,height/2);
  backgroundHell = new AnimSprite("backgroundHell",1);
  backgroundHell.p = new PVector(width/2,height/2);

  rock1 = new Rock(reference[3].frames,1);
  rock1.home = new PVector(zone[3].p.x,-(rock1.h/2));
  rock1.p = rock1.home;

  rock2 = new Rock(reference[3].frames,1);
  rock2.home =  new PVector(zone[4].p.x,-(rock2.h/2));
  rock2.p = rock2.home;

  rock3 = new Rock(reference[3].frames,1);
  rock3.home = new PVector(zone[5].p.x,-(rock3.h/2));
  rock3.p = rock3.home;  

  oscSetup();
  playSound(bgHell,true);
  playSound(helper);
}

void draw(){
  if(debug){
    background(bgColorDebug);
  }else{
    /*
    if(hellMode){
      background(bgColorHell);
    }else{
      background(bgColorHeaven);
    }
    */
  if(!hellMode){
    backgroundHeaven.run();
    pulsebg(bgColorHeaven);
  }else{
    backgroundHell.run();
    pulsebg(bgColorHell);
  }    
  }  
  oscUse();
  //--
  if(!kinectMode){
    blob.x = mouseX;
    blob.y = mouseY;
  }

  //ZONE RULES ~~~~~~~~~~~
  //RULE 0. flashes the screen red if the player passes through a zone.
  for(int i=0;i<zone.length;i++){
    zone[i].run();
    if(zone[i].playerHit){
      if(debug || zone[i].showInGame){
        flashScreen();
      }
    }else{
      //
    }
  }
    
  //RULE 1. checks if real person is in start zone
  if(player.dead){
    if(zone[0].trackerHit){
      player.dead = false;
      trackingPlayer = true;
    }else{
      trackingPlayer = false;
    }
  }
  
  //RULE 2. the Cracks kill you
  if(zone[6].playerHit || zone[7].playerHit){
    if(!player.dead && !zone[0].playerHit) playSound(fgDying);
    player.dead = true;
  }
  
  //RULE 3. entering the demon zone generates demons
  if(zone[1].playerHit && !demon.attack && !player.dead){
    if(hellMode){
      playSound(dragon);
    }else{
      playSound(angel);
    }
    demon.reset();
    demon.attack = true;
  }

  //RULE 4. entering the rock zones generates rocks
  if(zone[3].playerHit && !rock1.attack && !player.dead){
    rock1.reset();
    rock1.attack = true;
    if(!hellMode){
      playSound(fallingStars1);
    }else{
      playSound(flamingSkulls1);
    }
  }
  if(zone[4].playerHit && !rock2.attack && !player.dead){
    rock2.reset();
    rock2.attack = true;
    if(!hellMode){
      playSound(fallingStars2);
    }else{
      playSound(flamingSkulls2);
    }
  }
  if(zone[5].playerHit && !rock3.attack && !player.dead){
    rock3.reset();
    rock3.attack = true;
    if(!hellMode){
      playSound(fallingStars3);
    }else{
      playSound(flamingSkulls3);
    }
  }  

  //RULE 5. entering the end zone switches heaven/hell.
  if(zone[8].playerHit && !player.dead){
    player.dead=true;
    if(hellMode){
      float r = random(1);
      if(r < 0.5){
        playSound(reachedHeaven);
      }else{
        playSound(introHeaven);
      }
    }else{
      float r = random(1);
      if(r < 0.33){
        playSound(returnToHell);
      }else if(r >= 0.33 && r < 0.66){
        playSound(introHell);
      }else{
        playSound(helper);
      }
    }
    switchHeavenHell();
  }
  
  //RULE 6. entering the marshes slows you down.
  if(zone[2].playerHit && !player.dead){
    player.marshes = true;
  }else{
    player.marshes = false;
  }
  
  //~~~~~~~~~~~~~~~~~~~~~~
  
  //tracker location
  if(debug){
    strokeWeight(1);
    stroke(255,0,0);
    line(player.p.x,player.p.y,blobScaled.x,blobScaled.y);
    strokeWeight(5);
    stroke(255,150);
    if(kinectMode){
      line(blobScaled.x,blobScaled.y,blobScaledLast.x,blobScaledLast.y);
    }else{
      line(mouseX,mouseY,pmouseX,pmouseY);
    }
    //line(blob2Scaled.x,blob2Scaled.y,blobScaled.x,blobScaled.y);
    strokeWeight(20);
    //player1
    stroke(255,255,100);
    point(blobScaled.x,blobScaled.y);
    //player2
    //stroke(255,0,100);
    //point(blob2Scaled.x,blob2Scaled.y);    
  }

//~~~~~~~~~~~~~~~~~~~~~~

  player.run();
  demon.run();
  rock1.run();
  rock2.run();
  rock3.run();
 
  console();
 }
 
 void stop(){
   soundStop();
 }

//**********************************
//**********************************
//**********************************
void switchHeavenHell(){
  hellMode = !hellMode;
  if(hellMode){
    //Hell sounds
    stopSound(bgHeaven);
    playSound(bgHell,true);
    //Hell sprites
    demon.frames = reference[1].frames;
    //demon.aOrig.x = 1;
    rock1.frames = reference[3].frames;
    rock2.frames = reference[3].frames;
    rock3.frames = reference[3].frames;
    rock1.home = new PVector(zone[3].p.x,-(rock1.h/2));
    rock1.aOrig.y = 0.2;
    rock2.home = new PVector(zone[4].p.x,-(rock2.h/2));
    rock2.aOrig.y = 0.3;
    rock3.home = new PVector(zone[5].p.x,-(rock3.h/2));
    rock3.aOrig.y = 0.4;
    //marsh
    zone[2].frames = reference[5].frames;
    //crack1
    zone[6].frames = reference[7].frames;
    zone[6].w = reference[7].frames[0].width;
    zone[6].h = reference[7].frames[0].height;
    //crack2
    zone[7].frames = reference[9].frames;
  }else{
    //Heaven sounds
    stopSound(bgHell);
    playSound(bgHeaven,true);
    //Heaven sprites
    demon.frames = reference[0].frames;
    //demon.aOrig.x = 1.1;
    rock1.frames = reference[2].frames;
    rock2.frames = reference[2].frames;
    rock3.frames = reference[2].frames;
    rock1.home = new PVector(zone[3].p.x,-(rock1.h));
    rock1.aOrig.y = 0.5;
    rock2.home = new PVector(zone[4].p.x,-(rock2.h));
    rock2.aOrig.y = 0.6;
    rock3.home = new PVector(zone[5].p.x,-(rock3.h));
    rock3.aOrig.y = 0.7;
    //marsh
    zone[2].frames = reference[4].frames;
    //crack1
    zone[6].frames = reference[6].frames;
    zone[6].w = reference[6].frames[0].width;
    zone[6].h = reference[6].frames[0].height;
    //crack2
    zone[7].frames = reference[8].frames;
  }
} 
//**********************************
//**********************************
//**********************************
 
float rounder(float _val, float _places){
  _val *= pow(10,_places);
  _val = round(_val);
  _val /= pow(10,_places);
  return _val;
}

void flashScreen(){
  if(debug){
    noStroke();
    fill(255,0,0,100);
    rectMode(CORNER);
    rect(0,0,width,height);
  }
}

String setOnOff(boolean _b){
  String s;
  if(_b){
    s = "ON";
  }else{
    s = "OFF";
  }
  return s;
}

void pulsebg(color _c){
    rectMode(CORNER);
    noStroke();
    fill(_c,pulsebgCurrent);
    if(pulsebgCurrent>pulsebgTarget){
      pulsebgCurrent--;
    }else if(pulsebgCurrent<pulsebgTarget){
      pulsebgCurrent++;
    }else if(pulsebgCurrent==pulsebgTarget){
      pulsebgTarget=int(random(127));
    }
    rect(0,0,width,height);
}