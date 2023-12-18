ArrayList<Boid> boids;
void setup(){
  size(800,800);
  boids = new ArrayList<>();
  for(int i = 0 ; i < 500 ; i++){
    boids.add(new Boid(random(width), random(height)));
  }
 
  
}

void draw(){
  background(0);
  for(Boid b : boids){
    b.show();
    b.update();
    
    seperation(b);
    alignment(b);
    cohesion(b);

  }
  
}
