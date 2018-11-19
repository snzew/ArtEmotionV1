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
	particleSystem.addParticle(new PVector(random(width), random(height)));

	particleSystem.run();
	
	float sumX = 0;
	float sumY = 0;
	float totalPixels = 0;
	float avgX = 0;
	float avgY = 0 ;

	int[] depth = kinect.getRawDepth();

	for(int x = 0; x < kinect.width; x++){
		for(int y = 0; y < kinect.height; y++){
			
			int offset = x + y * kinect.width;
			int depthValue = depth[offset];
			int minTrash = 650;
			int maxTrash = 745;
		

			if(depthValue > minTrash && depthValue < maxTrash){
				sumX += x;
				sumY += y;
				totalPixels ++;
				// avgX = sumX / totalPixels;
				// avgY = sumY / totalPixels;
				// if(totalPixels > 500){
				// 	PVector avgPosition = new PVector(x,y);
				// 	PVector avgPosition = new PVector(random(x - 50, x + 50), random(y - 50, y + 50));
				// 	fill(255);
				// 	ellipse(x,y,20,20);
				// 	particleSystem.getAttracted(x,y); //avgPosition);
				// 	particleSystem.getAttracted(avgPosition);
				// 	println(avgPosition);
				// }

			}
		}
	}
	avgX = sumX / totalPixels;
	avgY = sumY / totalPixels;
	
	PVector avgPosition = new PVector(avgX, avgY);

	if(totalPixels > 8000){
		particleSystem.getAttracted(avgPosition);
		println("pixe: " + totalPixels);
	}else if(totalPixels > 50 && totalPixels  < 8000){
		println(totalPixels);
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