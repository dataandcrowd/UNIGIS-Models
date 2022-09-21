/**
* Name: NewModel
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model EXEdenGrowth2

/* Insert your model definition here */


global {


	init {
		forest treeA <- one_of(forest);
		forest treeB <- one_of(forest);
		
		
			ask treeA {
				is_seedling <- true;
            	do germinate;
            	is_treeA <- true;
			}
			
			ask treeB {
				is_seedling <- true;
            	do germinate;
            	is_treeB <- true;
			}
			
		}

	
	reflex forest_expansion {
    ask forest {do distribute;}
    ask forest {do germinate;}
    ask forest {do grow;}
    
    unknown var00 <- forest where (each.is_treeA = true);
    write length(var00);
  }

reflex stop_simulation when: cycle = 400 {
    do pause ;
    } 
    }


	
grid forest width:100 height:100 {
    bool is_tree <- false;
    bool is_seedling <- false;
    bool is_treeA <- false;
    bool is_treeB <- false;
    
    int treeAge <- -1;
    int maxAge;
    int competitionAge;
    
     

    action distribute  {    
        if is_tree = true and is_treeA = true {
            ask neighbors {
                if is_tree = false {
                    is_seedling <- true;
                    is_treeA <- true;               
            }}}
         if is_tree = true and is_treeB = true {
            ask neighbors {
                if is_tree = false {
                    is_seedling <- true;
                    is_treeB <- true;               
            }}}     
    
    }

action germinate {
        if is_seedling = true and 75 > rnd (100){
            is_tree <- true;
            treeAge <- 0;
            maxAge <- rnd(80,120);
            is_seedling <- false;
            color <- rgb([0,treeAge * 2,0]);
            is_seedling <- false;
        }
    }   
    
    
  action grow  {
        if is_tree = true and treeAge < maxAge {
            treeAge <- treeAge + 1;
            if is_treeA = true {
            	color <- rgb([100,treeAge * 2,100]);
            }
            else if is_treeB = true {
            	color <- rgb([0,treeAge * 2,0]);
            }}
        
        
        if is_tree = true and treeAge >= maxAge {
            is_tree <- false;
            color <- #white;
            treeAge <- -1;
        }   
    }
    
    
   action competition {
   	// here I can put a competition tab states the war between treeA and treeB
   if is_treeA = true and is_treeB = true {
   	competitionAge <- treeAge;
   	  if (treeAge - competitionAge >= 5){
   	  	if 70 >= rnd (100) {
   	  	is_treeB <- false;
   	  }
   	  else {
   	  	is_treeA <- false;
   	  }
   } }
   } 
    
    
}


experiment forestSim type: gui {
	
  output    {
 
    display The_Forest type: opengl {
      grid forest border: #black;
      }
   display Tree_Types {
    chart "Tree Types" type: series {
            data "Tree A" value: length(forest where (each.is_treeA = true)) color: #red;
            data "Tree B" value: length(forest where (each.is_treeB = true)) color: #blue;
            }
    }
    }}
