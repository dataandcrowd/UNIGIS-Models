/***
* Name: AntsSimple
* Author: WALLENTIN
* Description: 
* Tags: Tag1, Tag2, TagN
***/



model ants

global {
	int t <- 1;
	//Evaporation value per cycle of the pheromons
	float evaporation_per_cycle <- 5.0 min: 0.5 max: 5.0 ;
	//Diffusion rate of the pheromons
	float diffusion_rate const: true <- 1.0 min: 0.0 max: 1.0 ;
	//Size of the grid
	int gridsize const: true <- 75; 
	//Number of ants to create
	//VH increasing the amount of ants
	int ants_number  <- 1000 min: 1 max: 1000 parameter: 'Number of Ants:';
	//Variable to keep information about the food remaining
	int food_remaining update: list ( ant_grid ) count ( each . food > 0) <- 10;
	//Center of the grid that will be considered as the nest of ants
	point center const: true <- { round ( gridsize / 2 ) , round ( gridsize / 2 ) };
	matrix<int> types <- matrix<int> (pgm_file ( '../images/environment75x75_scarce.pgm' )); 
	
	geometry shape <- square(gridsize);
	
	init {
		//Creation of the ants placed in the nest
		create ant number: ants_number with: [ location :: center ];
	} 
	
	//Different actions triggered by an user interaction
	action press 
	{
		point loc <- #user_location;
		list<ant> selected_agents <- ant overlapping (circle(10) at_location #user_location);
		write("press " + loc.x + " " + loc.y + " "+selected_agents);
	}
	action release 
	{
		write("release");
	}
	action click  
	{
		write("click");
	}
	action click2   
	{
		write("click2");
	}
	//Reflex to diffuse the pheromons among the grid
	reflex diffuse {
      diffuse var:road on:ant_grid proportion: diffusion_rate radius:2 propagation: gradient;
   }


reflex save_result {
	// int(self): iteration
	// evaporation_per_cycle: evaporation_per_cycle
	// cycle = cycle
	// food_remaining = food_remaining 
          save ("simu:" +  int(self) + ";evaporation_per_cycle:" + evaporation_per_cycle + 
          ";cycle:"+ cycle + ";food_remaining:" + food_remaining)
               to: "../results/results.txt" type: "text" rewrite: false;
               //to: "../results/results" + evaporation_per_cycle + ".txt" type: "text" rewrite: (cycle = 0) ? true: false;
    }
    	
 
}


 
//Grid used to discretize space to place food in cells
grid ant_grid width: gridsize height: gridsize neighbors: 8 {
	bool isNestLocation  <- ( self distance_to center ) < 4;
	bool isFoodLocation <-  types[grid_x , grid_y] = 2;       
	list<ant_grid> neighbours <- self neighbors_at 1;  
	float road <- 0.0 max:240.0 update: (road<=evaporation_per_cycle) ? 0.0 : road-evaporation_per_cycle;
	rgb color <- rgb([ self.road > 15 ? 255 : ( isNestLocation ? 125 : 0 ) , self.road * 30 , self.road > 15 ? 255 : food * 50 ]) update: rgb([ self.road > 15 ? 255 : ( isNestLocation ? 125 : 0 ) ,self.road * 30 , self.road > 15 ? 255 : food * 50 ]); 
	int food <- isFoodLocation ? 5 : 0; 
	int nest const: true <- int(300 - ( self distance_to center ));
	
}

//Species ant that will move
species ant skills: [ moving ] {     
	rgb color <- #red;
	ant_grid place function: ant_grid ( location );
	bool hasFood <- false; 
	bool hasRoad <- false update: place . road > 0.05;
	
	//Reflex to diffuse pheromon on the cell once the agent has food
	reflex diffuse_road when:hasFood=true{
      ant_grid(location).road <- ant_grid(location).road + 100.0;
   }
	//Reflex to wander while the ant has no food
	reflex wandering when: ( ! hasFood ) and ( ! hasRoad ) and ( place . food = 0) {
		do wander amplitude: 120.0 speed: 1.0;
	}
	//Reflex to search  when the agent has no food nor pheromon road close
	reflex looking when: ( ! hasFood ) and ( hasRoad ) and ( place . food = 0 ) { 
		list<ant_grid> list_places <- place . neighbours;
		ant_grid goal <- list_places first_with ( each . food > 0 );
		if goal != nil {
			location <- goal.location ; 
		} else {
			int min_nest <- ( list_places min_of ( each . nest ) );
			list_places <- list_places sort ( ( each . nest = min_nest ) ? each . road : 0.0 ) ;
			location <- point ( last ( list_places ) ) ;
		}
	}
	//Reflex to take 
	reflex taking when: ( ! hasFood ) and ( place . food > 0 ) { 
		hasFood <- true ;
		place . food <- place . food - 1 ;
	}
	//Reflex to make the ant return to the nest once it has food
	reflex homing when: ( hasFood ) and ( ! place . isNestLocation ) {
		do goto target:center  speed:1.0;
	}
	//Reflex to drop food once the ant arrived at the nest
	reflex dropping when: ( hasFood ) and ( place . isNestLocation ) {
		hasFood <- false ;
		heading <- heading - 180 ;
	}
	aspect default {
		draw circle(2.0) color: color;
	}
	
}
//Experiment simple to display ant and have user interaction
experiment Simple type:gui {
	parameter 'Evaporation:' var: evaporation_per_cycle;
	parameter 'Diffusion Rate:' var: diffusion_rate;
	output { 
		display Ants refresh: every(2#cycles) { 
			grid ant_grid;
			species ant aspect: default;
			graphics 'displayText' {
				draw string ( food_remaining ) size: 24.0 at: { 20 , 20 } color: rgb ( 'white' );
			}
			//Event triggering the action passed in parameter
			event mouse_down action:press;
			event mouse_up action:release;
		}  
		display Ants_2 refresh: every(2#cycles) { 
			grid ant_grid;
			graphics 'displayText' {
				draw string ( food_remaining ) size: 24.0 at: { 20 , 20 } color: rgb ( 'white' );
			}
			event mouse_down action:press;
			event mouse_up action:click2;
		}  
	}
}


// This experiment simply explores two parameters with an exhaustive strategy, 
// repeating each simulation ten times

/*Failed Experiment */
//experiment Repeated type: batch repeat: 2 keep_seed: true until: time > 500  {
//        int cpt <- 0;
//       parameter 'Evaporation' var: evaporation_per_cycle among: [ 0.5 , 1.0 , 2.0 , 5.0];
//        parameter 'Diffusion rate' var: diffusion_rate min: 0.1 max: 1.0 step:0.3;
       
//        reflex save_result {
//          save [cycle, food_remaining] 
//	   		to: "../results/sim_stat" + cpt + ".csv" type: "csv" rewrite:true header:true;
//	   		cpt <- cpt + 1;
//	}
        // https://gama-platform.org/wiki/next/BatchExperiments
//}


experiment Repeated type: batch repeat: 10 keep_seed: true until: food_remaining <= 0.0 {
        parameter 'Evaporation' var: evaporation_per_cycle min: 0.5 max: 5.0 step: 0.5;
}


