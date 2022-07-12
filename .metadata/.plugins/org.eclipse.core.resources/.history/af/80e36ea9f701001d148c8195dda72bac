/**
* Name: Assignment2
* Based on the internal empty template. 
* Author: Hyesop Shin
* Tags: 
*/


model ExCellularAutomata

global {
  myCA centralcell ;
  init {
    centralcell <- myCA[5,5];
    ask centralcell {
    	color <- rgb(0,150,0);
    	grid_value <- 500.0;
    } 
  }
  
  reflex stop_simulation when: (time = 25) {
    do pause ;
    }
}

grid myCA width: 10 height:10 neighbors:8 {
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
      grid myCA border:#grey;
    }
    
    display  chart {
  // plot amount of cells with more water than 20 units 
  chart "myChart" type:series {
    data "water cells" value: myCA count (each.grid_value > 20);
  }
}

display  amount_of_water {
  // plot the total volume of water in the study area  
  chart "Amount of water" type:series {
    data "water volume" value: sum(myCA collect each.grid_value);
  }
}
  }
}