// A rectangular box as the duckweed
class Weed {

  // We need to keep track of a Body and a width and height
  Body body;
  MouseJoint mouseJoint;
  float w;
  float h;

  // Constructor
  Weed(float x, float y) {
    w = 2;//random(4, 16);
    h = 2;//random(4, 16);
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);

    //to let the weed "magically" go back to the position we attach a very very soft spring
    //that pulls it back to the initial assigned position in the grid but does not affect the rotation 
    MouseJointDef md = new MouseJointDef();
    //attach it to the ground
    md.bodyA = box2d.getGroundBody();
    // Body 2 is the box's boxy
    md.bodyB = body;
    Vec2 mp = box2d.coordPixelsToWorld(new Vec2(x, y));
    // And that's the target
    md.target.set(mp);
    // Some stuff about how strong and bouncy the spring should be
    //ver soft with a high daming to give floating effect
    md.maxForce = 0.35 * body.m_mass;
    md.frequencyHz = 2.0;
    md.dampingRatio = 0.8;

    // Make the joint!
    mouseJoint = (MouseJoint) box2d.world.createJoint(md);
    mouseJoint.setTarget(box2d.coordPixelsToWorld(new Vec2(x, y)));
  }

   // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0, 175, 0);
    noStroke();
    //draw the rectangle a bit bigger than the collision body for more floating effect
    //or the the leaves do not interact too much with eacht other
    rect(0, 0, w+4, h+4);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
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
    fd.density = 0.01; // in realtion to the swan they are super light since the since relation does not match
    fd.friction = 1; //friction with each other to avoid that the swan pushes it through and give it more floating effect
    fd.restitution = 0; //avoid bounciness

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
   
    bd.linearDamping = 0.5f;
    bd.allowSleep = true;
    
    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity to have the floating leaves effect and to avoid to absolute "perfect grid"
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-3, 3));
  }
}
