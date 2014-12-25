function [ time_cost, bike_locations ] = autonomous_model_cost(map_size, bike_locations,start_coordinate, end_coordinate) 
%autonomous_model_cost finds the cost to travel with an autobike
%cost = time to wait for bike arrival + time to travel distance

human_bike_speed = 15;
autonomous_bike_speed = 3; %(km/hour);
grid_size = 100/1000 ; %in km *(100 meters /(1000 m/km))


bike_movements = [-1 0; % go up
         0 -1;   % go left
         1 0; % go down
         0 1];% go right
     
%heuristic used for A* is manhattan because bike travels on city block
heuristic = generate_manhattan_huristic (map_size, end_coordinate);

%find the closest avaliable bike
closest_bike_location = find_closest_object(bike_locations, bike_movements, start_coordinate,heuristic);

%calculate the time for bike to arrive
blocks_traveled_autonomous = pdist2(closest_bike_location, start_coordinate, 'cityblock');
autonomous_time = blocks_traveled_autonomous* grid_size /autonomous_bike_speed; 

%caculcate the time for biking 
blocks_biked = pdist2(start_coordinate, end_coordinate, 'cityblock');
human_bike_time = blocks_biked * grid_size /human_bike_speed;

%convert minutes
time_cost = (autonomous_time + human_bike_time)* 60; 

%remove the closest bike
bike_locations (closest_bike_location(1),closest_bike_location(2))= bike_locations (closest_bike_location(1),closest_bike_location(2)) -1;
%put the bike in its new location at end coordinate
bike_locations (end_coordinate(1),end_coordinate(2))= bike_locations (end_coordinate(1),end_coordinate(2)) + 1;


end