/**
* Name: DynamicSpecies
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model DynamicSpecies

/* Insert your model definition here */

global{
    float max_range <- 5.0;
    int number_of_agents <- 5;
    init {
    create my_species number: number_of_agents;
    }
    
    reflex update {
    ask my_species {
        do wander amplitude: 180.0; 
        ask my_grid at_distance(max_range) {
        if(self overlaps myself) {
            self.color_value <- 2;
        } else if (self.color_value != 2) {
            self.color_value <- 1;
        }
        }
    }
    ask my_grid {
        do update_color;
    }   
    }
}

species my_species skills:[moving] {
    float speed <- 2.0;
    aspect default {
    draw circle(1) color: #blue;
    }
}

grid my_grid width:100 height:100 {
    int color_value <- 0;
    action update_color {
    if (color_value = 0) {
        color <- #green;
    } else if (color_value = 1) {
        color <- #yellow;
    } else if (color_value = 2) {
        color <- #red;
    }
    color_value <- 0;
    }
}

experiment DistributionGUI type: gui {
    output {
        display MyDisplay type: opengl {
            grid my_grid border: #black;
            species my_species aspect: default; 
        }
    }
}