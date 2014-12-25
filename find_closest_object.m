function [object_cordinate] = find_closest_object(grid_of_objects, possible_movements, present_location, heuristic) 
%Given a matrix of objects (represented by a nonzero) return the closest given
%present_location coordiante and possible movements
%implementation uses a A star styled search for the closest non zero location
%basically a lazy search for a non zero value which searchs in the
%direction indicated by the heuristic



%store if the present location is checked to prevent rechecking
checked = zeros(size (grid_of_objects));
checked(present_location) = 1;

movement_cost = 0;

%flag for end of search
found = false; 
%flag is for if no object is found
resign = false; 

%heuristic cost used in a star
heuristic_cost = heuristic(present_location(1),present_location(2) ) + movement_cost;

%stack of locations left to search
searched_stack = [heuristic_cost, movement_cost, present_location];

%stack of objects  found= [movement cost, y location, x location]
object_found = [];


%If a bike is found at present location
if (0 < grid_of_objects(present_location(1), present_location(2)))
   found = true;
   object_found= [0, present_location];
end


count = 0;
    while  not(found) && not(resign)
        
        %check if stack is empty ie. no more left to check
        if (~size(searched_stack,1))
            resign = true;
        
        else
            %sort so the least total cost is on top
            searched_stack = sortrows(searched_stack);

            %pop the top of search stack
            next_travel = searched_stack (1, :);
            searched_stack (1, :) = [];

            %get new cost and coordinates
            cost = next_travel (2);
            y = next_travel (3);
            x = next_travel (4);
            %since we moved 1, add to cost
            cost = cost +1;
            %Make checked non zero to indicated we have traved to location 
            checked(y,x) = count;
            count = count + 1;
            
            %if an object is found
            if (0 < grid_of_objects(y,x))
               found = true;
               object_found = [cost+ heuristic(y,x), y, x];    
            %search all possible movements
            else
                for iii= 1: size (possible_movements,1)
                    y2 = y + possible_movements(iii,1);
                    x2 = x + possible_movements(iii,2);

                    if (y2> 0 && y2 < size(grid_of_objects,1)+1 && x2>0 && x2 < size(grid_of_objects,2)+1)
                        if (checked(y2, x2) == 0 && grid_of_objects(y2,x2)> -1)
                            total_cost = cost + heuristic(y2,x2);
                            searched_stack = [searched_stack ; total_cost, cost, y2, x2];
                            checked(y2,x2) = count;

                             %if bike is found
                             if (grid_of_objects(y2,x2)> 0)
                                 object_found = [cost, y2, x2];
                                 found = true;
                             end
                        end
                    end
                end
            end
        end
    end
    
closest_object_found = sortrows(object_found);   

%in case no object is found, return nothing
object_find_check = size (closest_object_found);
if(object_find_check)
    object_cordinate = closest_object_found(1,2:3);
end

end

