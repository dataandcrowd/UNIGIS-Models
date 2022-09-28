/**
* Name: Assignment2
* Based on the internal empty template. 
* Author: Hyesop Shin
* Tags: 
*/


model ExCellularAutomata

global {
	//File for the ascii grid
	file dem_file <- file("../includes/dem_cambridge.tif");
	
	//we use the dem file to initialize the world environment
	geometry shape <- envelope(dem_file);
	
	// Undone task: I want to find the maximum value of the DEM file.
	float highestcell <- cell max_of (each.grid_value);	
	list<cell> newcell <- cell where (each.grid_value=highestcell) ;
	float lowestcell <- cell min_of (each.grid_value);	
 
	
	
	
	init {	
		//ask cell {
		//	float r;
		//	float g;
		//	float b;
		//	if (grid_value < 20) {
		//		r <- 76 + (26 * (grid_value - 7) / 13);
		//		g <- 153 - (51 * (grid_value - 7) / 13);
		//		b <- 0.0;
		//	} else {
		//		r <- 102 + (122 * (grid_value - 20) / 19);
		//		g <- 51 + (173 * (grid_value - 20) / 19);
		//		b <- 224 * (grid_value - 20) / 19;
		//	}
		//	self.color <- rgb(r, g, b);
		//}
			
		write "The highest altitude is: " + highestcell;	
		write "The lowest altitude is " + lowestcell;
		
		
		ask one_of (newcell){
				self.color <- rgb(0,250,0);
				water <- 1000;
					}
		}
		

reflex lowest_dem_water {
	float lowest_dem_with_water <- cell where (each.water > 0) min_of(each.grid_value);
	write lowest_dem_with_water;
	
}
		
reflex stop_simulation when: (time = 1000) {
	
    do pause ;
    }

}




grid cell file: dem_file {
  int water;
		
  // diffuse water
  reflex diffusion {
    if water > 150.0 {
      ask neighbors {
      	if (myself.grid_value >= grid_value){
        water <- water + 50;
        myself.water <- myself.water - 25;
      }
    }}
    
    do update_colour;
  } 
  // show grid values in shades of blue
  action update_colour {
    color <- rgb([20,20,int(water)]);    
  
  
  }
}

// Define an experiment that visualises the CA 
experiment Runoff_Cambridge type: gui {
  output {
    display myMap  {
      grid cell border:#grey;
    }
    
    display  chart {
  // plot amount of cells with more water than 20 units 
  chart "Water Cells with water" type:series {
    data "water cells" value: cell count (each.water > 0);
    
  }
}

display  Lowest_DEM {
  // plot the total volume of water in the study area  
    chart "Lowest DEM" type:series {
    //data "Water volume" value: log(sum(cell collect each.water)) color: #blue;
    data "Lowest DEM" value: cell where (each.water > 0) min_of(each.grid_value) color:#green;
  }
}
  }
}