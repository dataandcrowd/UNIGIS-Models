/**
* Name: NewModel
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model EXEdenGrowth

/* Insert your model definition here */


global {
	int number_of_trees <- 2;

	init {
		create trees number: number_of_trees;
		ask trees { 
			ask forest {
				is_seedling <- true;
            	do germinate;
			}
		}
	}
	
	reflex forest_expansion {
    ask forest {do distribute;}
    ask forest {do germinate;}
    ask forest {do grow;}
  }

reflex stop_simulation when: cycle = 400 {
    do pause ;
    } 
	
	
	
    }

species trees {
	aspect base {
		draw circle(1) color: #green;
	}
	
}

    
	
grid forest width:100 height:100 {

    bool is_tree <- false;
    bool is_seedling <- false;
    int treeAge <- -1;
    int maxAge; 

    action distribute  {    
        if is_tree = true {
            ask neighbors {
                if is_tree = false {
                    is_seedling <- true;
                }
            }
        }   
    
    }

action germinate {
        if is_seedling = true and 80 > rnd (100){
            is_tree <- true;
            treeAge <- 0;
            maxAge <- rnd(80,120);
            color <- rgb([0,treeAge * 2,0]);
            is_seedling <- false;
        }
    }   
    
    
  action grow  {
        if is_tree = true and treeAge < maxAge {
            treeAge <- treeAge + 1;
            color <- rgb([0,treeAge * 2,0]);
        }
        
        if is_tree = true and treeAge >= maxAge {
            is_tree <- false;
            color <- #white;
            treeAge <- -1;
        }   
    }
}


experiment forestSim type: gui {
	
  output    {
 
    display TheForest type: opengl {
      grid forest border: #black;
      species trees aspect: base;
    }}}
