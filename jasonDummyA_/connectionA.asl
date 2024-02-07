/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.print("hello massim world.").

// +step(X) : true <-
// 	.print("Received step percept.").

//这里是代理在dispenser旁边的时候做的动作
+step(X) : thing(0,1,dispenser,_) <-
	// request(s).
	// rotate(n).
	.print("Received step percept.").

+step(X) : thing(0,-1,dispenser,_) <-
	// request(n).
	// rotate(s).
	.print("Received step percept.").

+step(X) : thing(1,0,dispenser,_) <-
	// request(e).
	// rotate(w).
	.print("Received step percept.").

+step(X) : thing(-1,0,dispenser,_) <-
	// request(w).
	// rotate(e).
	.print("Received step percept.").

+actionID(X) : true <- 
	.print("Determining my action");
	!move_random.
//	skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	move(Dir).