import shiffman.box2d.*; //<>//
import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

//Using Box2d as physics engine
Box2DProcessing box2d;

//the elements
ArrayList<Boundary> boundaries;
ArrayList<Weed> boxes;
Swan swan;
PVector dest;

void setup() {
  size(640, 640);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, 0);


  boundaries = new ArrayList<Boundary>();
  //static walls around our swimming pool
  boundaries.add(new Boundary(width/2, 3, width, 6));
  boundaries.add(new Boundary(width/2, height-3, width, 6));
  boundaries.add(new Boundary(3, height/2, 6, height));
  boundaries.add(new Boundary(width-3, height/2, 6, height));

  boxes = new ArrayList<Weed>();

  //Raster Six - 6 based on experience
  //leave first and last row/column out since we have the pool walls
  int raster = 6;
  for (int i=2; i<width/raster; i++) {
    for (int j=2; j<height/raster; j++) {
      Weed p = new Weed(i*raster, j*raster);
      boxes.add(p);
    }
  }
  swan = new Swan(width/2, height*2/3);
  
  //destination where the swan wants to go to
  dest = new PVector(swan.pos.x, swan.pos.y);
}

void draw() {
  background(20);
  
  //step the physics solver
  box2d.step();

  //draw the pool bounds
  for (Boundary wall : boundaries) {
    wall.display();
  }

  if (mousePressed) {
    //the swan gets a new destination
    dest = new PVector(mouseX, mouseY);
  }

  PVector diff = PVector.sub(dest, new PVector(swan.pos.x, swan.pos.y));
  //implementation of a velocity controller (position control implicit since we have to use forces to control the swan)
  //target velocity/direction is the the difference but clamped to not exceed swan max vel
  float maxVel = 4.2;  //empirical 4 
  PVector targetVel = new PVector();
  targetVel = diff.copy().normalize();
  float correctionMargin;
  //check for the margin to max speed and div by zero protection
  if (targetVel.mag() != 0) {
    correctionMargin = maxVel / targetVel.mag();
  } else {
    correctionMargin = 100;
  }
  targetVel = targetVel.mult(correctionMargin);
  //Warning ugly y negative swap and x negative swap since coordinate systems of the graphics and physics world differ
  //should replace it with the appropiate transformation a la "scalarPixelsToWorld"
  //difference of desired velocity to actual to feed into the the velocity controller
  PVector velDiff = PVector.sub(new PVector(swan.body.getLinearVelocity().x, -swan.body.getLinearVelocity().y), targetVel);
  //same thing warning negative x swap
  Vec2 steerForce = new Vec2(-velDiff.x, velDiff.y);
  steerForce = steerForce.mul(15); //in principle just a simple P-control, this is gain for P - the swan ...could have stronger legs
  swan.applyForce(steerForce);
  
  // Display all the weeds/boxes
  for (Weed b : boxes) {
    b.display();
  }

  swan.display();

  //draw the swans goal
  fill(255, 165, 0);
  noStroke();
  ellipse(dest.x, dest.y, 15, 15);
  //println("FPS: " + frameRate);
}
