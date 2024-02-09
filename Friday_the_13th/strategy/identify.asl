/*  This module is used to implement identification between agents. */


// 【thing(X, Y, entity, Details)】 Currently only realizes discovery of an agent in the same team
+thing(X, Y, entity, Details) : self_location(X0,Y0) & get_dir(X,Y,Dir)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","The agent sees a ",entity,",Details=",Details,",X=",Y,",Y=",Y);
	.print("[",H,":",M,":",S,":",MS,"] ","The agent sees a ",entity,",Details=",Details,",MyX=",X0,",MyY=",Y0);
	.print("[",H,":",M,":",S,":",MS,"] ","The agent sees a ",entity,",Details=",Details,",(MyX+X)=",(X0+X),",(MyY+Y)=",(Y0+Y)).