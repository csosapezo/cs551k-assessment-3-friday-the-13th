// 【!move_agent】 When the agent currently has no tasks and no conflicting tasks, and the target location is known, if it succeeds in acquiring a task, the agent broadcasts a notification of
// 				   the conflict and enters the mode of finding the goal.
@move_agent_goal[atomic]
+!move_agent: not(mode(find_goal)) & location(goal,_,XG,YG) & self_location(X0,Y0) & available_task(Name, Deadline, Rew,X,Y,Type) & block(Dir,Type) & not task_already_taken(Name)<-
	.time(H,M,S,MS);
	.broadcast(tell,task_already_taken(Name));
	-available_task(Name, Deadline, Rew,X,Y,Type);
	+current_task(Name, Deadline, Rew,X,Y,Type);
	-+mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] "," Agent start task ",Name).

// 【!move_agent】  If the last movement was successful, the agent continues to keep moving in the same direction according to the direction of successful movement returned by the server
@move_agent_success[atomic]
+!move_agent: self_location(X0,Y0)  & lastAction(move) & lastActionResult(success) & lastActionParams([Dir]) & get_dir(X1,Y1,Dir)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] "," Agent (",X0,",",Y0,") move ",Dir);
	-+self_location(X0+X1,Y0+Y1);
	move(Dir).

// 【!move_agent】 Random walk strategie for agents.
@move_random[atomic] 
+!move_agent : .random(RandomNumber) & random_dir([n,s,e,w] ,RandomNumber,Dir) & self_location(X0,Y0) & get_dir(X1,Y1,Dir)<-
    -+self_location(X0+X1,Y0+Y1);
	move(Dir);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] "," Agent (",X0,",",Y0,") move randomly ",Dir).

