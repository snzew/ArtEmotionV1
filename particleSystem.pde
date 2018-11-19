import java.util.*;


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
  int particleNumber = 500;
  
  ParticleSystem(){
  }

  void addParticle(PVector location){
    position = location.get();
    for(int i = 0 ; i < particleNumber; i++){
      particle = new Particle();
      if(millis() > time + 5){
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

  void showParticle(){
    for(int i = particleList.size() - 1; i >= 0; i--){
      Particle part = particleList.get(i);
      part.run();
      if(part.isDead()){
        particleList.remove(part);
      }
    }
  }

  void repulseParticle(){
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

	void getAttracted(PVector location){
    hand = new Attractor(location);

		for(Particle part : particleList){
			force = hand.attract(part);
			part.applyForce(force);
		}
	}

	void getRepulsed(PVector handPos){
		hand = new Attractor(handPos);

		for(Particle part : particleList){
			force = hand.repulse(part);
			part.applyForce(force);
		}

	}

  void run(){
    repulseParticle();
    showParticle();
  }
}
