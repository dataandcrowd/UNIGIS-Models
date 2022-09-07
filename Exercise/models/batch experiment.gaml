/**
* Name: batch
* Based on the internal empty template. 
* Author: hyesopshin
* Tags: 
*/


model batchexperiment


global {
  int my_var <- 0;
  reflex add_1 {
    if flip (0.5) {
      my_var <- my_var + 1;
    }
  }
}



experiment Monte_Carlo type: batch repeat: 100 until: cycle = 50 {
  permanent {
    display mean_value background: #white {
      chart "Mean value" type: xy {
        data "my var" value: [0.5 , mean(simulations collect each.my_var)];
      }
    }
  }
  
  permanent{
  display Stochasticity background: #white {
    // histogram
    chart "histogram" type: histogram size: {0.5,0.5} position: {0, 0} {
      data "<21" value: simulations count (each.my_var < 21) color: #green ;
      data "21-23" value: simulations count (each.my_var <= 23 and each.my_var >= 21) color: #green ;
      data "24-26" value: simulations count (each.my_var <= 26 and each.my_var >= 24) color: #green ;
      data "27-29" value: simulations count (each.my_var <= 29 and each.my_var >= 27) color: #green ;
      data ">29" value: simulations count (each.my_var > 29) color: #green ;
    }
    
    // data series
    chart "series" type: series size: {0.5,0.5} position: {0.5, 0} {
      data "my Var" value: simulations collect each.my_var color: #red ;
    }
    
    // xy plot
    chart "xy mean" type: xy size: {0.5,0.5} position: {0, 0.5} {
      data "my var" value: [0.5 , mean(simulations collect each.my_var)] ;
    }
  }
}
  
  reflex save_results {
    ask simulations {
      save [self.name, self.my_var] to: "be.csv" type: "csv" rewrite:false;
    }
  }
}
