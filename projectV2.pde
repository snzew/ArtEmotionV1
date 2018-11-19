import org.openkinect.processing.*;
import processing.sound.*;

Kinect kinect;
ParticleSystem particleSystem;
Sound sound;
Attractor hand;
PImage img;
ColourGenerator colour = new ColourGenerator();
float time = 0;

void setup(){
	size(640, 480);
	//size(1280, 480);
	
	kinect = new Kinect(this);
	kinect.initDepth();
	kinect.enableMirror(true);

	particleSystem = new ParticleSystem();
	//sound = new Sound(this);
	particleSystem.addParticle(new PVector(random(width), random(height)));
	img = createImage(kinect.width, kinect.height, RGB);
}

void draw(){
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