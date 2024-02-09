/* This module is the main program of the agent */


// Introduction of different functional modules

{ include("strategy/explore.asl") }
{ include("strategy/find_block.asl") }
{ include("strategy/find_goal.asl") }
{ include("strategy/exception.asl") }
{ include("strategy/avoidance.asl") }
{ include("strategy/identify.asl") }
{ include("utils.asl") }

// Initial beliefs

self_location(0,0).
mode(explore).
goal_list([500]).
dispenser_list([500]).



// Initial goals 

!start.                

//  Plans 

+!start : true <-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Hello massim world.").

// Try to query available_task for a task. The task is deleted from available_task after a successful fetch. 
+step(S): available_task(Name, Deadline, Rew,X,Y,Type) <-
	-available_task(Name, Deadline, Rew,X,Y,Type).

// If not, choose to execute an appropriate plan.
+actionID(ID) : true<- 
	!define_next_action.

// 【!action_mode】 In the current mode, the agent executes the exploration strategy.
+!define_next_action : mode(explore)<- 
	!move_agent.

//  Move to dispenser.
+!define_next_action :  mode(find_blocks) & target_dispenser(Type,X,Y) <-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Move to dispenser at ", X, Y);
	!move_to_dispenser(X,Y,Type).

// Find the coordinates of a minimally labeled goal from next_goal as the agent's goal.
+!define_next_action : mode(find_goal) & next_goal(XG,YG) & current_task(_, _, _,_,_,_) <- 
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Move to Goal");
	!go_to_goal(XG,YG).

// 【!assign_dispenser】 This plan is used to give the agent the ability to store the dispenser's information in target_dispenser when it finds a dispenser that has not yet sensed the block type and switches to find_blocks mode.
@assign_dispenser[atomic] 
+!assign_dispenser : not block(_,Type) & next_dispenser(Type,X,Y) <-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","The agent target_dispenser Type=",Type);
	-+target_dispenser(Type,X,Y);
	-+mode(find_blocks).

// 【!assign_dispenser】This plan is a backup plan in case gent fails to execute the assign_dispenser plan, and only prints the information.
@stock1[atomic] 
+!assign_dispenser : true <-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","The agent gives up a target_dispenser Type=",Type).

// 【thing】When the agent receives the thing sense from the server and the sense is dispenser, it will calculate the absolute position by the relative position of the dispenser and update the dispenser_list.Finally,
//			it will call the dispenser_found plan.
@thing1[atomic] 
+thing(X, Y, dispenser, Type) : self_location(X0,Y0) & not location(dispenser,Type,(X0+X),(Y0+Y),_) & dispenser_list(Dispensers)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ", Type, " dispenser detected at ",X,",",Y);
	
	if(X0+X < 0 & Y0+Y < 0){
		+location(dispenser,Details,(X0+X),(Y0+Y), ((X0+X) * -1)+((Y0+Y) * -1));
		.concat(DQ,[((X0+X) * -1)+((Y0+Y) * -1)],DQ2);
		-+dispenser_list(DQ2);
	}elif(X0+X > 0 & Y0+Y < 0){
		+location(dispenser,Details,(X0+X),(Y0+Y), (X0+X)+((Y0+Y) * -1));
		.concat(DQ,[(X0+X)+((Y0+Y) * -1)],DQ2);
		-+dispenser_list(DQ2);
	}elif(X0+X < 0 & Y0+Y > 0){
		+location(dispenser,Details,(X0+X),(Y0+Y), ((X0+X) * -1)+(Y0+Y));
		.concat(DQ,[((X0+X) * -1)+(Y0+Y)],DQ2);
		-+dispenser_list(DQ2);
	}elif(X0+X > 0 & Y0+Y > 0){
		+location(dispenser,Details,(X0+X),(Y0+Y), X0+X+Y0+Y);
		.concat(DQ,[X0+X+Y0+Y],DQ2);
		-+dispenser_list(DQ2);
	};
	!dispenser_found(Type,(X0+X),(Y0+Y)).

// 【!discover_stock】 In this case, if the agent has not found any blocks yet, then it records the target_dispenser information and updates its own status to find_blocks.
@dispenser_found[atomic] 
+!dispenser_found(Type,X,Y) : not block(_,_)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Dispenser found");
	-+target_dispenser(Type,X,Y);
	-+mode(find_blocks).

// 【!discover_stock】 In this case, the agent prints only the message if it already has a block of the same type.
@discover_stock2[atomic] 
+!dispenser_found(Type,X,Y) : block(_,Type)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Dispenser found").

// 【-!discover_stock】 Used to handle situations where dispenser_found execution fails.
@discover_stock3[atomic] 
-!dispenser_found(Type,X,Y) : true<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Error while detecting dispenser.").

// 【goal】Used to update the location information of an undiscovered goal into goal_list.
@goal1[atomic] 
+goal(X,Y): self_location(X0,Y0) & not location(goal,_,(X0+X),(Y0+Y),_) & goal_list(Goals)<- 
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Goal detected at ",X,",",Y);

	// Manhattan distance from the origin
	if(X0+X < 0 & Y0+Y < 0){
		+location(goal,_,(X0+X),(Y0+Y), ((X0+X) * -1)+((Y0+Y) * -1));
		.concat(Goals,[((X0+X) * -1)+((Y0+Y) * -1)],GoalsNewList);
		-+goal_list(GoalsNewList);
	}elif(X0+X > 0 & Y0+Y < 0){
		+location(goal,_,(X0+X),(Y0+Y), (X0+X)+((Y0+Y) * -1));
		.concat(Goals,[(X0+X)+((Y0+Y) * -1)],GoalsNewList);
		-+goal_list(GoalsNewList);
	}elif(X0+X < 0 & Y0+Y > 0){
		+location(goal,_,(X0+X),(Y0+Y), ((X0+X) * -1)+(Y0+Y));
		.concat(Goals,[((X0+X) * -1)+(Y0+Y)],GoalsNewList);
		-+goal_list(GoalsNewList);
	}elif(X0+X > 0 & Y0+Y > 0){
		+location(goal,_,(X0+X),(Y0+Y), X0+X+Y0+Y);
		.concat(Goals,[X0+X+Y0+Y],GoalsNewList);
		-+goal_list(GoalsNewList);
	}.

// 【location(goal,_,X,Y)】 When an agent receives a location(goal,_,X,Y) belief, if it is not currently executing any tasks and has not received any task conflict information, it will get a task from available_task
//							gets a task and broadcasts a notification of the conflict to all agents in the same team.
@goal2[atomic] 
+location(goal,_,X,Y): available_task(Name, Deadline, Rew,TX,TY,Type) & block(Dir,Type) & not current_task(_,_,_,_,_,_) & not task_already_taken(N)<- 
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","The agent sees a goal:",X,",",Y);
	
	.broadcast(tell,task_already_taken(Name));
	-available_task(Name, Deadline, Rew,TX,TY,Type);
	+current_task(Name, Deadline, Rew,TX,TY,Type);
	-+mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] ","1--------------------------- Agent start task ",N).

// 【have_block】 When an agent succeeds in taking possession of a block, it broadcasts a notification of a conflict to other agents in the same team.
@have_block[atomic] 
+have_block(Dir,B) : location(goal,_,XG,YG,_) & available_task(Name, Deadline, Rew,X,Y,Type) & block(Dir,Type) & not current_task(_,_,_,_,_,_) & not task_already_taken(Name)<-
	.broadcast(tell,task_already_taken(Name));
	-available_task(Name, Deadline, Rew,X,Y,Type);
	+current_task(Name, Deadline, Rew, X, Y, Type);
	-+mode(find_goal);
	-have_block(Dir,Type).

// 【task】 When the agent receives a task belief from the server, it will only accept tasks of a specific block length. Currently only tasks with a block length of 1 are accepted.
+task(Name, Deadline, Rew, Req) : (.length(Req) == 1) & not available_task(Name,_,_,_,_,_)<-
	.member(req(X,Y,Type),Req);
	.print("Task ",Name, " added.");
	+available_task(Name, Deadline, Rew, X, Y, Type).

// 【available_task】Upon receiving a available_task belief, the agent will query if it is currently executing or if there is a task conflict. If it is not executing and there is no conflict, 
// 			   it transforms the task into a current_task and broadcasts a conflict notification.
@available_task[atomic] 
+available_task(Name, Deadline, Rew,X,Y,Type) : location(goal,_,XG,YG,_) & block(Dir,Type) & not current_task(_,_,_,_,_,_) & not task_already_taken(Name)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","The agent took task ",Name);
	.broadcast(tell,task_already_taken(Name));
	-available_task(Name, Deadline, Rew,X,Y,Type);
	+current_task(Name, Deadline, Rew,X,Y,Type);
	-+mode(find_goal).
	
// 【task_already_taken】 Upon receiving a task conflict message from another agent, this agent will add the task content from the conflict message to its own task conflict beliefs.
+task_already_taken(Name)[source(Ag)]  :  not(Ag = self) <- 
	+task_already_taken(Name);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Task ",Name," was already taken by", Ag).

// 【self_location(X,Y)】 Manage the agent's own coordinates. The initial starting position is the coordinate origin, and thereafter the coordinate offsets generated by
// 							the agent's movements and the positions of the objects it sees are updated based on that origin.
+self_location(X,Y) : true <-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Agent now at",X,",",Y).


// 【lastAction(Action)】 Handling failure events after interaction with the environment
+lastAction(Action) : lastActionResult(Result)<-
	if(Action == attach & Result == failed){
		!attach_failed;
	}elif(Action == attach & Result == failed_target){
		!attach_failed_target;
	}elif(Action == request & Result == failed_blocked){
		!request_failed_blocked;
	}elif(Action == detach & Result == failed){
		!detach_failed;
	}elif(Action == detach & Result == failed_target){
		!detach_failed_target;
	}.

// 【lastAction(Action)】 Handling failed parameterized events after interaction with the environment
+lastAction(Action) : lastActionResult(Result) & lastActionParams(Params)<-
	if(Action == rotate & Result == failed){
		!rotate_failed(Params)
	}elif(Action == attach & Result == failed){
		!attach_failed;
	}elif(Action == attach & Result == failed_target){
		!attach_failed_target;
	}elif(Action == request & Result == failed_blocked){
		!request_failed_blocked;
	}elif(Action == submit & Result == failed){
	  !submit_failed(Params);
	}elif(Action == submit & Result == success){
	  !submit_success(Params);
	}elif(Action == move & Result == failed_forbidden){
		!move_exploration_failed_forbidden(Params);
	}elif(Action == move & Result == failed_path){
		!move_failed_path(Params);
	}.
