/**
* Name: Lions
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model Lions

/* Insert your model definition here */

global  {
  init {
    create lions number:5 {
      age <- int(rnd(5));
      energy <- 100.0 ;
    }
  }
}


species lions {
  int age;
  float energy;
  
  aspect default {
    draw circle (2) color: #orange;
  } 
}


species zebras {
  int age <- 0;

  reflex get_older {
    age <- age + 1;
    if age > 15 {
      do die_of_age;
    }
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
    }
  }
}