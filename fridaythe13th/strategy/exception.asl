+!move_failed_path(Params): agent_mode(exploration) & agent_location(MyN,MyX,MyY) <-
	.member(V,Params);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","------------lastaction failed:",V);
	if(V == n){
		-+agent_location(MyN,MyX,MyY+1);
	}elif(V == e){
		-+agent_location(MyN,MyX-1,MyY);
	}elif(V == s){
		-+agent_location(MyN,MyX,MyY-1);
	}elif(V == w){
		-+agent_location(MyN,MyX+1,MyY);
	};
	.
+!move_failed_path(Params) : agent_mode(find_blocks) & agent_location(MyN,MyX,MyY) & location(diispenser,Dtype,X,Y,DSeq) & stock(_,X2,Y2) & not X == X2 & not Y == Y2<-
	.member(V,Params);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","---find_blocks---------lastaction failed:",V);

	if(V == n){
		-+agent_location(MyN,MyX,MyY+1);
	}elif(V == e){
		-+agent_location(MyN,MyX-1,MyY);
	}elif(V == s){
		-+agent_location(MyN,MyX,MyY-1);
	}elif(V == w){
		-+agent_location(MyN,MyX+1,MyY);
	};
	!discover_stock(Dtype,X,Y);
	.
+!move_failed_path(Params): agent_mode(find_goal) & agent_location(MyN,MyX,MyY) & location(goal,_,Goalx,GoalY,GSeq)<-
	.member(V,Params);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","---find_goal---------lastaction failed:",V);

	if(V == n){
		-+agent_location(MyN,MyX,MyY+1);
	}elif(V == e){
		-+agent_location(MyN,MyX-1,MyY);
	}elif(V == s){
		-+agent_location(MyN,MyX,MyY-1);
	}elif(V == w){
		-+agent_location(MyN,MyX+1,MyY);
	};
	-location(goal,_,Goalx,GoalY,GSeq);
	-location(goal,task,Goalx,GoalY,GSeq);
	.

+!move_exploration_failed_forbidden(Params): agent_mode(exploration) & agent_location(MyN,MyX,MyY) & .random(R1) & .random(R2) & .random(R3) & get_random_pointX(R1,X1) & get_random_pointY(R2,R3,X1,X,Y)<-
	.member(V,Params);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent reached the boundary:",V);

	if(V == n){
		+boundary(n,MyY);
		-+agent_location(MyN,MyX,MyY+1);
	}elif(V == e){
		+boundary(e,MyX);
		-+agent_location(MyN,MyX-1,MyY);
	}elif(V == s){
		+boundary(s,MyY);
		-+agent_location(MyN,MyX,MyY-1);
	}elif(V == w){
		+boundary(s,MyX);
		-+agent_location(MyN,MyX+1,MyY);
	};
	.
	
+!submit_success(Params): true <-
	.member(N,Params);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent submit task success--------------------N=",N);

	-current_task(_,_,_,_,_,_);
	-+agent_mode(exploration);
	!stock;
	.
	
+!submit_failed(Params): .member(N,Params) & current_task(N, D, R,TX,TY, B) & get_dir(TX,TY,Dir) & block(Dir,B)<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent submit task failed--------------------N=",N);
	-current_task(N, D, R,TX,TY, B);
	+block(Dir,B);
	-ava_dir(Dir);
	-+agent_mode(exploration);
	!stock;
	.
+!request_failed_blocked: true<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent request failed-------failed_blocked-------------");
	-+agent_mode(exploration);
	-stock(_,_,_);
	-current_task(_,_,_,_,_,_);
	.
+!request_failed_target: true <-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent request failed--------failed_target------------");
	-+agent_mode(exploration);
	-stock(_,_,_);
	-current_task(_,_,_,_,_,_);
	.
+!attach_failed_target:true<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent attach failed-------failed_target-------------");
	-+agent_mode(exploration);
	-stock(_,_,_);
	-current_task(_,_,_,_,_,_);
	.
+!attach_failed: true<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent attach failed--------failed------------");
	-+agent_mode(exploration);
	-stock(_,_,_);
	-current_task(_,_,_,_,_,_);
	.
+!rotate_failed(Params): true<-
	.member(Rdir,Params);
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent rotate failed--------failed------------");

	if(Rdir == cw){
		!update_block_dir(ccw);
	}elif(Rdir == ccw){
		!update_block_dir(cw);
	};
	.
+!detach_failed: true<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent detach failed--------failed------------");
	.
+!detach_failed_target: true<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent detach failed--------failed_target------------");
	.


