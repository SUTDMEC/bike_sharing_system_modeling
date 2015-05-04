Autonomous vs Traditional Bike Sharing Model Scability Simulation
==============================

#Summary
This monte carlo simulation models two distinct bike sharing models. One model is with a autonomous driving bike which can automatically go to drivers up request, rebalance based on demand, and be "free floating" in the system.  The other model is a traditional station based bike sharing model where there are stations with bikes and open slots.  Finally the trip time to just walk to the location is calculated both if traveled by streets (manhattan distance) and the euclidien distance

This is a very fast and crude model where realism is balanced with simplicity both in terms of implementation and comprehension of the model. Assumptions are described through out the model and data is taken from "The Bike Share-Planning Guide" written by the Institude for Transportation and developy policy (https://www.itdp.org/the-bike-share-planning-guide-2/)

##Implentation in short:
- Multiheuristic A* search algorithm used to find shortest path
- Random seed of bike stations and floating bikes based on model assumptions
- autonomous model trip time = wait for bike to arrive + bike to destination  
- traditional model trip time = talk to bike station + bike to station with a open docking slot + walk to destination
- walk trip time = walking the Euclidien distance to the end location from start location

Autonomous Model:
![alt text](https://github.com/mrandrewandrade/scratch/raw/master/images/autobike_results/auto.png "Autonomous Model")

Traditional Model:
![alt text](https://github.com/mrandrewandrade/scratch/raw/master/images/autobike_results/costmodel.jpg "Traditional Station Model")

Results Summary:
![alt text](https://github.com/mrandrewandrade/scratch/raw/master/images/autobike_results/station.png "Results")


Main assumptions:   

1) Demand for a trip are uniform through out the system (no rebalancing of the fleet since there are not "hot spots" where trips begin or end)  

2) As the coverage size increases, the station spacing increases.  This is because emperical data shows that demand decreases as coverage area increases (population density decreses as coverage area increses generally  

3) Fixed number of bikes per station, fixed number of docking slots slots per station (based on number of bikes)  

4) Total number of bikes in both the autonomous and traditional station system are equal (maintanace and rebalancing costs for both systems are about equal)  
