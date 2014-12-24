function [ time_cost ] = walking_cost_euclidien(start_coordinate, end_coordinate)
%walking_cost_euclidien finds the time to talk from start to end

human_walk_speed = 3; %(km/hour);
grid_size = 100/1000 ; %in km *(100 meters /(1000 m/km))

%talking distance
distance_traveled_walking = pdist2(start_coordinate, end_coordinate);

%convert distance into a time based on average walking speed
walking_time = distance_traveled_walking * grid_size /human_walk_speed; 

%convert minutes
time_cost = walking_time * 60; 


end