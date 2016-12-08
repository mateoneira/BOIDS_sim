class agents{
  
  //initial position,velocity, acceleration  and color
  PVector position= new PVector();
  PVector velocity= new PVector();
  PVector acceleration= new PVector();
  
  float H=int(random(256));
  float H1=H;
  float maxspeed=1.5;
  float maxforce=0.03;
  int r=3;
  
  agents(float x,float y){
    position= new PVector(x,y);
    
    //generates angle to calculate velocity
    float angle = random(TWO_PI);
    
    //creates initial velocity and acceleration
    acceleration=new PVector(0,0);
    
    //generate random angle and calcular velocity
    velocity= new PVector(cos(angle),sin(angle));
    
    
  }
  
  //draws the agents
  void display(){
    //fill(H,200,255);
    noFill();
    strokeWeight(2);
    stroke(H,200,255);
    
    pushMatrix();
      translate(position.x,position.y);
      rotate(velocity.heading()+radians(90));
      beginShape();
        vertex(-r*cos(0.8),r*sin(0.8));
        vertex(r*cos(0.8),r*sin(0.8));
        vertex(0,-r);
      endShape(CLOSE);
    popMatrix();
    
    //updates agents based on different rules
    separation();
    alignment();
    cohesion();
    borderCheck();
    update();
    
  }
  
  //updates velocity with accelaration
  void update(){
    
    //updates velocity 
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    
    //changes position of agent
    position.add(velocity);
    
    //reset acceleration
    acceleration.mult(0);
  }
  
  //method for checking border
  void borderCheck(){
    PVector target;
    PVector desired;
    
    //if agent is going towards edge steer in oposite direction
    //we can try to make this better 
    //if(position.x<=r || position.x>=width-r) velocity.x*=-1;
    //if(position.y<=r || position.y>=height-r) velocity.y*=-1;
    if(position.x<=r*5){
      target= new PVector(0,position.y);
      desired=PVector.sub(position,target);
      desired.normalize();
      desired.limit(maxforce*7);
      acceleration.add(desired);
    }
    
    if(position.x>=width-(r*5)){
      target= new PVector(width-r,position.y);
      desired=PVector.sub(position,target);
      desired.normalize();
      desired.limit(maxforce*7);
      acceleration.add(desired);  
    }
    
    if(position.y<=r*5){
      target= new PVector(position.x,0);
      desired=PVector.sub(position,target);
      desired.normalize();
      desired.limit(maxforce*7);
      acceleration.add(desired); 
    }
    
    if(position.y>=height-(r*5)){
      target= new PVector(position.x,height);
      desired=PVector.sub(position,target);
      desired.normalize();
      desired.limit(maxforce*7);
      acceleration.add(desired); 
    }
    
  } 
  
  //steer to avoid crowding local flockmates
  void separation(){
    //for loop of agents
    PVector desired = new PVector(0, 0);

    //keeps track of number of neighboors
    int count = 0;
    for(agents all: a){
      float d = PVector.dist(position, all.position);
      
      //if distance is less than set amount than consider neighboor
      if(d>0 && d<r*3){
        PVector dir=PVector.sub(position, all.position);
        dir.normalize();
        dir.div(d); 
        desired.add(dir);
        count++;
      }
    }
    
    if(count>0){
      desired.div(count);
      desired.mult(maxspeed);
      desired.normalize();
      desired.sub(velocity);
      desired.limit(maxforce*2);
    }
    
    acceleration.add(desired);
  }
  
  //steer towards the average heading of local flockmates
  void alignment(){
    PVector desired = new PVector(0, 0);
    int count=0;
    
    for(agents all: a){
      float d = PVector.dist(position, all.position);
      
      //if distance is less than set amount than consider neighboor
      if(d>0 && d<r*6){
        desired.add(all.velocity);
        count++;
      }
    }
    
    if(count>0){
      desired.div(count);
      desired.normalize();
      desired.mult(maxspeed);
      desired.sub(velocity);
    }
    
    desired.limit(maxforce);
    acceleration.add(desired);
    
  }
  
  //steer to move toward the average position of local flockmates
  void cohesion(){
    PVector desired = new PVector(0, 0);
    int count=0;
    float h0=H;
    
    for(agents all: a){
      float d = PVector.dist(position, all.position);
      
      //if distance is less than set amount than consider neighboor
      if(d>0 && d<r*7){
        desired.add(all.position);
        count++;
        h0+=all.H;
      }
    }
    
    if(count>0){
      desired.div(count);
      desired.normalize();
      desired.mult(maxspeed);
      desired.sub(velocity);
      H=map(-count,-30,-1,0,255);
      println(count);
    }
    
    if(count==0) H=H1;
    
    
  }
  
}