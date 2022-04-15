"use strict";

let canvas;

let human_img, bacterium_img, bg_img;
let human, bacterium;
let bacteria = [];
let numBacteria = 20;
let gravityNum = 8;
let floorNum = 350;

let left = false;
let right = false;

function preload() {
    human_img = loadImage("./images/walksequence.png");
    bacterium_img = loadImage("./images/bacterium.png");
    bg_img = loadImage("./images/bg_5.png");
}

function setup() {
    canvas = createCanvas(640, 480);
    canvas.parent("container");
    human = new Human(human_img, 12, 150, 185, 6, 5); // image, fps, tileHeightX, tileHeightY, numTilesX, numTilesY
    human.p = createVector(width/2,floorNum);    

    bacterium = new Bacterium(bacterium_img, 1, 50, 50, 10, 10);

    for (let i=0; i<numBacteria; i++) {
        bacteria.ease = 1000;
        bacteria.push(bacterium);
    }
}

function draw() {
    image(bg_img, 0, 0);

    if (left && !right) {
        human.gotoFrame("runLeft");
    } else if (!left && right) {
        human.gotoFrame("runRight");
    } else if (!left && !right){
        human.gotoFrame("stop");
    }

    human.run();
    for (let i=0; i< bacteria.length; i++) {
        if (mouseIsPressed) {
            bacteria[i].tween;
        }
        bacteria[i].run();
    }
}

function mousePressed() {
    console.log("mouse pressed");
    for (let i=0; i< bacteria.length; i++) {
        bacteria[i].t = createVector(mouseX,mouseY);
        bacteria[i].gotoFrame("play");
    }
}

function mouseReleased() {
    console.log("mouse released");
    for (let i=0; i< bacteria.length; i++) {
        bacteria[i].gotoFrame("stop");
    }
}

function keyPressed() {
    if (keyCode == LEFT_ARROW) {
        left = true;
    }
    if (keyCode == RIGHT_ARROW) {
        right = true;
    }        

    if (key === ' ' && human.jumpReady == true) {
        human.jumpReady = false;
        human.jump = true;
    }    
}

function keyReleased() {
    if (keyCode == LEFT_ARROW) {
        left = false;
    }
    if (keyCode == RIGHT_ARROW) {
        right = false;
    }        

    if (key === ' ') {
        human.jumpReady = true;
        human.jump = false;
    }    
}

