
/* This module is mainly used to manage the agent's obstacle avoidance strategy */

// 【obstacle】 In this case, if the agent does not have any information about the obstacle in its belief base, then the information about the obstacle is added 
//              to the belief base and the obstacle avoidance action is performed.
+obstacle(X,Y): self_location(X0,Y0) & count_location(obstacle,N) & (N == 0) <- 
    +location(obstacle,_,(X0+X),(Y0+Y));
    .time(H,M,S,MS);
    +avoid_obstacle(X0+X, Y0+Y);
	.print("[",H,":",M,":",S,":",MS,"] ","Obstacle found at ",(X0+X),",",(Y0+Y)).

// 【avoid_obstacle】 In this example, we use a random-vertical obstacle avoidance strategy. That is, if an obstacle obstructs the agent's direction of travel, then
//                    a direction perpendicular to the direction of travel will be randomly selected for obstacle avoidance.
+avoid_obstacle : self_location(X0, Y0)<-
    if(location(obstacle,_,(X0+1),(Y0))){
		+avoid_obstacle_e_w;
	}elif(location(obstacle,_,(X0-1),(Y0))){
		+avoid_obstacle_e_w;
	}elif(location(obstacle,_,(X0),(Y0+1))){
		+avoid_obstacle_n_s;
	}elif(location(obstacle,_,(X0),(Y0-1))){
		+avoid_obstacle_n_s;
	}
	.

// 【avoid_obstacle_e_w】 East-West avoidance strategy. Depending on the size of the random number, an obstacle avoidance direction (east/west) is chosen.
+avoid_obstacle_e_w : true <-
    .random(R);
    .time(H,M,S,MS);
    if(R < 0.5){
		self_location(X0, Y0-1);
        move(n);
        .print("[",H,":",M,":",S,":",MS,"] ","Agent move n to avoid an obstacle");
    }else{
		self_location(X0, Y0+1);
        move(s);
        .print("[",H,":",M,":",S,":",MS,"] ","Agent move s to avoid an obstacle");
    }.

// 【avoid_obstacle_n_s】 North-South Obstacle Avoidance Strategy. Depending on the size of the random number, an obstacle avoidance direction (north/south) is chosen.
+avoid_obstacle_n_s : true <-
    .random(R);
    .time(H,M,S,MS);
    if(R < 0.5){
		self_location(X0+1, Y0);
        move(e);
        .print("[",H,":",M,":",S,":",MS,"] ","Agent move e to avoid an obstacle");
    }else{
		self_location(X0-1, Y0);
        move(w);
        .print("[",H,":",M,":",S,":",MS,"] ","Agent move w to avoid an obstacle");
    }.


