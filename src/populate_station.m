function [ map ] = populate_station(map, x_spacing, y_spacing ) 
%Populate station places a 1 to represent a station at spacing
%Note the first and last columns are left blank to represent
%a minimum of 1 block of talking to a station.

x_size = size(map,1);
y_size = size (map,2);

for iii = 2:x_spacing+1:x_size-1
    for jjj = 2:y_spacing+1:y_size-1
        map(iii,jjj) = 1;
    end
end

end

