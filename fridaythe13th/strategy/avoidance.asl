// agent see a obstacle
// +obstacle(X,Y): agent_location(MyN,MyX,MyY) & count_location(obstacle,N) & (N == 0) <- //信念里没有任何障碍
// 	+location(obstacle,_,(MyX+X),(MyY+Y));
// 	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees an obstacle :",(MyX+X),",",(MyY+Y));
//     .


// +obstacle(X,Y): agent_location(MyN,MyX,MyY) & location(obstacle,_,ObsX,ObsY) <- //信念里有这个障碍
// 	if(not (ObsX == (MyX+X)) & not (ObsY == (MyY+Y))){
// 		+location(obstacle,_,(MyX+X),(MyY+Y));
// 		.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees an obstacle :");
// 	};
// 	.
// & not block(_, _)  & agent_mode(exploration)


+avoid_obstacle : agent_location(MyN, MyX, MyY)<-
    if(location(obstacle,_,(MyX+1),(MyY))){
		+avoid_obstacle_e_w;
	}elif(location(obstacle,_,(MyX-1),(MyY))){
		+avoid_obstacle_e_w;
	}elif(location(obstacle,_,(MyX),(MyY+1))){
		+avoid_obstacle_n_s;
	}elif(location(obstacle,_,(MyX),(MyY-1))){
		+avoid_obstacle_n_s;
	}
	.

+avoid_obstacle_e_w : true <-
    .random(R);
    .print("Random number: ", R);
    if(R < 0.5){
		agent_location(MyN, MyX, MyY-1);
        move(n);
        .print("the agent move n to avoid an obstacle");
    }else{
		agent_location(MyN, MyX, MyY+1);
        move(s);
        .print("the agent move s to avoid an obstacle");
    }.

+avoid_obstacle_n_s : true <-
    .random(R);
    .print("Random number: ", R);
    if(R < 0.5){
		agent_location(MyN, MyX+1, MyY);
        move(e);
        .print("the agent move e to avoid an obstacle");
    }else{
		agent_location(MyN, MyX-1, MyY);
        move(w);
        .print("the agent move w to avoid an obstacle");
    }.


+obstacle(X,Y): agent_location(MyN,MyX,MyY) & count_location(obstacle,N) & (N == 0) <- 
    +location(obstacle,_,(MyX+X),(MyY+Y));
    .time(H,M,S,MS);
    // .print("[",H,":",M,":",S,":",MS,"] ","the agent sees an obstacle :",(MyX+X),",",(MyY+Y));
    +avoid_obstacle(MyX+X, MyY+Y);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees an obstacle :",(MyX+X),",",(MyY+Y));
    .

+obstacle(X,Y): agent_location(MyN,MyX,MyY) & location(obstacle,_,ObsX,ObsY) <- 
    if(not (ObsX == (MyX+X)) & not (ObsY == (MyY+Y))){
        +location(obstacle,_,(MyX+X),(MyY+Y));
        .time(H,M,S,MS);
        // .print("[",H,":",M,":",S,":",MS,"] ","the agent sees an obstacle :");
        +avoid_obstacle(MyX+X, MyY+Y);
		.print("[",H,":",M,":",S,":",MS,"] ","the agent sees an obstacle :",(MyX+X),",",(MyY+Y));
    }
    .

