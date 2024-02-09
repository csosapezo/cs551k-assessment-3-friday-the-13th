@move_agent_success[atomic]
+!move_agent: self_location(X0,Y0)  & lastAction(move) & lastActionResult(success) & lastActionParams([Dir]) & get_dir(X1,Y1,Dir)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] "," Agent (",X0,",",Y0,") move ",Dir);
	-+self_location(X0+X1,Y0+Y1);
	move(Dir).


@move_agent_goal[atomic]
+!move_agent: location(goal,_,XG,YG,_) & self_location(X0,Y0) & available_task(Name, Deadline, Rew,X,Y,Type) & block(Dir,Type) & not current_task(_,_,_,_,_,_) & not task_already_taken(Name)<-
	.time(H,M,S,MS);
	.broadcast(tell,task_already_taken(N));
	-available_task(Name, Deadline, Rew,X,Y,Type);
	+current_task(Name, Deadline, Rew,X,Y,Type);
	-+mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] "," Agent start task ",Name).


@move_random[atomic] 
+!move_agent : .random(RandomNumber) & random_dir([n,s,e,w] ,RandomNumber,Dir) & self_location(X0,Y0) & get_dir(X1,Y1,Dir)<-
    -+self_location(X0+X1,Y0+Y1);
	move(Dir);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] "," Agent (",X0,",",Y0,") move randomly ",Dir).

