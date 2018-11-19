class Attractor{
	Particle particle;
	float mass;
	PVector location;
	float g;
	float strength;
	float distance;

	Attractor(PVector position){
	//Attractor(float x, float y){
		location = position.get();
		//location = new PVector(x,y);
		mass = 20; // later one try with depthvalue
		g = 5;
	}

	PVector attract(Particle particle){
		PVector force = PVector.sub(location, particle.position);
		//PVector force = location.sub(particle.position);
		distance = force.mag();
		force.normalize();
		//strength = (g * mass * particle.mass) * (distance * distance);
		strength = g / distance * distance;
		force.mult(strength);
    colour.update();
		
		return force;
	}

	PVector repulse(Particle particle){
		PVector force = PVector.sub(location, particle.position);
		distance = force.mag();
		force.normalize();
		strength = -1 * g / distance * distance;//
		//strength = (g * mass * particle.mass) * (distance * distance); 
		force.mult(strength);
    colour.update();
		
		return force;
	}
}