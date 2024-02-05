// Agent bob in project MAPC2018.mas2j
/* Initial beliefs and rules */
{ include("strategy/explore.asl") }
{ include("strategy/find_block.asl") }
{ include("strategy/find_goal.asl") }
{ include("strategy/exception.asl") }
{ include("strategy/avoidance.asl") }
{ include("strategy/identify.asl") }
{ include("utils.asl") }

agent_location(0,0,0).
agent_mode(exploration).
dispenser_queue([500]).
goal_queue([500]).


ava_dir(e).
ava_dir(s).
ava_dir(w).
ava_dir(n).

/* Initial goals */

!start.                

/* Plans */

+!start : .random(R1) & get_random_pointX(R1,X) & .random(R2) & get_random_pointX(R2,Y)<- 
	.my_name(N);
	+agent_name(N);
	.all_names(L);
	+agent_list(L);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent name is ",N);
	.print("[",H,":",M,":",S,":",MS,"] ","hello massim world.");
	+random_point(X,Y);
	.
	
+step(S): task_base(N, S, R,TX,TY,B) <-
	-task_base(N, S, R,TX,TY,B);
	.

// agent explore the world
+actionID(ID) : true<- 
	!action_pipe;
	.

// agent finds goal position
+!action_pipe : get_next_goal(GoalX,GoalY) & agent_mode(find_goal) & current_task(N, D, R,TX,TY, Req) <- 
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","current mode find_goal");
	!move_on(GoalX,GoalY);	
	.

+!action_pipe : agent_mode(exploration)<- 
	!explore;
	.

// the agent fetches a block
+!action_pipe : stock(Btype,X,Y) &  agent_mode(find_blocks) <-
	.time(H,M,S,MS);
	//.print("[",H,":",M,":",S,":",MS,"] ","stock abs ================",X,",",Y);
	//.print("[",H,":",M,":",S,":",MS,"] ","stock rel ================",X2,",",Y2);
	.print("[",H,":",M,":",S,":",MS,"] ","current mode find_blocks");
	!find_blocks(Btype,X,Y);
	.


+!explore: true <-
	!move_random_point;
	//!move_random;
	.


@discover_stock[atomic] 
+!discover_stock(Btype,X,Y) : not block(_,_)<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","the agent discover_stock1 Dtype=",Btype);
	-+stock(Btype,X,Y);
	-+agent_mode(find_blocks);
	.
@discover_stock2[atomic] 
+!discover_stock(Btype,X,Y) : block(_,Btype)<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","the agent discover_stock2 Dtype=",Btype);
	.

@stock[atomic] 
+!stock : not block(_,Dtype) & get_next_dispenser(Dtype,X,Y) <-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","the agent stock Dtype=",Dtype);
	-+stock(Dtype,X,Y);
	-+agent_mode(find_blocks);
	.
	
@thing1[atomic] 
+thing(X, Y, dispenser, Details) : agent_location(MyN,MyX,MyY) & not location(dispenser,Details,(MyX+X),(MyY+Y),DSeq) & dispenser_queue(DQ)<-
	.time(H,M,S,MS);
	.type(DQ,T);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a dispenser",",Details=",Details,",X=",X,",Y=",Y);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a dispenser",",Details=",Details,",MyX=",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a dispenser",",Details=",Details,",(MyX+X)=",(MyX+X),",(MyY+Y)=",(MyY+Y));
	
	if(MyX+X < 0 & MyY+Y < 0){
		+location(dispenser,Details,(MyX+X),(MyY+Y), ((MyX+X) * -1)+((MyY+Y) * -1));
		.concat(DQ,[((MyX+X) * -1)+((MyY+Y) * -1)],DQ2);
		-+dispenser_queue(DQ2);
	}elif(MyX+X > 0 & MyY+Y < 0){
		+location(dispenser,Details,(MyX+X),(MyY+Y), (MyX+X)+((MyY+Y) * -1));
		.concat(DQ,[(MyX+X)+((MyY+Y) * -1)],DQ2);
		-+dispenser_queue(DQ2);
	}elif(MyX+X < 0 & MyY+Y > 0){
		+location(dispenser,Details,(MyX+X),(MyY+Y), ((MyX+X) * -1)+(MyY+Y));
		.concat(DQ,[((MyX+X) * -1)+(MyY+Y)],DQ2);
		-+dispenser_queue(DQ2);
	}elif(MyX+X > 0 & MyY+Y > 0){
		+location(dispenser,Details,(MyX+X),(MyY+Y), MyX+X+MyY+Y);
		.concat(DQ,[MyX+X+MyY+Y],DQ2);
		-+dispenser_queue(DQ2);
	};
	
	!discover_stock(Details,(MyX+X),(MyY+Y));
	.

// @thing2[atomic] 
// +thing(X, Y, block, Details) : agent_location(MyN,MyX,MyY) & not location(block,Details,(MyX+X),(MyY+Y)) & get_dir(X,Y,Dir) & not block(Dir,Details)<-
// 	.time(H,M,S,MS);
// 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",block,",Details=",Details,",X=",Y,",Y=",Y);
// 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",block,",Details=",Details,",MyX=",MyX,",MyY=",MyY);
// 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",block,",Details=",Details,",(MyX+X)=",(MyX+X),",(MyY+Y)=",(MyY+Y));
// 	+location(block,Details,(MyX+X),(MyY+Y));
// 	.

@goal1[atomic] 
+goal(X,Y): agent_location(MyN,MyX,MyY) & not location(goal,_,(MyX+X),(MyY+Y),_) & goal_queue(GQ)<- 
	.time(H,M,S,MS);
	.type(GQ,T);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a goal:","X=",X,",Y=",Y,",GQ=",GQ,",T=",T);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a goal:",",MyX=",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a goal:",",(MyX+X)=",(MyX+X),",(MyY+Y)=",(MyY+Y));
	if(MyX+X < 0 & MyY+Y < 0){
		+location(goal,_,(MyX+X),(MyY+Y), ((MyX+X) * -1)+((MyY+Y) * -1));
		.concat(GQ,[((MyX+X) * -1)+((MyY+Y) * -1)],GQ2);
		-+goal_queue(GQ2);
	}elif(MyX+X > 0 & MyY+Y < 0){
		+location(goal,_,(MyX+X),(MyY+Y), (MyX+X)+((MyY+Y) * -1));
		.concat(GQ,[(MyX+X)+((MyY+Y) * -1)],GQ2);
		-+goal_queue(GQ2);
	}elif(MyX+X < 0 & MyY+Y > 0){
		+location(goal,_,(MyX+X),(MyY+Y), ((MyX+X) * -1)+(MyY+Y));
		.concat(GQ,[((MyX+X) * -1)+(MyY+Y)],GQ2);
		-+goal_queue(GQ2);
	}elif(MyX+X > 0 & MyY+Y > 0){
		+location(goal,_,(MyX+X),(MyY+Y), MyX+X+MyY+Y);
		.concat(GQ,[MyX+X+MyY+Y],GQ2);
		-+goal_queue(GQ2);
	};
	.
@goal2[atomic] 
+location(goal,_,X,Y): task_base(N, D, R,TX,TY,B) & block(Bdir,B) & not current_task(_,_,_,_,_,_) & not conflict_task(N)<- 
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a goal1:",X,",",Y);
	
	.broadcast(tell,conflict_task(N));
	-task_base(N, D, R,TX,TY,B);
	+current_task(N, D, R,TX,TY, B);
	-+agent_mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] ","1--------------------------- agent start task=",N);
	.
	
@have_block[atomic] 
+have_block(Dir,B) : location(goal,_,GoalX,GoalY,_) & task_base(N, D, R,TX,TY,B) & block(Dir,B) & not current_task(_,_,_,_,_,_) & not conflict_task(N)<-
	
	.broadcast(tell,conflict_task(N));
	-task_base(N, D, R,TX,TY,B);
	+current_task(N, D, R,TX,TY, B);
	-+agent_mode(find_goal);
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","3--------------------------- agent start task=",N);
	-have_block(Dir,B);
	.

+task(N, D, R, Req) : (.length(Req) == 1) & not task_base(N,_,_,_,_,_)<-
	.member(req(TX,TY,B),Req);
	.print("agent add task_base--------",",B=", B,",X=", TX,",Y=",TY,",N=",N);
	+task_base(N, D, R,TX,TY,B);
	.
@task_base[atomic] 
+task_base(N, D, R,TX,TY,B) : location(goal,_,GoalX,GoalY,_) & block(Dir,B) & not current_task(_,_,_,_,_,_) & not conflict_task(N)<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","the agent receive a new task ",N,",D=", D,",R=", R,",B=", B,",X=", TX,",Y=",TY);
	.broadcast(tell,conflict_task(N));
	-task_base(N, D, R,TX,TY,B);
	+current_task(N, D, R,TX,TY, B);
	-+agent_mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] ","4--------------------------- agent start task=",N);
	.
	

+conflict_task(N)[source(Ag)]  :  Ag \== self <- 
	+conflict_task(N);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","Received tell conflict task name ",N," from ", Ag);
	.


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
	};
	.
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
	};
	.


+agent_location(N,X,Y) : true <-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","add self location inspect :",N,",",X,",",Y);
	//true;
	.
