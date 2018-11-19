import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.openkinect.processing.*; 
import processing.sound.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class projectV2 extends PApplet {




Kinect kinect;
ParticleSystem particleSystem;
Sound sound;
Attractor hand;
PImage img;
ColourGenerator colour = new ColourGenerator();
float time = 0;

public void setup(){
	
	//size(1280, 480);
	
	kinect = new Kinect(this);
	kinect.initDepth();
	kinect.enableMirror(true);

	particleSystem = new ParticleSystem();
	//sound = new Sound(this);
	particleSystem.addParticle(new PVector(random(width), random(height)));
	img = createImage(kinect.width, kinect.height, RGB);
}

public void draw(){
	background(0);
	// if(millis() > time + 50){
	// 	particleSystem.addParticle(new PVector(random(width), random(height)));
	// 	time = millis();
	// }
		particleSystem.addParticle(new PVector(random(width), random(height)));


	image(kinect.getDepthImage(), 640, 0);

	particleSystem.run();
	float sumX = 0;
	float sumY = 0;
	float totalPixels = 0;
	float avgX = 0;
	float avgY =0 ;

	
	int[] depth = kinect.getRawDepth();
	img.loadPixels();

	for(int x = 0; x < kinect.width; x++){
		for(int y = 0; y < kinect.height; y++){
			
			int offset = x + y * kinect.width;
			int depthValue = depth[offset];
			int minTrash = 500;
			int maxTrash = 740;

			if(depthValue > minTrash && depthValue < maxTrash){
				//img.pixels[offset] = color(255,0, 150);
				sumX += x;
				sumY += y;
				totalPixels ++;
			}
		}
	}
	 avgX = sumX / totalPixels;
	 avgY = sumY / totalPixels;

	//img.updatePixels();
	
	PVector avgPosition = new PVector(avgX, avgY);

	if(totalPixels > 4500){
		particleSystem.getAttracted(avgPosition);
	}else if(totalPixels > 0 && totalPixels < 4000){
		particleSystem.getRepulsed(avgPosition);
	}
}


// else if(totalPixels > 15000 && depthValue < 690){
	// 	println("totalPix: " + totalPixels);
	// 	particleSystem.getAttracted(avgPosition);
	// }
	// if(totalPixels > 500 && totalPixels < 10000){
	// 	println("depth:" + depthValue);
	// 	particleSystem.getAttracted(avgPosition);
	// }
	// if(depthValue > 660 && depthValue < 675){
	// 	particleSystem.getRepulsed(avgPosition);
	// }
	//avgPosition = new PVector(avgX, avgY);
	//particleSystem.getAttracted(avgPosition);

	//println("avgPosition : " + avgPosition);
	//image(img, 0, 0);
class ColourGenerator
{
  final static float MIN_SPEED = 0.2f;
  final static float MAX_SPEED = 0.7f;
  float R, G, B;
  float Rspeed, Gspeed, Bspeed;
  
  ColourGenerator()
  {
    init();  
  }
  
  public void init()
  {
    // Starting colour
    R = random(255);
    G = random(255);
    B = random(255);
    
    // Starting transition speed
    Rspeed = (random(1) > 0.5f ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Gspeed = (random(1) > 0.5f ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Bspeed = (random(1) > 0.5f ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
  }
  
  public void update()
  {
    // Use transition to alter original colour (Keep within RGB bounds)
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
  
}
class Attractor{
	Particle particle;
	float mass;
	PVector location;
	float g;
	float strength;
	float distance;

	Attractor(PVector position){
		location = position.get();
		mass = 20; // later one try with depthvalue
		g = 5;
	}

	public PVector attract(Particle particle){
		PVector force = PVector.sub(location, particle.position);
		distance = force.mag();
		force.normalize();
		//strength = (g * mass * particle.mass) * (distance * distance);
		strength = g / distance * distance;
		force.mult(strength);
		ColourGenerator colour = new ColourGenerator();
    colour.update();
		return force;
	}

	public PVector repulse(Particle particle){
		PVector force = PVector.sub(location, particle.position);
		distance = force.mag();
		force.normalize();
		strength = -1 * g / distance* distance;//
		//strength = (g * mass * particle.mass) * (distance * distance); 
		force.mult(strength);
    colour.update();
		
		return force;
	}
}
class Particle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  int index;
  float mass;
  PVector force;
  int lifespan;  

  Particle(){
    mass = random(10);
    position = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(random(-1,1), random(-1,1));
    lifespan = 255;
  }
    
  public void applyForce(PVector f){
    PVector force = PVector.div(f, mass);
    acceleration.add(force);
  }

  public PVector repulse(Particle part){
    float g = 5;
    force = PVector.sub(position, part.position);
    float distance = force.mag();

    force.normalize();
    float strength = (g * mass * part.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }

  public void display(){
    fill(colour.R, colour.G, colour.B, lifespan);
    ellipse(position.x, position.y, mass * 2, mass * 2);
  }

  public void move(){
    //println("partPosition: " + position);
    velocity.add(acceleration);
    velocity.limit(3);
    position.add(velocity);

    acceleration.mult(0);
    lifespan -= 0.005f;
  }

  public void checkEdges(){

    if(position.x < 0){
      position.x = 0.1f;
      velocity.x *= -1;
    }
    if(position.x > width){
      position.x = width - 1;
      velocity.x *= -1;
    }
    if(position.y < 0){
      position.y = 0.1f;
      velocity.y *= -1;
    }
    if(position.y > height){
      position.y = height - 1;
      velocity.y *= -1;
    }
  }

  public void setIndex(int in){
    index = in;
  }

  public int getIndex(){
    return index;
  }

  public boolean isDead(){
    if(lifespan == 0){
      return true;
    }
    return false;
  }

  // void changeColor(){
  // //fillColor = color(random(255), random(255), random(255));
  // fillColor = color(0,160, random(255));
  // }


  public void run(){
    checkEdges();
    move();
    display();
  }
}



class ParticleSystem{
  Particle particle;
  ArrayList<Particle> particleList = new ArrayList<Particle>();
  Iterator<Particle> itr = particleList.iterator();
  Attractor hand;
  PVector position;
  PVector force;
	PVector handPosition;
  float time = 0;

  int index;
  int particleNumber = 1000;
  
  ParticleSystem(){
  }

  public void addParticle(PVector location){
    position = location.get();
    for(int i = 0 ; i < particleNumber; i++){
      particle = new Particle();
      if(millis() > time + 10){
        particleList.add(particle);
        time = millis();
      }
      // particleList.add(index, particle);
      // particle.setIndex(index);
      // index = i;
    }
  }

  // void addParticle(PVector location){
  //   position = location.get();
  //   if(particleList.size() < 500){
  //     particleList.add(new Particle());
  //   }
  // }

  public void showParticle(){
    for(int i = particleList.size() -1; i >= 0; i--){
      Particle part = particleList.get(i);
      part.run();
      if(part.isDead()){
        particleList.remove(part);
      }
    }
  }

  public void repulseParticle(){
    for(int i = 0; i < particleList.size(); i++){
      for(int j = 0; j< particleList.size(); j++){
        if(i != j){
          Particle p1 = particleList.get(i);
          Particle p2 = particleList.get(j);
          float distance = dist(p1.position.x, p1.position.y, p2.position.x, p2.position.y);

          if(distance < 10){
            force = p1.repulse(p2);
            p1.applyForce(force);
          }
        }
      }
    }
  }

	public void getAttracted(PVector location){
    handPosition = location.get();
		hand = new Attractor(handPosition);

		for(Particle part : particleList){
			force = hand.attract(part);
			part.applyForce(force);
		}
	}

	public void getRepulsed(PVector handpos){
		handPosition = handpos.get();
		hand = new Attractor(handPosition);

		for(Particle part : particleList){
			force = hand.repulse(part);
			part.applyForce(force);
		}

	}

  public void run(){
    repulseParticle();
    showParticle();
  }
}
  public void settings() { 	size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "projectV2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
