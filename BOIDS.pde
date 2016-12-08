agents[] a=new agents[1000];


void setup(){
  size(500,500);
  ellipseMode(CENTER);
  colorMode(HSB);
  smooth();
  
  
  for(int i=0; i<a.length;i++){
    a[i]=new agents(random(10,height-10),random(10,width-10));
  }
}

void draw(){
  background(32);
  
  
  for(agents i: a){
    i.display();
  }

  //saveFrame("B3/l_##.tga");

}
