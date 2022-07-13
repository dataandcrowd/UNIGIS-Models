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
	
 
	//list<int> waterfall <- [(grid_x of newcell[1]), (grid_y of newcell[1])];
	
	
	
	init {	
		ask cell {
			float r;
			float g;
			float b;
			if (grid_value < 20) {
				r <- 76 + (26 * (grid_value - 7) / 13);
				g <- 153 - (51 * (grid_value - 7) / 13);
				b <- 0.0;
			} else {
				r <- 102 + (122 * (grid_value - 20) / 19);
				g <- 51 + (173 * (grid_value - 20) / 19);
				b <- 224 * (grid_value - 20) / 19;
			}
			self.color <- rgb(r, g, b);
		}
			
		write "The agent with the maximum value of val is: " + highestcell;	
		//write (grid_x of newcell[1]); write (grid_y of newcell[1]) ;
		//write waterfall;
		
		ask one_of (newcell){
self.color <- rgb(0,150,0);
}

	}
}



grid cell file: dem_file {
  // diffuse water
  reflex diffusion {
    if grid_value > 150.0 {
      ask neighbors {
        grid_value <- grid_value + 5;
        myself.grid_value <- myself.grid_value - 5;
      }
    }
    
    do update_colour;
  } 
  // show grid values in shades of blue
  action update_colour {
    color <- rgb([0,0,int(grid_value)]);    
  
  
  }
}

// Define an experiment that visualises the CA 
experiment simulation type: gui {
  output {
    display myMap  {
      grid cell border:#grey;
    }
    
    display  chart {
  // plot amount of cells with more water than 20 units 
  chart "myChart" type:series {
    data "water cells" value: cell count (each.grid_value > 20);
  }
}

display  amount_of_water {
  // plot the total volume of water in the study area  
  chart "Amount of water" type:series {
    data "water volume" value: sum(cell collect each.grid_value);
  }
}
  }
}