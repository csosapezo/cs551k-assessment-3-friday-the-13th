@move_agent[atomic]
+!move_agent: agent_location(MyN,MyX,MyY)  & lastAction(move) & lastActionResult(success) & lastActionParams([Dir]) & get_dir(X1,Y1,Dir) &.count(block(_,_),N)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","agent move Dir=",Dir,",X=",X1,",Y=",Y1,",N=",N);

	if(Dir == n){
			-+agent_location(9,MyX,MyY-1);
	}elif(Dir == e){
			-+agent_location(10,MyX+1,MyY);
	}elif(Dir == s){
			-+agent_location(11,MyX,MyY+1);
	}elif(Dir == w){
			-+agent_location(12,(MyX-1),MyY);
	};

	move(Dir).
    
@move_agent2[atomic]
+!move_agent: location(goal,_,GoalX,GoalY,_) & agent_location(MyN,MyX,MyY) & task_base(N, D, R,TX,TY,B) & block(Bdir,B) & not current_task(_,_,_,_,_,_) & not conflict_task(N)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","the agent receive a new task ",N,",D=", D,",R=", R,",B=", B,",X=", TX,",Y=",TY);
	.broadcast(tell,conflict_task(N));
	-task_base(N, D, R,TX,TY,B);
	+current_task(N, D, R,TX,TY, B);
	-+agent_mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] ","5--------------------------- agent start task=",N);
	.
	
@lateral[atomic] 
+!move_agent : lastActionParams([Dir]) & lateral(DirList, Dir) & .random(RandomNumber) & random_lateral_dir(DirList,RandomNumber,Dir) & agent_location(MyN,MyX,MyY)<-
	if(Dir == n){
		-+agent_location(1,MyX,(MyY-1));
	}elif(Dir == e){
		-+agent_location(2,(MyX+1),MyY);
	}elif(Dir == s){
		-+agent_location(3,MyX,(MyY+1)); 
	}elif(Dir == w){
		-+agent_location(4,(MyX-1),MyY);
	};
	move(Dir);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","agent move lateral:",Dir);
	.


@plan[atomic] 
+!move_agent : .random(RandomNumber) & random_dir([n,s,e,w] ,RandomNumber,Dir) & agent_location(MyN,MyX,MyY)<-
	if(Dir == n){
		-+agent_location(1,MyX,(MyY-1));
	}elif(Dir == e){
		-+agent_location(2,(MyX+1),MyY);
	}elif(Dir == s){
		-+agent_location(3,MyX,(MyY+1)); 
	}elif(Dir == w){
		-+agent_location(4,(MyX-1),MyY);
	};
	move(Dir);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","agent move random:",Dir);
	.


