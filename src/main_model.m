%Written by Andrew Andrade 
%Description: This monte carlo simulation models two distinct bike sharing
%models.  One model is with a autonomous driving bike which can
%automatically go to drivers up request, rebalance based on demand, and be
%"free floating" in the system.  The other model is a traditional station
%based bike sharing model where there are stations with bikes and open
%slots.  Finally the trip time to just walk to the location is calculated
%both if traveled by streets (manhattan distance) and the euclidien
%distance.  This is a very fast a crude model where realism is balanced
%with simplicity both in terms of implementation and comprehension.
%Assumptions are described through out the model and data is taken from
%"The Bike Share-Planning Guide" written by the Institude for Transportation
%and developy policy https://www.itdp.org/the-bike-share-planning-guide-2/

clc; clear;
iii = 1;
%run simulation for different station spacing and coverage area
for  station_spacing = 1:2:9
    %assumption: as the coverage size increases, the station spacing
    %increases.  This is because emperical data shows that demand
    %decreases as coverage area increases (since population density decreses).
    size = station_spacing *10; 
    map_size = [size,size];
    station_map = zeros(map_size);

    %Set station locations with bikes and empty slots
    station_map = populate_station(station_map, station_spacing,station_spacing);
    bikes_per_station = 10;
    bikes_at_station = station_map .* bikes_per_station;
    empty_slots_per_bike = 2;
    empty_slots_at_station = station_map .* bikes_per_station *empty_slots_per_bike;
    total_number_bikes = sum(sum(bikes_at_station));
    bike_per_grid = total_number_bikes / (size*size); 

    %Scatter autonomous bikes accross the same sized map
    %Assumption: the total number of bikes would be about equivilent in
    %both systems.
    %if not enough bikes for every grid
    if (bike_per_grid <1 )
        bike_spacing = 1;
        avaliable_bike_map = zeros(map_size);
        avaliable_bike_map = populate_station(avaliable_bike_map, bike_spacing,bike_spacing);
    else
        avaliable_bike_map = ones(size, size);
        avaliable_bike_map = avaliable_bike_map .* round(bike_per_grid);
    end
    %Coverage area
    total_time_cost (1,iii)  = (size/10) * (size/10);
    %Autonomous model trip time
    total_time_cost (2,iii)  = 0;
    %Station model trip time
    total_time_cost (3,iii) = 0;
    %Walking time (on a city grid)
    total_time_cost (4,iii) = 0;
    %Walking time (on a euclidien distance) aka taking short cuts
    total_time_cost (5,iii) = 0;

    %run a monte carlo simulation given number of trips
    number_trips = 10000;
    for trip_count = 1:number_trips;
        %random start and end location on the map
        %assumption: demand for the start and end of the trip in uniform
        %accoess the grid (homogenous demand)
        start_coordinate = randi([1,map_size(1)],1,2);
        end_coordinate = randi([1,map_size(1)   ],1,2);

        %Calculate the time for the trip
        [autonomous_time_cost, avaliable_bike_map ]= autonomous_model_cost(map_size, avaliable_bike_map,start_coordinate, end_coordinate);
        [traditional_time_cost, bikes_at_station, empty_slots_at_station ] = traditional_model_cost(map_size, bikes_at_station, empty_slots_at_station,start_coordinate, end_coordinate);
        only_walking_time_cost = walking_cost(start_coordinate, end_coordinate);
        only_walking_euclidien_time_cost = walking_cost_euclidien (start_coordinate, end_coordinate);

        %tally the total costs for all the trips
        total_time_cost (2,iii) = total_time_cost(2,iii) + autonomous_time_cost;
        total_time_cost (3,iii) = total_time_cost (3,iii) + traditional_time_cost;    
        total_time_cost (4,iii) = total_time_cost (4,iii) + only_walking_time_cost;    
        total_time_cost (5,iii) = total_time_cost (5,iii) + only_walking_euclidien_time_cost;    

    end
    iii= iii+1;
end

%average the trip time
total_time_cost(2,:)= total_time_cost(2,:)/number_trips;
total_time_cost(3,:)= total_time_cost(3,:)/number_trips;
total_time_cost(4,:)= total_time_cost(4,:)/number_trips;
total_time_cost(5,:)= total_time_cost(5,:)/number_trips;

%plot the results
figure(1);
plot (total_time_cost(1,:), total_time_cost(2,:),'b')
hold;
plot (total_time_cost(1,:), total_time_cost(3,:),'r')
%plot (total_time_cost(1,:), total_time_cost(4,:),'k')
plot (total_time_cost(1,:), total_time_cost(5,:),'-.g')

legend('Autonomous Model','Traditional Station Model', 'Walking Directly');
%legend('Autonomous Model','Traditional Station Model', 'Walking Streets', 'Walking Euclidien');
title('Average Trip Time vs Systam Coverage Area')
xlabel('Bike System Coverage Area (km^2)');
ylabel('Average trip time (minutes)');

figure(2);
semilogx(total_time_cost(1,:), total_time_cost(2,:),'b')
hold;
semilogx (total_time_cost(1,:), total_time_cost(3,:),'r')
%semilogx(total_time_cost(1,:), total_time_cost(4,:),'k')
semilogx (total_time_cost(1,:), total_time_cost(5,:),'-.g')
legend('Autonomous Model','Traditional Station Model', 'Walking Directly');
%legend('Autonomous Model','Traditional Station Model', 'Walking Streets', 'Walking Euclidien');
title('Average Trip Time vs Systam Coverage Area')
xlabel('Bike System Coverage Area (km^2)');
ylabel('Average trip time (minutes)');


