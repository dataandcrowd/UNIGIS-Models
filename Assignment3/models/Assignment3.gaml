/**
* Name: evacuationgoto
* Author: Patrick Taillandier
* Description: A 3D model with walls and exit, and people agents trying to evacuate 
* 	from the area to a exit location, avoiding the walls with a discretized space by a grid
* Tags: 3d, shapefile, gis, agent_movement, skill, grid
*/

model evacuationgoto

global {
	//Shapefile of the walls
	file wall_shapefile <- shape_file("../includes/walls.shp");
	//Shapefile of the exit
	file exit_shapefile <- shape_file("../includes/exit.shp");
	//DImension of the grid agent
	int nb_cols <- 50;
	int nb_rows <- 50;
	
	//Shape of the world initialized as the bounding box around the walls
	geometry shape <- envelope(wall_shapefile);
	
	//------------------------------------------------------------//
	//perception distance
	float perception_distance <- 15.0 parameter: true;
	
	//precision used for the masked_by operator (default value: 120): the higher the most accurate the perception will be, but it will require more computation
	float precision <- 30.0 parameter: true;
	//------------------------------------------------------------//
	
	float  mean_distance_to_goal;
	
	int nb_people -> {length(people)};
	
	
	
	init {
		//Creation of the wall and initialization of the cell is_wall attribute
		create wall from: wall_shapefile {
			ask cell overlapping self {
				is_wall <- true;
			}
		}
		//Creation of the exit and initialization of the cell is_exit attribute
		create exit from: exit_shapefile {
			ask (cell overlapping self) where not each.is_wall{
				is_exit <- true;
			}
		}
		//Creation of the people agent
		create people number: 50{
			//People agent are placed randomly among cells which aren't wall
			location <- one_of(cell where not each.is_wall).location;
			//Target of the people agent is one of the possible exits
			target <- one_of(cell where each.is_exit).location;
		 }  	
	}
	
	reflex stop_simulation when:nb_people = 0  {
    do pause ;
    } 
     
	
	
	
}
//Grid species to discretize space
grid cell width: nb_cols height: nb_rows neighbors: 8 {
	bool is_wall <- false;
	bool is_exit <- false;
	rgb color <- #white;	
}
//Species exit which represent the exit
species exit {
	aspect default {
		draw shape color: #blue;
	}
}
//Species which represent the wall
species wall {
	aspect default {
		draw shape color: #sandybrown depth: 10;
	}
}
//Species which represent the people moving from their location to an exit using the skill moving
species people skills: [moving]{
	//zone of perception
	geometry perceived_area;
	
	//Evacuation point
	point target;
	rgb color <- rnd_color(255);
	
	
		
	//Reflex to move the agent 
	reflex move {
		//Make the agent move only on cell without walls
		do goto target: target speed: 1.0 on: (cell where not each.is_wall) recompute_path: false;
		
		//If the agent is close enough to the exit, it dies
		if (self distance_to target) < 2.0 {
			do die;
		}
	}
	
	reflex update_perception {
		//the agent perceived a cone (with an amplitude of 60°) at a distance of  perception_distance (the intersection with the world shape is just to limit the perception to the world)
		perceived_area <- (cone(heading-45,heading+45) intersection world.shape) intersection circle(perception_distance); 
		
		//if the perceived area is not nil, we use the masked_by operator to compute the visible area from the perceived area according to the obstacles
		if (perceived_area != nil) {
			perceived_area <- perceived_area masked_by (wall,precision);
		}
	}
	
	aspect default {
		draw pyramid(2.5) color: color;
		draw sphere(1) at: {location.x,location.y,2} color: color;
	}
	
	aspect perception {
		if (perceived_area != nil) {
			draw perceived_area color: #honeydew;
			draw circle(1) at: target color: #mediumvioletred;
		}
	}
	
	
	
	reflex update_mean_distance {
		if (self distance_to target) >= 2.0 {
		mean_distance_to_goal <- mean(self distance_to target);
			
		}
	}
	
	
}
experiment evacuation_with_vision type: gui {
	float minimum_cycle_duration <- 0.04; 
	output {
		display "Maps with Agent's vision" type: opengl{
			image "../images/floor.jpg";
			species wall refresh: false;
			species exit refresh: false;
			species people;
			species people aspect: perception transparency: 0.8;
		}
		display cchart {
		chart "Distance" type: series {
            data "Mean Distance" value: mean_distance_to_goal color: #green;
            data "no of people" value: nb_people color: #blue;
            }
	}
}}
