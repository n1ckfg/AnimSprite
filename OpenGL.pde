import processing.opengl.*;
import javax.media.opengl.*;

PGraphicsOpenGL pgl;
GL gl;

void setupGl(){
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
}

void drawGl(){
  pgl.beginGL();
  gl.glDisable(GL.GL_DEPTH_TEST);// This fixes the overlap issue
  gl.glEnable(GL.GL_BLEND);  // Turn on the blend mode
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);  // Define the blend mode
  pgl.endGL();
}

