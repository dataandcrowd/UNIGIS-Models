library(tidyverse)
ba_raw <- read_csv("be.csv")

ba_raw %>% 
  rename(sim_iteration = self.name, 
         my_var = self.my_var) %>% 
  mutate(sim = row_number())-> ba

ba %>% 
  ggplot() +
  geom_line(aes(sim, my_var, group = 1)) -> ba_plot

ba_plot

ggsave("baplot.png", ba_plot, width = 4, height = 3.5)
