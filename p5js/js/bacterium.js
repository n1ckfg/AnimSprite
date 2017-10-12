"use strict";

class Bacterium extends AnimSprite {

    constructor(_name, _fps, _tdx, _tdy, _etx, _ety) {
        super(_name, _fps, _tdx, _tdy, _etx, _ety);
        this.shakeMin = 2;
        this.shake = this.shakeMin;
        this.shakeMax = 60;
        this.ease = 200;    
        this.behavior = "stop";
        this.gotoFrame(this.behavior);
        this.p = createVector(width/2,height/2);
        this.gravity = 0.25;
        this.floor = floorNum + 80;
    }

    gotoFrame(_c) {
        this.behavior = _c;
        if (this.behavior == "play") {
            this.loopIn = 10;
            this.loopOut = 99;
        }
        if (this.behavior == "stop") {
            this.loopIn = 0;
            this.loopOut = 10;
        }
    }

    behaviors() {
        if (this.behavior == "play") {
            if (this.shake < this.shakeMax) {
                this.shake++;
            }
            this.t = createVector(mouseX,mouseY);
            this.tween();
        }

        if (this.behavior == "stop") {
            this.shake = this.shakeMin;
        }

        this.shaker();
        this.falling();
        this.bounds();
    }

    run() {
        this.behaviors();
        this.update();
        this.draw();
    }

}
