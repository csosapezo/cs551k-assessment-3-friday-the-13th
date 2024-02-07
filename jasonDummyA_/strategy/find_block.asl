
// Q1
// [connectionA4] [8:8:3:861] current mode find_blocks
// [connectionA4] No fail event was generated for +!move_to(1,2,b1)[source(self)]
// [connectionA4] 
// intention 857: 
//     +!find_dispensers(b1,1,2)[source(self)] <- ... !move_to(X,Y,Dtype) / {X=1, Y=2, Dtype=b1}
//     +!find_blocks(b1,1,2)[source(self)] <- ... !find_dispensers(Btype,X,Y) / {Btype=b1, X=1, Y=2}
//     +!action_pipe[source(self)] <- ... !find_blocks(Btype,X,Y) / {S=3, Btype=b1, MS=861, X=1, H=8, Y=2, M=8}
//     +actionID(69)[entity(connectionA4),source(percept)] <- ... !action_pipe / {ID=69}
// [connectionA4] Found a goal for which there is no applicable plan: +!move_to(1,2,b1)[source(self)]



//Q2
//[connectionA1] No fail event was generated for +!stock[source(self)]
// [connectionA1] 
// intention 2451: 
//     +!rotate_direction(task116,419,10,0,-1,b0)[source(self)] <- ... !stock; .time(H,M,S,MS); .print("[",H,":",M,":",S,":",MS,"] ","agent submit the task=",N,",CurrentDir=",CurrentDir) / {_9791=b0, _9790=1, B=b0, _15=419, _9793=find_goal, _14=task116, _9792=s, D=419, TX=0, _17=0, TY=-1, _16=10, _19=b0, _18=1, _9788=10, TargetDir=s, _9787=419, _9789=0, N=task116, _9786=task116, R=10, CurrentDir=s}
//     +!move_on(3,-3)[source(self)] <- ... !rotate_direction(N,D,R,TX,(-TY),B) / {B=b0, MyN=5, D=419, TX=0, TY=1, MS=312, H=8, MyY=-3, Dir=null, MyX=3, M=29, N=task116, R=10, S=34, X=3, Y=-3}
//     +!action_pipe[source(self)] <- ... !move_on(GoalX,GoalY) / {R=10, S=34, D=419, TX=0, TY=1, MS=302, H=8, GoalX=3, GoalY=-3, M=29, N=task116, Req=b0}
//     +actionID(229)[entity(connectionA1),source(percept)] <- ... !action_pipe / {ID=229}
// [connectionA1] Found a goal for which there is no applicable plan: +!stock[source(self)]



// the agent finds a block given a block type
+!find_blocks(Btype,X,Y) : true <-
	!find_dispensers(Btype,X,Y);
	.

+!find_dispensers(Dtype,X,Y) : true<-
	!move_to(X,Y,Dtype);
	.

@move_to[atomic] 
+!move_to(X,Y,Btype): agent_location(MyN,MyX,MyY) & check_dir((X-MyX),(Y-MyY),Dir)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","the agent move to the dispenser Dir=:",Dir,",MyX=",MyX,",MyY=",MyY);
	//.print("[",H,":",M,":",S,":",MS,"] ","the agent move to the dispenser Dir=",Dir,",X=",X,",Y=",Y);
	//.print("[",H,":",M,":",S,":",MS,"] ","the agent move to the dispenser Dir=",Dir,",(X-MyX)=",(X-MyX),",(Y-MyY)=",(Y-MyY));
	if(Dir == null){
		.print("agent finished moving to ",",X=",X,",Y=",Y);
		!check_direction(X,Y,Btype);
		//!request_block(X,Y,Btype);
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

+!check_direction(X,Y,Btype) : agent_location(MyN,MyX,MyY) & get_dir(X-MyX,Y-MyY,Dir1) & ava_dir(Dir1)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent check_direction Dir1=:",Dir1,",MyX=",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent check_direction Dir1:",Dir1,",X=",X,",Y=",Y);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent check_direction Dir1=:",Dir1,",",(X-MyX),",",(Y-MyY));
	!request_block(X,Y,Btype);
	.
@check_direction[atomic]
+!check_direction(X,Y,Btype) :  agent_location(MyN,MyX,MyY) & get_dir(X-MyX,Y-MyY,Dir1) & get_ava_dir(Dir2) & rotate_dir(Dir1,Dir2,RDir) & not Dir1 == Dir2 <-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent rotate Dir1=",Dir1,",Dir2=",Dir2,",RDir=",RDir,",X=",X,",Y=",Y);
	!update_block_dir(RDir);
	!update_ava_dir(RDir);
	rotate(RDir);
	.

@request_block[atomic]
+!request_block(X,Y,Btype) : agent_location(MyN,MyX,MyY) & get_dir((X-MyX),(Y-MyY),Dir) & not block(Dir,Btype) & not location(block,Btype,X,Y)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","1the agent request_block X:",X,",Y=",Y,",Dir=",Dir);
	.print("[",H,":",M,":",S,":",MS,"] ","1the agent request_block MyX:",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","1the agent request_block X-MyX:",(X-MyX),",Y-MyY=",(Y-MyY));
	.print("[",H,":",M,":",S,":",MS,"] ","agent request block:",Dir);
	+location(block,Btype,X,Y);
	request(Dir);
	.

+!request_block(X,Y,Btype) : agent_location(MyN,MyX,MyY) & get_dir((X-MyX),(Y-MyY),Dir) & not block(Dir,Btype) & location(block,Btype,X,Y)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","2the agent request_block X:",X,",Y=",Y,",Dir=",Dir);
	.print("[",H,":",M,":",S,":",MS,"] ","2the agent request_block MyX:",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","2the agent request_block X-MyX:",(X-MyX),",Y-MyY=",(Y-MyY));
	!attach_block(X,Y,Btype);
	.

@attach_block[atomic] 
+!attach_block(X,Y,Btype) : agent_location(MyN,MyX,MyY) & location(block,Btype,X,Y) & get_dir((X-MyX),(Y-MyY),Dir)<-
	.time(H,M,S,MS); 	.print("[",H,":",M,":",S,":",MS,"] ","agent finished find_blocks Btype=",Btype,",X=",X,",Y=",Y);

	-+agent_mode(exploration);
	+have_block(Dir,B);
	-ava_dir(Dir);
	-stock(_,_,_);
	-location(block,Btype,X,Y);
	+block(Dir,Btype);
	attach(Dir);
	.



@update_block_dir1[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(e,B2) & block(s,B3) & block(w,B4)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(e,B2);
		+block(s,B2);
		-block(s,B3);
		+block(w,B3);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(w,B2);
		+block(s,B2);
		-block(s,B3);
		+block(e,B3);
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir2[atomic]
+!update_block_dir(RDir) : block(w,B4)<-
	if(RDir== cw){
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(w,B2);
		+block(s,B2);
	};
	.
@update_block_dir3[atomic]
+!update_block_dir(RDir) : block(s,B3) <-
	if(RDir== cw){
		-block(s,B3);
		+block(w,B3);
	}elif(RDir == ccw){
		-block(s,B3);
		+block(e,B3);
	};
	.
@update_block_dir4[atomic]
+!update_block_dir(RDir) : block(e,B2)<-
	if(RDir== cw){
		-block(e,B2);
		+block(s,B2);
	}elif(RDir == ccw){
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir5[atomic]
+!update_block_dir(RDir) : block(n,B1)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
	};
	.
@update_block_dir6[atomic]
+!update_block_dir(RDir) : block(e,B2) & block(w,B4)<-
	if(RDir== cw){
		-block(e,B2);
		+block(s,B2);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(w,B2);
		+block(s,B2);
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir7[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(s,B3)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(s,B3);
		+block(w,B3);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(s,B3);
		+block(e,B3);
	};
	.
@update_block_dir8[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(w,B4)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(w,B2);
		+block(s,B2);
	};
	.
@update_block_dir9[atomic]
+!update_block_dir(RDir) : block(s,B3) & block(w,B4)<-
	if(RDir== cw){
		-block(s,B3);
		+block(w,B3);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(w,B2);
		+block(s,B2);
		-block(s,B3);
		+block(e,B3);
	};
	.
@update_block_dir10[atomic]
+!update_block_dir(RDir) : block(e,B2) & block(s,B3)<-
	if(RDir== cw){
		-block(e,B2);
		+block(s,B2);
		-block(s,B3);
		+block(w,B3);
	}elif(RDir == ccw){
		-block(s,B3);
		+block(e,B3);
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir11[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(e,B2)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(e,B2);
		+block(s,B2);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir12[atomic]
+!update_block_dir(RDir) : block(e,B2) & block(s,B3) & block(w,B4)<-
	if(RDir== cw){
		-block(e,B2);
		+block(s,B2);
		-block(s,B3);
		+block(w,B3);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(w,B2);
		+block(s,B2);
		-block(s,B3);
		+block(e,B3);
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir13[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(s,B3) & block(w,B4)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(s,B3);
		+block(w,B3);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(w,B2);
		+block(s,B2);
		-block(s,B3);
		+block(e,B3);
	};
	.
@update_block_dir14[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(e,B2) & block(w,B4)<-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(e,B2);
		+block(s,B2);
		-block(w,B4);
		+block(n,B4);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(w,B2);
		+block(s,B2);
		-block(e,B4);
		+block(n,B4);
	};
	.
@update_block_dir15[atomic]
+!update_block_dir(RDir) : block(n,B1) & block(e,B2) & block(s,B3) <-
	if(RDir== cw){
		-block(n,B1);
		+block(e,B1);
		-block(e,B2);
		+block(s,B2);
		-block(s,B3);
		+block(w,B3);
	}elif(RDir == ccw){
		-block(n,B1);
		+block(w,B1);
		-block(s,B3);
		+block(e,B3);
		-block(e,B4);
		+block(n,B4);
	};
	.
	
@update_ava_dir1[atomic]
+!update_ava_dir(RDir): ava_dir(n) & ava_dir(e) & ava_dir(s)<-
	if(RDir== cw){
		-ava_dir(n);
		+ava_dir(w);
	}elif(RDir == ccw){
		-ava_dir(s);
		+ava_dir(w);
	};
	.
@update_ava_dir2[atomic]
+!update_ava_dir(RDir): ava_dir(e) & ava_dir(s) & ava_dir(w)<-
	if(RDir== cw){
		-ava_dir(e);
		+ava_dir(n);
	}elif(RDir == ccw){
		-ava_dir(w);
		+ava_dir(n);
	};
	.
@update_ava_dir3[atomic]
+!update_ava_dir(RDir): ava_dir(s) & ava_dir(w) & ava_dir(n)<-
	if(RDir== cw){
		-ava_dir(s);
		+ava_dir(e);
	}elif(RDir == ccw){
		-ava_dir(n);
		+ava_dir(e);
	};
	.
@update_ava_dir4[atomic]
+!update_ava_dir(RDir): ava_dir(w) & ava_dir(n) & ava_dir(e)<-
	if(RDir== cw){
		-ava_dir(w);
		+ava_dir(s);
	}elif(RDir == ccw){
		-ava_dir(e);
		+ava_dir(s);
	};
	.
@update_ava_dir5[atomic]
+!update_ava_dir(RDir): ava_dir(n) & ava_dir(e)<-
	if(RDir== cw){
		-ava_dir(n);
		+ava_dir(s);
	}elif(RDir == ccw){
		-ava_dir(e);
		+ava_dir(w);
	};
	.
@update_ava_dir6[atomic]
+!update_ava_dir(RDir): ava_dir(e) & ava_dir(s)<-
	if(RDir== cw){
		-ava_dir(e);
		+ava_dir(w);
	}elif(RDir == ccw){
		-ava_dir(s);
		+ava_dir(n);
	};
	.
@update_ava_dir7[atomic]
+!update_ava_dir(RDir): ava_dir(s) & ava_dir(w)<-
	if(RDir== cw){
		-ava_dir(s);
		+ava_dir(n);
	}elif(RDir == ccw){
		-ava_dir(w);
		+ava_dir(e);
	};
	.
@update_ava_dir8[atomic]
+!update_ava_dir(RDir): ava_dir(w) & ava_dir(n)<-
	if(RDir== cw){
		-ava_dir(w);
		+ava_dir(e);
	}elif(RDir == ccw){
		-ava_dir(n);
		+ava_dir(s);
	};
	.
@update_ava_dir9[atomic]
+!update_ava_dir(RDir): ava_dir(n) & ava_dir(s)<-
	-ava_dir(n);
	-ava_dir(s);
	+ava_dir(e);
	+ava_dir(w);
	.
@update_ava_dir10[atomic]
+!update_ava_dir(RDir): ava_dir(e) & ava_dir(w)<-
	-ava_dir(e);
	-ava_dir(w);
	+ava_dir(n);
	+ava_dir(s);
	.
@update_ava_dir11[atomic]
+!update_ava_dir(RDir): ava_dir(n)<-
	if(RDir== cw){
		-ava_dir(n);
		+ava_dir(e);
	}elif(RDir == ccw){
		-ava_dir(n);
		+ava_dir(w);
	};
	.
@update_ava_dir12[atomic]
+!update_ava_dir(RDir): ava_dir(e)<-
	if(RDir== cw){
		-ava_dir(e);
		+ava_dir(s);
	}elif(RDir == ccw){
		-ava_dir(e);
		+ava_dir(n);
	};
	.
@update_ava_dir13[atomic]
+!update_ava_dir(RDir): ava_dir(s)<-
	if(RDir== cw){
		-ava_dir(s);
		+ava_dir(w);
	}elif(RDir == ccw){
		-ava_dir(s);
		+ava_dir(e);
	};
	.
@update_ava_dir14[atomic]
+!update_ava_dir(RDir): ava_dir(w)<-
	if(RDir== cw){
		-ava_dir(w);
		+ava_dir(n);
	}elif(RDir == ccw){
		-ava_dir(w);
		+ava_dir(s);
	};
	.

