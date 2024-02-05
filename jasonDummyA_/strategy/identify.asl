// +thing(X, Y, entity, Details) : agent_location(MyN,MyX,MyY) & get_dir(X,Y,Dir)<-
// 	.time(H,M,S,MS);
// 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",entity,",Details=",Details,",X=",Y,",Y=",Y);
// 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",entity,",Details=",Details,",MyX=",MyX,",MyY=",MyY);
// 	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",entity,",Details=",Details,",(MyX+X)=",(MyX+X),",(MyY+Y)=",(MyY+Y));
// 	// +location(block,Details,(MyX+X),(MyY+Y));
//     detach(Dir);
// 	.


+thing(X, Y, entity, Details) : agent_location(MyN,MyX,MyY) & get_dir(X,Y,Dir)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",entity,",Details=",Details,",X=",Y,",Y=",Y);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",entity,",Details=",Details,",MyX=",MyX,",MyY=",MyY);
	.print("[",H,":",M,":",S,":",MS,"] ","the agent sees a ",entity,",Details=",Details,",(MyX+X)=",(MyX+X),",(MyY+Y)=",(MyY+Y));
	// +location(block,Details,(MyX+X),(MyY+Y));
    // detach(Dir);
	.