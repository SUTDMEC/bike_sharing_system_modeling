function [ time_cost, bikes_at_station_location, empty_slots_at_station_location ] = traditional_model_cost(map_size, bikes_at_station_location, empty_slots_at_station_location,start_coordinate, end_coordinate)
%traditional model cost finds the cost to travel in a traditional bike
%sharing model
%cost = time to walk to station with empty bike + time to bike to an empty
%station near the end point + time to talk from station to end location

human_bike_speed = 15;
human_walk_speed = 3; %(km/hour);
grid_size = 100/1000 ; %in km *(100 meters /(1000 m/km))

walking_movements = [-1 0; % go up
         0 -1;   % go left
         1 0; % go down
         0 1;% go right
         %1 1;
         %-1 1
        % -1 -1
%         1 -1 
                ];

%generate heuristics for trip
heuristic1 = generate_euclidian_huristic(map_size, start_coordinate);

heuristic2 = generate_euclidian_huristic (map_size, end_coordinate);

%find the closest station with avaliable bikes
start_closest_station_location = find_closest_object(bikes_at_station_location, walking_movements, start_coordinate,heuristic1);

%find the closest station with an open slot
end_closest_station_location = find_closest_object(empty_slots_at_station_location, walking_movements, end_coordinate,heuristic2);

%%%%%%%%%%%%%%%%%%%%%%Walking time %%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate distance from start to closest location by walking
distance_traveled_walking = pdist2(start_closest_station_location, start_coordinate);

%add the disttane from end station to end location
distance_traveled_walking = distance_traveled_walking + pdist2(end_closest_station_location, end_coordinate);

walking_time = distance_traveled_walking * grid_size /human_walk_speed; 


%%%%%%%%%%%%%%%%%%%%%Biking time%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate distance and time from start to closest empty station by bike
blocks_biked = pdist2(start_coordinate, end_coordinate, 'cityblock');
%concert time
human_bike_time = blocks_biked * grid_size /human_bike_speed;

%convert minutes
time_cost = (walking_time + human_bike_time)* 60; 


%%%%%%%%%%%%%%Update bike locations%%%%%%%%%%5
%move the bike from start station to end station

bikes_at_station_location(start_closest_station_location(1), start_closest_station_location(2) )=bikes_at_station_location(start_closest_station_location(1), start_closest_station_location(2) ) -1;
bikes_at_station_location(end_closest_station_location(1), end_closest_station_location(2) )= bikes_at_station_location(end_closest_station_location(1), end_closest_station_location(2) ) +1;

empty_slots_at_station_location(start_closest_station_location(1), start_closest_station_location(2)) = empty_slots_at_station_location(start_closest_station_location(1), start_closest_station_location(2)) +1;
empty_slots_at_station_location(end_closest_station_location(1), end_closest_station_location(2)) = empty_slots_at_station_location(end_closest_station_location(1), end_closest_station_location(2) )-1;

end

