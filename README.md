A 2D QML application with a C++ backend that simulates a serial production line under different service policies and provides the plots of several performance metrics in real-time (throughput, number of products waiting in the system, worker utilization). 

The simulation is a discrete event simulation model of a Markovian queue system with Exponentially distributed interevent times. Users can submit the arrival and service rate parameters and select a service policy to decide on how to assign the worker to tasks. 

For example, using the randomized policy that assigns a state for the worker randomly, the throughput can be very low (observed to be around 0.77 below) and the number of waiting jobs at the slow station can explode.  

![](https://github.com/ayseaslan/QML_production_line_simulation/blob/master/video_random_policy.gif)  

However, employing a smarter policy that prioritizes the stations based on the number of waiting jobs and the speed of service, as illustrated below, can balance the number of waiting jobs at the stations and achieve a higher throughput. 

![](https://github.com/ayseaslan/QML_production_line_simulation/blob/master/video_cmu_priority_policy.gif)  






