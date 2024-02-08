@move_on[atomic] 
+!move_on(X,Y): agent_location(MyN,MyX,MyY) & check_dir_on(X-MyX,Y-MyY,Dir) & current_task(N, D, R,TX,TY, B)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent move to the goal X:",X,",X=",Y);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent move to the goal MyX:",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent move to the goal (X-MyX):",(X-MyX),",(Y-MyY)=",(Y-MyY),",Dir=",Dir);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent move to current task N=",N,",D=", D,",R=", R,",TX=",TX,",TY=",TY,",B=", B);
	if (Dir == null){
		!rotate_direction(N, D, R,TX,-TY,B);
	}else{
		if(Dir == n){
			-+agent_location(5,MyX,MyY-1);
		}elif(Dir == e){
			-+agent_location(6,MyX+1,MyY);
		}elif(Dir == s){
			-+agent_location(7,MyX,MyY+1);
		}elif(Dir == w){
			-+agent_location(8,(MyX-1),MyY);
		};
		move(Dir);
	};
	.

@rotate_direction1[atomic]
+!rotate_direction(N, D, R,TX,TY,B) : get_dir_on(TX,TY,TargetDir) & block(CurrentDir,B) & not (TargetDir == CurrentDir) & rotate_dir(TargetDir,CurrentDir,RDir) <-
	!update_block_dir(RDir);
	!update_ava_dir(RDir);
	rotate(RDir);
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","agent rotate TargetDir=",TargetDir,",CurrentDir=",CurrentDir,",RDir=",RDir,",X=",TX,",Y=",TY);
	.

@rotate_direction2[atomic]
+!rotate_direction(N, D, R,TX,TY,B) : get_dir_on(TX,TY,TargetDir) & block(TargetDir,B) <-
	-current_task(_, _, _,_,_, _);
	-block(CurrentDir,B);
	+ava_dir(CurrentDir);
	submit(N);
	-+agent_mode(exploration);
	!stock;
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","agent submit the task=",N,",CurrentDir=",CurrentDir);
	.


