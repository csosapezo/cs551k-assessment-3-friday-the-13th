{ include("explore.asl") }


/* Initial beliefs and rules */
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).
random_dir_2(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.5 & .nth(0,DirList,Dir)) | (.nth(1,DirList,Dir)).
self_pos(0, 0).
mode(explore).

opposite(n) :- s.
opposite(s) :- n.
opposite(w) :- e.
opposite(e) :- w.

dir(0,-1,Dir) :- Dir = n.
dir(0,1,Dir) :- Dir = s.
dir(1,0,Dir) :- Dir = e.
dir(-1,0,Dir) :- Dir = w.

lateral([n, s], Dir) :- Dir = w | Dir = e.
lateral([w, e], Dir) :- Dir = n | Dir = s.

/* Initial goals */

/* Plans */

+step(X): mode(explore) & self_pos(X0, Y0) & lastAction(move) & lastActionResult(success)
& lastActionParams([Dir]) & dir(X1, Y1, Dir) <-
    .print("explore ", Dir, ". Agent at ", X0+X1, ", ", Y0+Y1);
    -self_pos(X0, Y0);
	+self_pos(X0+X1, Y0+Y1);
    !add;
	move(Dir).

+step(X): mode(explore) & lastAction(move)
& lastActionParams([Dir]) & dir(X1, Y1, Dir)
& lateral(New, Dir) & .random(RandomNumber) & random_dir_2(New,RandomNumber,NewDir) <-
	.print("now explore ", NewDir);
	move(NewDir).
^
+step(X): mode(explore) & .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir) <-
    !add;
    .print("start exploring ", Dir);
	move(Dir).


+!move_to(0, 0) : true.

+!move_to(X, 0): X > 0 <- .print("Move E."); move(e); !move_to(X - 1, 0).

+!move_to(X, 0): X < 0 <- .print("Move W."); move(w); !move_to(X + 1, 0).

+!move_to(X, Y): Y > 0 <- .print("Move S."); move(s); !move_to(X, Y - 1).

+!move_to(X, Y): Y < 0 <- .print("Move N."); move(n); !move_to(X, Y + 1).

//	skip.

+!move_random : .random(RandomNumber) & random_dir([n,s,e,w],RandomNumber,Dir)
<-	.print("Changing direction to ", Dir); move(Dir).