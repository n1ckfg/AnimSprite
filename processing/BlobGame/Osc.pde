//based on oscP5parsing by andreas schlegel

import oscP5.*;
import netP5.*;
import toxi.math.*;

String ipNumber = "127.0.0.1";
int receivePort = 7300;
int sendPort = 7200;
OscP5 oscP5;
NetAddress myRemoteLocation;
//---

String[] oscNames = { "/kinect/blobs" };

boolean useLogMap = false;
ScaleMap linearMap;
ScaleMap logMap;

// 1.
void oscSetup() {
  oscP5 = new OscP5(this, receivePort);  // start osc
  myRemoteLocation = new NetAddress(ipNumber, sendPort);
}

// 2. This is for receiving messages; it happens automatically--no need to put in the draw loop
void oscEvent(OscMessage theOscMessage) {
  if(kinectMode){
    for(int i=0;i<oscNames.length;i++){
    if(theOscMessage.checkAddrPattern(oscNames[i])) {
      if(theOscMessage.checkTypetag("ifffff")) {  // types are i = int, f = float, s = String, ifs = all
        if(theOscMessage.get(0).intValue()==1){  // commands are intValue, floatValue, stringValue
          //3 = x, 4 = y, 5 = z
            blob.x = theOscMessage.get(5).floatValue();
            blob.y = theOscMessage.get(4).floatValue();
            blob.z = 0;
            //blob.z = theOscMessage.get(3).floatValue();
            //println(blob);
        }
        //--
        if(theOscMessage.get(0).intValue()==2){  // 2nd player
          //3 = x, 4 = y, 5 = z
            blob2.x = theOscMessage.get(5).floatValue();
            blob2.y = theOscMessage.get(4).floatValue();
            blob2.z = 0;
            //blob.z = theOscMessage.get(3).floatValue();
            //println(blob2);
          }      
        }  
      }
    }
  }
}

// 3.
void oscUse(){
  try{
    if(kinectMode){
      //scaling and offsets
      blobScaledLast = blobScaled;
      blobScaled = scaleBlobs(blob);
      blobScaledDiff.x = abs(blobScaled.x - blobScaledLast.x);
      blobScaledDiff.y = abs(blobScaled.y - blobScaledLast.y);
      blobScaledDiff.z = abs(blobScaled.z - blobScaledLast.z);
      blob2Scaled = scaleBlobs(blob2);
    }else{
      blobScaled = blob; //don't scale when in mouse mode--it's already OK.
      blob2Scaled = blob2;
    }
  }catch(Exception e){ }
}

PVector scaleBlobs(PVector p1){
  PVector p2 = new PVector(0,0,0);
  if(useLogMap){
    //logMap=new ScaleMap(log(expectedMinValue),log(expectedMaxValue),0,width);
    //float x1=(float)logMap.getMappedValueFor(log(i));
    logMap=new ScaleMap(log(realXmax),log(realXmin),width,0);
    p2.x = (float)logMap.getMappedValueFor(log(blob.x));
  }else{
    //linearMap=new ScaleMap(expectedMinValue,expectedMaxValue,0,width);
    //float x1=(float)linearMap.getMappedValueFor(i);
    p2.x = map(p1.x, realXmax, realXmin, width, 0) - map(p1.x, realXmax, realXmin, 300, -100);
  }
  if(kidMode){
    p2.y = map(p1.y, realYmin, realYmax, height/2, 0) + 100; //offset for the player
  }else{
    p2.y = map(p1.y, realYmin, realYmax, height/2, 0) + 300; //offset for the player
  }
  return p2;
}

// 4.
void oscSend(){
  OscMessage myMessage;
  try{
    if(kinectMode){
      myMessage = new OscMessage("/example");
      myMessage.add(blobScaled.x);
      myMessage.add(blobScaled.y);
      myMessage.add(blobScaled.z);
      oscP5.send(myMessage, myRemoteLocation);
    }
  }catch(Exception e){ }
}







