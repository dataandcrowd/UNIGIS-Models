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
	//float prey_max_energy <- 500.0;
	//float prey_max_transfer <- 50.0;
	//float prey_energy_consum <- 20.0;
	
	
	
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


species lions skills: [moving]{
	list<zebras> my_zebras;  
	
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
 
 aspect energy {
    draw circle(2);
    draw string(energy with_precision 0) size: 2 color: # black;
  }
  
  
  reflex age{
  	age<-age+1;
  }
  
  // lion interaction with zebra agents
  reflex eatZebras {
    my_zebras <- zebras overlapping (self + circle(5));
    ask my_zebras {
      do die;
    }
  }
  
}

//species zebras skills: [moving]{
species zebras {
	int age <- 0;
	float max_energy <- 500.0;
	float max_transfer <- 50.0;
	float energy_consum <- 10.0;
	
	
	vegetation_cell my_cell <- one_of (vegetation_cell);
	float energy <- rnd(max_energy)  update: energy - energy_consum max: max_energy;

init { 
		location <- my_cell.location;
	}

  reflex get_older {
    age <- age + 1;
    if age > 15 {
      do die_of_age;
    }
  }
  
  // zebra behaviour: random movement
  //reflex moveAround {
  //  do wander amplitude: 90.0 speed: 200.0 ;
  //}
  
  reflex basic_move {
		my_cell <- one_of(my_cell.neighbors2);
		location <- my_cell.location;
	}
  
  
  reflex eat when: my_cell.food > 0 { 
		float energy_transfer <- min([max_transfer, my_cell.food]);
		my_cell.food <- my_cell.food - energy_transfer;
		energy <- energy + energy_transfer;
	}
  
  action die_of_age {
    write "I am going to die!";
    do die;
  }
  
  aspect default {
    draw square (2) color: #black;
  }
}


grid vegetation_cell width: 50 height: 50 neighbors: 4 {
	float max_food <- 256.0;
	float food_prod <- 2.0;
	float food <- rnd(256.0) max: max_food update: food + food_prod;
	rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food))) update: rgb(int(255 * (1 - food)), 255, int(255 *(1 - food)));
	list<vegetation_cell> neighbors2  <- (self neighbors_at 2); 
}



experiment mySimulation type: gui {
	
  output    {
 
    display savannah_default type: opengl {
      grid vegetation_cell border: #black;
      species lions aspect:default;
      species zebras aspect:default;
      
    }
    
 //   display savannah_labelled_energy type: opengl {
 //     species lions aspect: energy;
 //     species zebras aspect: default;
 //   }
    
    
    
  }
}