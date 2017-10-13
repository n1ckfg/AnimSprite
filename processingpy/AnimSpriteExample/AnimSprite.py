# uses bits from...
class AnimSprite:
    frames = []
    loopIn = 0
    index = loopIn
    loopOut, fps
    speed
    playing = true
    playOnce = false
    is3D = False
    isTexture = False
    debug = False
    hovered = False
    clicked = False
    #position, rotation, scale, target
    r
    p,r3D,s,t
    uvs = []
    vertices = []
    vertices_proj = []
    w
    h
    ease = 100

    #folder of frames method
    AnimSprite(_name, _fps):
        loadFrames(_name)
        loopOut = frames.length 
        fps = _fps
        init()

    AnimSprite(PImage[] _name, int _fps):
        frames = _name
        loopOut = frames.length 
        fps = _fps
        init()
    
    #spritesheet method
    AnimSprite(String _name, int _fps, int _tdx, int _tdy, int _etx, int _ety):
        loadSpriteSheet(_name, _tdx,_tdy,_etx,_ety)
        loopOut = frames.length 
        fps = _fps
        init()

    #~~~~~~~~~~~~~~~~~~~~~~
    def init():
        if (is3D == False):
            p = new PVector(0, 0)
            r = 0
            s = new PVector(1, 1)
            t = new PVector(0, 0)
        else:
            p = new PVector(0, 0, 0)
            r3D = new PVector(0, 0, 0)
            s = new PVector(1, 1)
            t = new PVector(0, 0, 0)
        
        w = frames[0].width
        h = frames[0].height
    
    def make3D():
        is3D = True
        isTexture = False
        init()
    }
    
    def makeTexture():
        is3D = true
        isTexture = true
        init()
        vertices[0] = new PVector(-1*(frames[0].width/2),-1*(frames[0].height/2))
        vertices[1] = new PVector(frames[0].width/2,-1*(frames[0].height/2))
        vertices[2] = new PVector(frames[0].width/2,frames[0].height/2)
        vertices[3] = new PVector(-1*(frames[0].width/2),frames[0].height/2)
        uvs[0] = new PVector(0,0)
        uvs[1] = new PVector(frames[0].width,0)
        uvs[2] = new PVector(frames[0].width,frames[0].height)
        uvs[3] = new PVector(0,frames[0].height) 
    
    def make2D():
        is3D = False
        isTexture = False
        init()
    
    vertToProj(_p, _centerPoint):
        return new PVector(_p.x + _centerPoint.x,_p.y + _centerPoint.y)
    
    projToVert(_p, _centerPoint):
        return new PVector(_p.x - _centerPoint.x,_p.y - _centerPoint.y)
    
    #~~~~~~~~~~~~~~~~~~~~~~
    
    def loadFrames(_name):
        try:
            #loads a sequence of frames from a folder
            filesCounter=0
            File dataFolder = new File(dataFile(sketchPath()).getAbsolutePath(), "data/"+_name) 
            allFiles = dataFolder.list()
            for i in range(0, len(allFiles)):
                if (allFiles[i].toLowerCase().endsWith("png")):
                    filesCounter++
            #--
            frames = []
            for i in range(0, filesCounter):
                println("Loading " + _name + "/frame" + (i+1) + ".png")
                frames[i] = loadImage("data/"+_name + "/frame" + (i+1) + ".png")
        catch(Exception e):
            pass
    
    def loadSpriteSheet(_name, _tdx, _tdy, _etx, _ety):
            try:
                #loads a spritesheet from a single image
                fromImg = loadImage("data/"+_name + ".png")
                tileX = 1
                tileY = 1
                tileDimX = _tdx
                tileDimY = _tdy
                endTileX = _etx
                endTileY = _ety
                #--
                frames = []
                for i in range(0, _etx*_ety):
                    if tileX + tileDimX <= (endTileX*tileDimX):
                        tileX += tileDimX
                    elif tileY + tileDimY<=(endTileY*tileDimY):
                        tileY += tileDimY
                        tileX = 1
                    else:
                        tileX = 1
                        tileY = 1

                    println("Loading frame" + (h+1) + " from " + _name + ".png")
                    frames[h] = fromImg.get(tileX, tileY, tileDimX, tileDimY)
            catch(Exception e):
                pass

#~~~~~~~~~~~~~~~~~~~~~~

    def setSpeed(_fps):
        speed = _fps/parseFloat(frameRate)
    
    def update():
        setSpeed(fps)
        if(playing):
            index += speed
            if (index >= loopOut):
                if (playOnce):
                    playing = False
                else:
                    index = loopIn

    def draw():
        frameIndex = parseInt(index)
        pushMatrix()
        #translate, rotate, scale
        if (is3D == False)
            translate(p.x, p.y)
            rotate(radians(r))
            scale(s.x, s.y)
        else:
            translate(p.x, p.y, p.z)
            rotate(radians(r))
            rotateXYZ(r3D.x, r3D.y, r3D.z)
            scale(s.x, s.y)
        
        #draw
        if (isTexture == False):
            imageMode(CENTER)
            image(frames[frameIndex], 0, 0)
        else:
            for i in range(0, len(vertices)):
                vertices_proj[i] = vertToProj(vertices[i],p)
                
            noFill()
            noStroke()
            beginShape(QUADS)
            texture(frames[frameIndex])
            vertex(vertices[0].x,vertices[0].y,uvs[0].x,uvs[0].y)
            vertex(vertices[1].x,vertices[1].y,uvs[1].x,uvs[1].y)
            vertex(vertices[2].x,vertices[2].y,uvs[2].x,uvs[2].y)
            vertex(vertices[3].x,vertices[3].y,uvs[3].x,uvs[3].y)
            endShape(CLOSE)
            
            if(debug){
                noStroke()
                ellipseMode(CENTER)
                fill(255,0,0)
                ellipse(vertices[0].x,vertices[0].y,5,5)
                fill(0,255,0)
                ellipse(vertices[1].x,vertices[1].y,5,5)
                fill(0,0,255)
                ellipse(vertices[2].x,vertices[2].y,5,5)
                fill(255,0,255)
                ellipse(vertices[3].x,vertices[3].y,5,5)
        popMatrix()
        
    def run():
        update()
        draw()
        
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #utilities

    def rotateXYZ(_x, _y, _z):
        rotateX(radians(_x))
        rotateY(radians(_y))
        rotateZ(radians(_z))

    #simplifies the unnecessarily complex blend command image, x, y, width, height, center/corner
    def blendImage(PImage bI, int pX, int pY, String b, boolean center) {
        String[] blendModes = { 
            "BLEND", "ADD", "SUBTRACT", "LIGHTEST", "DARKEST", "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN", "OVERLAY", "HARD_LIGHT", "SOFT_LIGHT", "DODGE", "BURN"
        }
        int[] blendModeCodes = { 
            1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192
        }
        for (int i=0i<blendModes.lengthi++) {
            if (b==blendModes[i]) {
                int qX, qY
                if (center) {
                    qX=pX-(bI.width/2)
                    qY=pY-(bI.height/2)
                } 
                else {
                    qX=pX
                    qY=pY
                }
                blend(bI, 0, 0, bI.width, bI.height, qX, qY, bI.width, bI.height, blendModeCodes[i])
            }
        }
    }

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    #basic behaviors

    #Tween movement.    start, end, ease (more = slower).
    float tween(float v1, float v2, float e) {
        v1 += (v2-v1)/e
        return v1
    }

    PVector tween3D(PVector v1, PVector v2, PVector e) {
        v1.x += (v2.x-v1.x)/e.x
        v1.y += (v2.y-v1.y)/e.y
        v1.z += (v2.z-v1.z)/e.z
        return v1
    }
    
    float shake(float v1, float s) {
        v1 += random(s) - random(s)
        return v1
    }

    float boundary(float v1, float vMin, float vMax) {
        if (v1<vMin) {
            v1 = vMin
        } 
        else if (v1>vMax) {
            v1=vMax
        } 
        return v1
    }

    float gravity(float v1, float v2, float v3) { #y pos, floor num, gravity num
        if (v1<v2) {
            v1 += v3
        }
        if (v1>v2) {
            v1 = v2
        }
        return v1
    }

    #2D Hit Detect.    Assumes center.    x,y,w,h of object 1, x,y,w,h, of object 2.
    boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
        w1 /= 2
        h1 /= 2
        w2 /= 2
        h2 /= 2 
        if (x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
            return true
        } 
        else {
            return false
        }
    }
    
        #3D Hit Detect.    Assumes center.    xyz, whd of object 1, xyz, whd of object 2.
   def hitDetect3D(p1, s1, p2, s2):
        s1.x /= 2
        s1.y /= 2
        s1.z /= 2
        s2.x /= 2
        s2.y /= 2 
        s2.z /= 2 
        if (    p1.x + s1.x >= p2.x - s2.x && 
                    p1.x - s1.x <= p2.x + s2.x && 
                    p1.y + s1.y >= p2.y - s2.y && 
                    p1.y - s1.y <= p2.y + s2.y &&
                    p1.z + s1.z >= p2.z - s2.z && 
                    p1.z - s1.z <= p2.z + s2.z
            )
            return True
        else:
            return False