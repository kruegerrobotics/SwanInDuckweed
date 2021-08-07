class Swan {

  // We need to keep track of a Body and a width and height
  Body body;
  Vec2 pos;
  float w;
  float h;
  float bodyRadius = 25;

  // Constructor
  Swan(float x, float y) {


    // Make each individual body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    bd.fixedRotation = true; // no rotation! the swan is a circle
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);

    // The body is a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(bodyRadius);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

     // Parameters that affect physics
    fd.density = 1;

    // Finalize the body
    body.createFixture(fd);

    //just once to have a pixel pos
    pos = box2d.getBodyPixelCoord(body);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

/*
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }
*/
  // Drawing the box
  void display() {
    pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(255);
    noStroke();
    strokeWeight(1);
    ellipse(0, 0, bodyRadius*2, bodyRadius*2);
    popMatrix();
  }

  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }

  // This function adds the swan to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0; //for body body interattin the weeds should not rub heavy on the swan 
    fd.restitution = 0; //avoid bounciness of the weeds pushes by the swan

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
  }
}
