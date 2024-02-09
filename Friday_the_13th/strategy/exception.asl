/* This module is used to define the handling policy for events that fail with the environment. */


// 【!move_failed_path】 Used to handle move failure events in exploration mode. Used to handle move failure events. Once it fails, the agent will move to its opposite direction
// 					    based on the direction of failure returned.
+!move_failed_path(Params): mode(explore) & self_location(X0,Y0) & .member(Dir,Params) & get_dir(X1,Y1,Dir) <-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Move ", Dir, " unsuccessful");
	-+self_location(X0-X1,Y0-Y1).

// 【!move_failed_path】 Used to handle move failure events in find_blocks mode. Used to handle move failure events. Once it fails, the agent will move to its opposite direction
// 					    based on the direction of failure returned.
+!move_failed_path(Params) : mode(find_blocks) & self_location(X0,Y0) & .member(Dir,Params) & get_dir(X1,Y1,Dir)
    & location(dispenser,Type,X,Y,DSeq) & target_dispenser(_,X2,Y2) & not X == X2 & not Y == Y2<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Move ", Dir, " unsuccessful");
	-+self_location(X0-X1,Y0-Y1);
	!dispenser_found(Type,X,Y).

// 【!move_failed_path】 Used to handle move failure events in find_goal mode. Used to handle move failure events. Once it fails, the agent will move to its opposite direction
// 					    based on the direction of failure returned.
+!move_failed_path(Params): mode(find_goal) & self_location(X0,Y0) & .member(Dir,Params) & get_dir(X1,Y1,Dir)
    & location(goal,_,XG,YG,GSeq)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Move ", Dir, " unsuccessful");
	-+self_location(X0-X1,Y0-Y1);
	-location(goal,_,XG,YG,GSeq);
	-location(goal,task,XG,YG,GSeq).

// 【!move_exploration_failed_forbidden】 Used to handle movement failure events due to out-of-bounds in exploration mode. Once it fails, the agent will move to its opposite direction
// 										 based on the direction of failure returned. Once a crossing occurs, the crossing point is recorded and a follow-on move point is generated.
+!move_exploration_failed_forbidden(Params): mode(explore) & self_location(X0,Y0)
    & .member(Dir,Params) & get_dir(X1,Y1,Dir) & boundary(X0, Y0, Dir, B) <-

	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ", Dir, " Boundary found");
	+boundary(Dir,B);
	-+self_location(X0-X1,Y0-Y1).

// 【!submit_success】 After the agent submits the task successfully, it clears the current task and changes the current mode to the exploratory state, followed by the execution of the assign_dispenser plan.
+!submit_success(Params): true <-
	.member(N,Params);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Task ",N," submitted successfully!");
	-current_task(_,_,_,_,_,_);
	-+mode(explore);
	!assign_dispenser.

// 【!submit_failed】 When an agent fails to submit a mission, it will abandon the current mission, move to the Explore state, and mark the current direction as unreachable. It will also add the
// 					 unsubmitted block to the belief repository.
+!submit_failed(Params): .member(N,Params) & current_task(N, D, R,TX,TY, B) & get_dir(TX,TY,Dir) & block(Dir,B)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Task ",N, "not submitted.");
	-current_task(N, D, R,TX,TY, B);
	+block(Dir,B);
	-available_dir(Dir);
	-+mode(explore);
	!assign_dispenser.

// 【!request_failed_blocked】 After the agent fails to request a block, it will switch to exploratory mode, while abandoning the current task and deleting the information for that dispenser.
+!request_failed_blocked: true<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Block request failed.");
	-+mode(explore);
	-target_dispenser(_,_,_);
	-current_task(_,_,_,_,_,_);
	.

// 【!request_failed_target】 When the agent request a wrong target, it will switch to exploratory mode, while abandoning the current task and deleting the dispenser's information.
+!request_failed_target: true <-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Request failed.");
	-+mode(explore);
	-target_dispenser(_,_,_);
	-current_task(_,_,_,_,_,_);
	.

// 【!attach_failed_target】 An agent attempting to mount an incorrect target will go to explore mode and delete that target location, abandoning the current task.
+!attach_failed_target:true<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Mount failed");
	-+mode(explore);
	-target_dispenser(_,_,_);
	-current_task(_,_,_,_,_,_).

// 【!attach_failed】 An agent that fails to mount a block will delete information about the current block and abort the task. It will also switch to exploration mode.
+!attach_failed: true<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Attachment failed.");
	-+mode(explore);
	-target_dispenser(_,_,_);
	-current_task(_,_,_,_,_,_).

// 【!rotate_failed】 When the agent fails to rotate, it tries to rotate in the opposite direction based on the direction of the failed rotation returned.
+!rotate_failed(Params): .member(Rdir,Params) & opposite_rotation(Rdir, OpRdir) <-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Rotation failed");
	!update_rotated_block_dir(OpRdir).

// 【!detach_failed】 The agent fails to detach the block and will print the message without doing anything.
+!detach_failed: true<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Detach failed.").

// 【!detach_failed_target】 The proxy detaches a error target and will print the message without doing anything.
+!detach_failed_target: true<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","Detach failed.").


