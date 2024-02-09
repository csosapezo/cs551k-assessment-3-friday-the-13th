/*  This module is used to discover the goal and navigate to the goal location */

// 【!move_on】 Given the coordinates of a goal, step-by-step navigation to the location of the goal is accomplished with the suggested_dir_on method. When the agent is already on the goal, 
// 			   the rotate_direction plan is executed to attempt to place the block on the goal to submit the task.
@go_to_goal[atomic] 
+!go_to_goal(X,Y): self_location(X0,Y0) & suggested_dir_on(X-X0,Y-Y0,Dir) & current_task(Name, Deadline, Rew,TX,TY, Type) & get_dir(X1, Y1, Dir)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Agent (", X0,",",Y0,") move", Dir, "to goal position at ",X,",",Y);

	if (Dir == null){
		!rotate_direction(Name, TX,-TY,Type);
	}else{
		-+self_location(X0+X1,Y0+Y1);
		move(Dir);
	}.

// 【!rotate_direction】 In this case, the direction of the block does not coincide with the direction of the goal, and the block is rotated to the direction of the goal by querying an available\
// 						rotation direction. In addition update the orientation of the block and the available orientation of the agent.
@rotate_direction1[atomic]
+!rotate_direction(Name, X, Y, Type) : get_dir_on(X,Y,TargetDir) & block(CurrentDir,Type) & not (TargetDir == CurrentDir) & needed_rotate_dir(TargetDir,CurrentDir,RDir) <-
	!update_rotated_block_dir(RDir);
	!update_rotated_available_dir(RDir);
	rotate(RDir);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Agent rotate from",TargetDir,",to ",CurrentDir," ",RDir).

//	【!rotate_direction】 In this case, the direction of the block has been aligned with the direction in which the target is located. So try to submit the task and remove the task information and block 
// 						 information from the belief base. In addition the available directions will be released as well as switching the agent to exploration mode. Finally the assign_dispenser plan is executed to find the dispenser.
@rotate_direction2[atomic]
+!rotate_direction(Name, X, Y, Type) : get_dir_on(X,Y,TargetDir) & block(TargetDir,Type) <-
	-current_task(_, _, _,_,_, _);
	-block(CurrentDir,Type);
	+available_dir(CurrentDir);
	submit(Name);
	-+mode(explore);
	!assign_dispenser;
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Agent submit the task ",Name).


