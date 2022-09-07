/**
* Name: NewModel
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model EXEdenGrowth

/* Insert your model definition here */


global {
	
	
	int treeA <- 1;  // The number of treeA
	int treeB <- 2;  // The number of treeB
	
	// Environment
	geometry shape <- rectangle(100, 100);
	
	
	
	init {
				
        ask forest[20,50] {
        	
       
        ask forest {
        	hsiA <- 66 + location.x / 3; 
        	hsiB <- 99 - location.x / 3;
        	}
        
               
    }
    }
    }
	
grid forest width:100 height:100 {

    bool is_tree <- false;
    bool is_seedling <- false;
    int treeAge <- -1;
    int maxAge; 
	}


experiment forestSim type: gui {
	
  output    {
 
    display xx type: opengl {
      grid forest border: #black;
    }}}
