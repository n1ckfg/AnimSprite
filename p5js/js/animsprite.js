"use strict";

class AnimSprite { // _name is single PImage

    constructor(_name, _fps, _tdx, _tdy, _etx, _ety) {
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
                                "    loop in: " + this.loopIn +
                                "    loop out: " + this.loopOut + 
                                "    fps: " + this.fps);
    }

    //~~~~~~~~~~~~~~~~~~~~~~
    init(_tdx, _tdy) {
        this.p = createVector(0, 0);
        this.r = 0;
        this.s = createVector(1, 1);
        this.t = createVector(0, 0);
        
        this.w = _tdx;//this.framesArray[0].width;
        this.h = _tdy;//this.framesArray[0].height;    
    }

    loadSpriteSheet(_name, _tdx, _tdy, _etx, _ety) {
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

        } catch(e) { 
            console.log("Image loading failed.");
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~

    setRate() {
        this.rate = this.fps/frameRate();
    }

    update() {
        if (this.mouseable) {
            this.checkHover();
            this.checkClick();    
        }

        this.setRate();
        if(this.playing) {
            this.currentFrame += this.rate;
            if (this.currentFrame >= this.loopOut) {
                if(this.playOnce) {
                    this.playing=false;
                } else {
                    this.currentFrame = this.loopIn;
                }
            }
        }
    }

    draw() {
        pg.push();
        //translate, rotate, scale
        pg.translate(this.p.x, this.p.y);
        pg.rotate(radians(this.r));
        pg.scale(this.s.x, this.s.y);

        //draw
        pg.imageMode(CENTER);
        pg.image(this.framesArray[parseInt(this.currentFrame)], 0, 0);
        pg.pop();
    }

    run() {
        this.update();
        this.draw();
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //basic behaviors

    checkHover() {
        this.hovered = this.hitDetect(mouseX,mouseY);
    }

    checkClick() {
        if (this.hovered) this.clicked = mouseIsPressed;
    }

    //Tween movement.    start, end, ease (more = slower).
    tween(_e) { //float
        var _ease;
        if (!_e) {
            _ease = this.ease;
        } else {
            _ease = _e;
        }
        this.p.x += (this.t.x-this.p.x)/_ease;
        this.p.y += (this.t.y-this.p.y)/_ease;
    }

    shaker(_s) {
        var _shake;
        if (!_s) {
            _shake = this.shake;
        } else {
            _shake = _s;
        }    
        this.p.x += random(_shake) - random(_shake);
        this.p.y += random(_shake) - random(_shake);
    }

    bounds() {
        if (this.p.x < 0) {
            this.p.x = 0;
        } else if (this.p.x > pg.width) {
            this.p.x = pg.width;
        }
        if (this.p.y < 0) {
            this.p.y = 0;
        } else if (this.p.y > pg.height) {
            this.p.y = pg.height;
        }
    }

    falling(_g) {    //y pos, floor num, gravity num
        var _gravity;
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
    }

    //2D Hit Detect.    Assumes center.    x,y,w,h of object 1, x,y,w,h, of object 2.
    hitDetect(_x, _y) {
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
    }

}

