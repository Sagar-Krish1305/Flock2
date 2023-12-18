
int boidSize = 3;
float viewRadius = 40;
float limitRadius = 8;

float avoidFactor = 0.05;
float matchingFactor = 0.05;
float centeringFactor = 0.0005;
float maxSpeed = 6;
float minSpeed = 3;

float turnFactor = 0.2;

float spawnRadius = 10;
class Boid{
  
  PVector velocity, position;
  
  
  Boid(float x, float y){
    this.velocity = new PVector(random(minSpeed,maxSpeed), -random(minSpeed,maxSpeed));
    this.position = new PVector(x,y);
  }
  
  void update(){
      this.position.add(this.velocity);
      float speed = sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
      if(speed > maxSpeed){
        velocity.x = 1.0 * velocity.x / speed * minSpeed;
        velocity.y = 1.0 * velocity.y / speed * minSpeed;
      }else if(speed < minSpeed){
        velocity.x = 1.0 * velocity.x / speed * maxSpeed;
        velocity.y = 1.0 * velocity.y / speed * maxSpeed;
      }
      

      
      if(position.x < 0){
        velocity.x += turnFactor;
      }else if(position.x > width){
        velocity.x -= turnFactor;
      }else if(position.y > height){
        velocity.y -= turnFactor;
      }else if(position.y < 0){
        velocity.y += turnFactor;
      }
  }
  
  //void updateVelocity(){
    
  //   velocity.x = cos(angle - PI/2);
  //   velocity.y = sin(angle - PI/2);
  //   stroke(255);
     
  //}
  
  
  
  void show(){
    push();
      translate(position.x, position.y);
      stroke(0,255,0);
      //line(0, 0, 10*velocity.x, 10*velocity.y);
      //rotate(atan((velocity.x < 0 && velocity.y < 0 ? 1 : -1) * velocity.y/velocity.x) + PI/2);
      //rotate( - atan(velocity.y/velocity.x) - PI/2);
      // Arc
      
      fill(255,50);
      //arc(0, 0, 2*viewRadius, 2*viewRadius, -viewAngle - PI/2, +viewAngle - PI/2);
      
      makeBoid();
    pop();
  }
  
  
  
}



void makeBoid(){
  
  fill(255,0,0);
  stroke(0);
  //beginShape();
  //  vertex(0,-boidSize);
  //  vertex(-boidSize,+boidSize);
  //  vertex(+boidSize,+boidSize);
  //  vertex(0,-boidSize);
  //endShape(CLOSE);
  
  circle(0 , 0 , 2*boidSize);
  
}

void seperation(Boid b){
  float close_dx = 0, close_dy = 0;
  for(Boid boid : boids){
    if(PVector.dist(boid.position, b.position) <= limitRadius){
      close_dx = b.position.x - boid.position.x - close_dx;
      close_dy =  b.position.y - boid.position.y - close_dy;
    }
  }
  PVector closeness = new PVector(close_dx, close_dy);
  //closeness.normalize();
  b.velocity.x += closeness.x * avoidFactor;
  b.velocity.y -= closeness.y * avoidFactor;
}

void alignment(Boid b){
  PVector avgVel = new PVector(0,0);
  int count = 0;
  for(Boid boid : boids){
    if(PVector.dist(boid.position, b.position) <= viewRadius){
      avgVel.x += boid.velocity.x;
      avgVel.y += boid.velocity.y;
      count++;
    }
  }
  
  avgVel.div(count!=0 ? count : 1);
  
  b.velocity.x += (avgVel.x - b.velocity.x) * matchingFactor;
  b.velocity.y -= (avgVel.y - b.velocity.y) * matchingFactor;
}

void cohesion(Boid b){
  PVector avgPoint = new PVector(0,0);
  int count = 0;
  for(Boid boid : boids){
    if(boid!=b && PVector.dist(boid.position, b.position) <= viewRadius + limitRadius){
      avgPoint.x += boid.position.x;
      avgPoint.y += boid.position.y;
      count++;
    }
  }
  
  avgPoint.div(count!=0 ? count : 1);
  
  b.velocity.x += (avgPoint.x - b.position.x) * centeringFactor;
  b.velocity.y -= (avgPoint.y - b.position.y) * centeringFactor;
}
