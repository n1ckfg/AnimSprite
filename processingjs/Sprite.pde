class Sprite {
  String command;
  float internalFps;
  
  PImage fromImg, toImg;
  int tileX, tileY, tileWidth, tileHeight;
  int startTileX, startTileY, endTileX, endTileY;
  float x, y;
  int frameCounter = 0;
  
  boolean flipX = false;
  boolean flipY = false;

String[] blendModes = {"BLEND", "ADD", "SUBTRACT", "LIGHTEST", "DARKEST", "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN", "OVERLAY", "HARD_LIGHT", "SOFT_LIGHT", "DODGE", "BURN"};
int[] blendModeCodes = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192};

  Sprite(String fN, int tW, int tH, float pX, float pY) {
    fromImg = loadImage(fN);
    tileWidth = tW;
    tileHeight = tH;
    x = pX;
    y = pY;
  }

  void frameTileMotor(float a) {
    frameCounter++;
    if(frameCounter>=a) {
      frameCounter=0;
      if(tileX + tileWidth<=(endTileX*tileWidth)) {
        tileX += tileWidth;
      } 
      else if(tileY + tileHeight<=(endTileY*tileHeight)) {
        tileY += tileHeight;
        tileX = 0;
      } 
      else {
        tileX = startTileX*tileWidth;
        tileY = startTileY*tileHeight;
      }
    }
    toImg = fromImg.get(tileX,tileY,tileWidth,tileHeight);
  }

  void display(String b) { 
    pushMatrix();
    if(b=="NORMAL") {
     translate(x,y);
        
    if(flipX&&!flipY) {   
      scale(-1.0,1.0);
    } 
    else if (!flipX&&flipY) {
      scale(1.0,-1.0);
    } 
    else if (flipX&&flipY) {
      scale(-1.0,-1.0);
    }
    imageMode(CENTER);
    image(toImg,0,0);
    } else {
      
      PGraphics blendImg = createGraphics(toImg.width,toImg.height, P2D);
      blendImg.beginDraw();
    
    if(flipX&&!flipY) {   
            blendImg.translate(toImg.width,0);
            blendImg.scale(-1.0,1.0);
    } 
    else if (!flipX&&flipY) {
            blendImg.translate(0,toImg.height);
            blendImg.scale(1.0,-1.0);
    } 
    else if (flipX&&flipY) {
                  blendImg.translate(toImg.width,toImg.height);
                  blendImg.scale(-1.0,-1.0);
    }

      blendImg.image(toImg, 0, 0);
      blendImg.endDraw();
    for(int i=0;i<blendModes.length;i++){
    if(b==blendModes[i]){
          blend(blendImg,0,0,tileWidth,tileHeight,int(x)-(tileWidth/2),int(y)-(tileHeight/2),tileWidth,tileHeight,blendModeCodes[i]);
    }
    }
    }
    popMatrix();
  }

void setTiles(int sX, int sY, int eX, int eY) {
  startTileX = sX;
  startTileY = sY;
  endTileX = eX;
  endTileY = eY;
  tileX = startTileX*tileWidth;
  tileY = startTileY*tileHeight;
}

//-----------
boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  w1 /= 2;
  h1 /= 2;
  w2 /= 2;
  h2 /= 2; 
  if(x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
    return true;
  } 
  else {
    return false;
  }
}
//-------------

float tween(float v1, float v2, float e) {
  v1 += (v2-v1)/e;
  return v1;
}

float shake(float v1, float s) {
  v1 += random(s) - random(s);
  return v1;
}

float boundary(float v1, float vMin, float vMax) {
  if(v1<vMin) {
    v1 = vMin;
  } 
  else if(v1>vMax) {
    v1=vMax;
  } 
  return v1;
}


float gravity(float v1, float v2, float v3){ //y pos, floor num, gravity num
if(v1<v2){
v1 += v3;
}
if(v1>v2){
v1 = v2;
}
return v1;
}

}
