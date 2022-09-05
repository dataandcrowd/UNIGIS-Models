/**
* Name: Lions
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model Lions

/* Insert your model definition here */

global  {
	int l_count <-0;
  init {
    create lions number:15 {
      age <- 0;/*int(rnd(5));*/
      energy <- 100.0 ;
      l_color <- rgb(255,0,0);
    }
    
    create zebras number:15 {
    	age <- 5;
    }
  }
}


species lions {
  int age;
  float energy;
  rgb l_color; 
  
  
  aspect default {
    draw circle (2) color: l_color;
  } 
  
  reflex change{
  	if(rnd(4) > 2){
  		l_color <- rgb(0,255,0);
  	}
  }
  
  
  reflex age{
  	age<-age+1;
  }
  
  
}


species zebras skills: [moving]{
  int age <- 0;

  reflex get_older {
    age <- age + 1;
    if age > 15 {
      do die_of_age;
    }
  }
  
  // zebra behaviour: random movement
  reflex moveAround {
    do wander amplitude: 90.0 speed: 200.0 ;
  }
  
  
  action die_of_age {
    write "I am going to die!";
    do die;
  }
  
  aspect default {
    draw square (2) color: #black;
  }
}



experiment mySimulation type: gui {
	
  output    {
 
    display myMap type: opengl {
      species lions aspect:default;
      species zebras aspect:default;
      
    }
  }
}