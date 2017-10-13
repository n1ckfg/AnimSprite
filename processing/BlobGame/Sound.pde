import ddf.minim.*;

Minim minim;
String soundPath = "sounds";

//SOUNDS~~~~~~~~~~~~~~~~~
//foreground sounds
AudioPlayer fgDying, reachedHeaven, dragon, angel, returnToHell, introHeaven, introHell, helper;
AudioPlayer fallingStars1, fallingStars2, fallingStars3;
AudioPlayer flamingSkulls1, flamingSkulls2, flamingSkulls3;

//background sounds
AudioPlayer bgHell, bgHeaven;

//~~~~~~~~~~~~~~~~~~~~~~~

void soundSetup(){
  minim = new Minim(this);
  //foreground
  fgDying = minim.loadFile("sounds/splat.wav");
  reachedHeaven = minim.loadFile("sounds/reached heaven.wav");
  introHeaven = minim.loadFile("sounds/welcome to heaven.wav");
  returnToHell = minim.loadFile("sounds/return to hell.wav");
  introHell = minim.loadFile("sounds/hell intro.wav");
  helper = minim.loadFile("sounds/helper.wav");
  dragon = minim.loadFile("sounds/dragon.wav");
  fallingStars1 = minim.loadFile("sounds/falling stars.wav");
  fallingStars2 = minim.loadFile("sounds/falling stars.wav");
  fallingStars3 = minim.loadFile("sounds/falling stars.wav");
  flamingSkulls1 = minim.loadFile("sounds/flaming skull.wav");
  flamingSkulls2 = minim.loadFile("sounds/flaming skull.wav");
  flamingSkulls3 = minim.loadFile("sounds/flaming skull.wav");
  angel = minim.loadFile("sounds/flying angel.wav");
  //background
  bgHell = minim.loadFile("sounds/hell-loop.wav");
  bgHeaven = minim.loadFile("sounds/heaven loop.wav");
}

void soundStop(){
  try{
     minim.stop();
    //--
    //foreground
    closeSound(fgDying);
    closeSound(dragon);
    closeSound(fallingStars1);
    closeSound(fallingStars2);
    closeSound(fallingStars3);
    closeSound(flamingSkulls1);
    closeSound(flamingSkulls2);
    closeSound(flamingSkulls3);
    closeSound(angel);
    closeSound(reachedHeaven);
    closeSound(returnToHell);
    closeSound(introHell);
    closeSound(introHeaven);
    closeSound(helper);
    //background
    closeSound(bgHell);
    closeSound(bgHeaven);
    //--
  }catch(Exception e){ }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void stopSound(AudioSnippet _a){
  _a.pause();
}

void stopSound(AudioPlayer _a){
  _a.pause();
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void playSound(AudioSnippet _a){
  _a.rewind();
  _a.play();
}

void playSound(AudioPlayer _a){
  _a.play(0);
}

void playSound(AudioPlayer _a, boolean _l){
  if(_l){
    _a.loop();
  }else{
    _a.play(0);
  }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void closeSound(AudioSnippet _a){
  try{
    _a.close();
  }catch(Exception e){ }
}

void closeSound(AudioPlayer _a){
  try{
    _a.close();
  }catch(Exception e){ }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



