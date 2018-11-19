import org.openkinect.processing.*;
import processing.sound.*;

Kinect kinect;
ParticleSystem particleSystem;
Sound sound;
Attractor hand;
ColourGenerator colour = new ColourGenerator();

void setup(){
	size(640, 480);
	
	kinect = new Kinect(this);
	kinect.initDepth();
	kinect.enableMirror(true);

	particleSystem = new ParticleSystem();
	//sound = new Sound(this);
	//particleSystem.addParticle(new PVector(random(width), random(height)));
}

void draw(){
	background(0);
	particleSystem.addParticle(new PVector(random(width), random(height)));

	particleSystem.run();
	
	float sumX = 0;
	float sumY = 0;
	float sumZ = 0;
	float totalPixels = 0;
	float avgX = 0;
	float avgY = 0;
	float avgZ = 0;
	

	int[] depth = kinect.getRawDepth();

	for(int x = 0; x < kinect.width; x++){
		for(int y = 0; y < kinect.height; y++){
			
			int offset = x + y * kinect.width;
			int depthValue = depth[offset];
			int minTrash = 500;
			int maxTrash = 745;

			if(depthValue > minTrash && depthValue < maxTrash){
				sumX += x;
				sumY += y;
				sumZ += depthValue;
				totalPixels ++;
			}
		}
	}

	avgX = sumX / totalPixels;
	avgY = sumY / totalPixels;
	avgZ = Math.round(sumZ / (totalPixels * 10));
	//println("depth: " + avgZ);
	PVector avgPosition = new PVector(avgX, avgY);
	//println("avgZ before: " + avgZ);
	if(avgZ > 65 && avgZ <= 72){
		//println(avgZ);
		particleSystem.getAttracted(avgPosition);
	}else if(avgZ > 72 && avgZ < 75){
		particleSystem.getRepulsed(avgPosition);
	}
}