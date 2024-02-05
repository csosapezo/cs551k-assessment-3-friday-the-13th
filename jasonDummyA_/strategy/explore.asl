@move_random_point[atomic]
+!move_random_point: random_point(RX,RY) & agent_location(MyN,MyX,MyY)  & check_dir_on(RX-MyX,RY-MyY,Dir) & .random(R1) & .random(R2) & .random(R3) & get_random_pointX(R1,X1) & get_random_pointY(R2,R3,X1,X,Y) & .count(block(_,_),N)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","agent move_random_point Dir=",Dir,",RX=",RX,",RY=",RY,",N=",N);
	//.print("[",H,":",M,":",S,":",MS,"] ","agent move_random_point Dir=",Dir,",MyX=",MyX,",MyY=",MyY);
	//.print("[",H,":",M,":",S,":",MS,"] ","agent move_random_point Dir=",Dir,",RX-MyX=",RX-MyX,",RY-MyY=",RY-MyY);
	if (Dir == null){
		-+random_point(X+MyX,Y+MyY);
		!move_random_point;
		//skip;
	}else{
		if(Dir == n){
			-+agent_location(9,MyX,MyY-1);
		}elif(Dir == e){
			-+agent_location(10,MyX+1,MyY);
		}elif(Dir == s){
			-+agent_location(11,MyX,MyY+1);
		}elif(Dir == w){
			-+agent_location(12,(MyX-1),MyY);
		};
		move(Dir);
	};
	.
    
@move_random_point2[atomic]
+!move_random_point: location(goal,_,GoalX,GoalY,_) & agent_location(MyN,MyX,MyY) & task_base(N, D, R,TX,TY,B) & block(Bdir,B) & not current_task(_,_,_,_,_,_) & not conflict_task(N)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","the agent receive a new task ",N,",D=", D,",R=", R,",B=", B,",X=", TX,",Y=",TY);
	.broadcast(tell,conflict_task(N));
	-task_base(N, D, R,TX,TY,B);
	+current_task(N, D, R,TX,TY, B);
	-+agent_mode(find_goal);
	.print("[",H,":",M,":",S,":",MS,"] ","5--------------------------- agent start task=",N);
	.
	
@plan[atomic] 
+!move_random : .random(RandomNumber) & random_dir([n,s,e,w] ,RandomNumber,Dir) & agent_location(MyN,MyX,MyY)<-
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

