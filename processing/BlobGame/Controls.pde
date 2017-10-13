void keyPressed(){
  if(key=='m'||key=='M') kinectMode = !kinectMode;
  
  if(key=='d'||key=='D') debug = !debug;
 
  if(key=='l'||key=='L') useLogMap = !useLogMap;

  if(key=='h'||key=='H') switchHeavenHell();

  if(key=='k'||key=='K') kidMode = !kidMode;
}

void console(){
 //debug text
 if(debug){
     fill(255);
     String sayText = "(D)EBUG MODE   |   ";
     text(sayText,width/2,fontSize*2);
     if(hellMode){
       sayText += "(H)ell"; 
     }else{
       sayText += "(H)eaven"; 
     }
     sayText += "   |   (M)ouse override: " + setOnOff(!kinectMode) + "   |   (L)og scale: " + setOnOff(useLogMap) + "   |   (K)id mode: " + setOnOff(kidMode);
     text(sayText,width/2,fontSize*2);
     sayText = "raw: " + rounder(blob.x,2) + " " + rounder(blob.y,2) + " " + rounder(blob.z,2) + "   scaled: " + rounder(blobScaled.x,2) + " " + rounder(blobScaled.y,2) + " " + rounder(blobScaled.z,2);
     sayText += "   kinect control: " + kinectMode;
     sayText += "   controlling player: " + trackingPlayer;
     text(sayText,width/2,fontSize*4);
     sayText = "demon: " + demon.p; 
     sayText += "   rock1: " + rock1.p; 
     sayText += "   rock2: " + rock2.p; 
     sayText += "   rock3: " + rock3.p;      
     text(sayText,width/2,fontSize*6);
  }
}
