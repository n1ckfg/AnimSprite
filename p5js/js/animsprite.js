// I. making a new sprite from a spritesheet
function AnimSprite(_name, _fps, _tdx, _tdy, _etx, _ety) { // _name is single PImage
  this.spriteName = "sprite";
  this.spriteTag = "tag";
  this.framesArray = []; // PImage array
  this.loopIn = 0;
  this.currentFrame = parseFloat(this.loopIn);
  this.loopOut = 1; // this.framesArray.length; 
  this.fps = _fps;
  this.rate = 0.2; // 12/60
  this.playing = true;
  this.playOnce = false;
  this.debug = false;

  this.mouseable = true;
  this.hovered = false;
  this.clicked = false;

  //position, rotation, scale, target
  this.r = 0;
  this.p = createVector(0, 0);
  this.s = createVector(0, 0);
  this.t = createVector(0, 0);
  this.w = 10;
  this.h = 10;
  this.ease = 100;
  this.shake = 5;
  this.hitSpread = 5;

  this.loadSpriteSheet(_name, _tdx,_tdy,_etx,_ety);
  this.init(_tdx, _tdy);

  this.gravity = 1.0;
  this.floor = 400;

  console.log(this.spriteName + " :: " + 
              "frames: " + this.framesArray.length +
              "  loop in: " + this.loopIn +
              "  loop out: " + this.loopOut + 
              "  fps: " + this.fps);
}

//~~~~~~~~~~~~~~~~~~~~~~
AnimSprite.prototype.init = function(_tdx, _tdy) {
  this.p = createVector(0, 0);
  this.r = 0;
  this.s = createVector(1, 1);
  this.t = createVector(0, 0);
  
  this.w = _tdx;//this.framesArray[0].width;
  this.h = _tdy;//this.framesArray[0].height;  
};

AnimSprite.prototype.loadSpriteSheet = function(_name, _tdx, _tdy, _etx, _ety){
  try {
    //loads a spritesheet from a single image
    var tileX = 1;
    var tileY = 1;
    var tileDimX = _tdx;
    var tileDimY = _tdy;
    var endTileX = _etx;
    var endTileY = _ety;

    for (var i = 0; i < _etx*_ety; i++) {
      if (tileX + tileDimX <= (endTileX * tileDimX)) {
        tileX += tileDimX;
      } else if (tileY + tileDimY <= (endTileY * tileDimY)) {
        tileY += tileDimY;
        tileX = 1;
      } else {
        tileX = 1;
        tileY = 1; 
      }
      //println("Loading frame" + (h+1) + " from " + _name);
      this.framesArray.push(_name.get(tileX, tileY, tileDimX, tileDimY));
    }
    this.loopOut = this.framesArray.length;

  }catch(e) { 
    console.log("Image loading failed.");
  }
};

//~~~~~~~~~~~~~~~~~~~~~~

AnimSprite.prototype.setRate = function() {
  this.rate = this.fps/frameRate();
};

AnimSprite.prototype.update = function() {
  if (this.mouseable){
    this.checkHover();
    this.checkClick();  
  }

  this.setRate();
  if(this.playing){
    this.currentFrame += this.rate;
    if (this.currentFrame >= this.loopOut) {
      if(this.playOnce){
        this.playing=false;
      }else{
        this.currentFrame = this.loopIn;
      }
    }
  }
};

AnimSprite.prototype.draw = function() {
  push();
  //translate, rotate, scale
  translate(this.p.x, this.p.y);
  rotate(radians(this.r));
  scale(this.s.x, this.s.y);

  //draw
  imageMode(CENTER);
  image(this.framesArray[parseInt(this.currentFrame)], 0, 0);
  pop();
};

AnimSprite.prototype.run = function() {
  this.update();
  this.draw();
};

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//basic behaviors

AnimSprite.prototype.checkHover = function() {
  this.hovered = this.hitDetect(mouseX,mouseY);
};

AnimSprite.prototype.checkClick = function() {
  if (this.hovered) this.clicked = mouseIsPressed;
};

//Tween movement.  start, end, ease (more = slower).
AnimSprite.prototype.tween = function(_e) { //float
  var _ease;
  if (!_e) {
    _ease = this.ease;
  } else {
    _ease = _e;
  }
  this.p.x += (this.t.x-this.p.x)/_ease;
  this.p.y += (this.t.y-this.p.y)/_ease;
};

AnimSprite.prototype.shaker = function(_s) {
  var _shake;
  if (!_s) {
    _shake = this.shake;
  } else {
    _shake = _s;
  }  
  this.p.x += random(_shake) - random(_shake);
  this.p.y += random(_shake) - random(_shake);
};

AnimSprite.prototype.bounds = function() {
  if (this.p.x < 0) {
    this.p.x = 0;
  } else if (this.p.x > width) {
    this.p.x = width;
  }
  if (this.p.y < 0) {
    this.p.y = 0;
  } else if (this.p.y > height) {
    this.p.y = height;
  }
};

AnimSprite.prototype.falling = function(_g) {  //y pos, floor num, gravity num
  var gravity;
  if (!_g) {
    _gravity = this.gravity;
  } else {
    _gravity = _g;
  }

  if (this.p.y < this.floor) {
    this.p.y += _gravity;
  } else if (this.p.y >= this.floor) {
    this.p.y = this.floor;
  }
};

//2D Hit Detect.  Assumes center.  x,y,w,h of object 1, x,y,w,h, of object 2.
AnimSprite.prototype.hitDetect = function(_x, _y) {
  var x1 = this.p.x;
  var y1 = this.p.y;
  var w1 = this.w/2;
  var h1 = this.h/2;
  var x2;
  if (!_x) {
    x2 = this.t.x;
  } else {
    x2 = _x;
  }  
  var y2;
  if (!_y) {
    y2 = this.t.y;
  } else {
    y2 = _y;
  } 
  var w2 = this.hitSpread/2;
  var h2 = this.hitSpread/2; 
  if (x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
    return true;
  } else {
    return false;
  }
};

