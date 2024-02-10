/* This module encapsulates the tool methods */

// 【available_dir】 Define the initial available direction beliefs as well as define a method to automatically get the available directions.
available_dir(e).
available_dir(s).
available_dir(w).
available_dir(n).

// 【get_dir】 Define methods for obtaining directions for the four coordinates directly adjacent to the agent, as well as directions for other non-adjacent coordinates
get_dir(0,-1,n).
get_dir(0,1,s).
get_dir(1,0,e).
get_dir(-1,0,w).
get_dir(X,Y,e) :- (X > 1 | X < -1) & (Y > 1 | Y < -1).
get_dir(0, 0, null).

// 【get_dir_on】 Define methods for obtaining directions for the four coordinates directly adjacent to the agent, as well as directions for other non-adjacent coordinates. However, this method is mainly used for find_goal.
get_dir_on(0,-1,s).
get_dir_on(0,1,n).
get_dir_on(1,0,w).
get_dir_on(-1,0,e).
get_dir_on(X,Y,null) :- (X > 1 | X < -1) & (Y > 1 | Y < -1).

// 【suggested_dir】 Give the agent a suggested direction of travel based on the different relative positions of the target and the agent.
suggested_dir(X,Y,e):- X > 1.
suggested_dir(X,Y,w):- X < -1.
suggested_dir(X,Y,s):- Y > 1.
suggested_dir(X,Y,n):- Y < -1.
suggested_dir(1,1,e).
suggested_dir(-1,1,w).
suggested_dir(1,-1,e).
suggested_dir(-1,-1,w).
suggested_dir(0,1,null).
suggested_dir(0,-1,null).
suggested_dir(1,0,null).
suggested_dir(-1,0,null).
suggested_dir(0,0,e).

// 【suggested_dir_on】 Give the agent a suggested direction of travel based on the different relative positions of the target and the agent. But this method is only used for find_goal.
suggested_dir_on(X,Y,w) :- X < 0.
suggested_dir_on(X,Y,e) :- X > 0.
suggested_dir_on(X,Y,n) :- Y < 0.
suggested_dir_on(X,Y,s) :- Y > 0.
suggested_dir_on(X,0,w) :- X < 0.
suggested_dir_on(X,0,e) :- X > 0.
suggested_dir_on(0,Y,n) :- Y < 0.
suggested_dir_on(0,Y,s) :- Y > 0.
suggested_dir_on(0,0,null).

// 【lateral】Give the lateral directions of each direction
lateral([n, s], Dir) :- Dir = w | Dir = e.
lateral([w, e], Dir) :- Dir = n | Dir = s.
// 【random_lateral_dir】give a random direction from 2 laterals
random_lateral_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.5 & .nth(0,DirList,Dir)) | (.nth(1,DirList,Dir)).

// 【boundary】Find boundary coordinate
boundary(X, Y, Dir, X) :- Dir = e | Dir = w.
boundary(X, Y, Dir, Y) :- Dir = n | Dir = s.

// 【rotate_dir】 Given a start direction and an end direction, this method will provide a rotation method (cw/ccw).
rotate_dir(n,e,ccw).
rotate_dir(n,w,cw).
rotate_dir(e,s,ccw).
rotate_dir(e,n,cw).
rotate_dir(s,w,ccw).
rotate_dir(s,e,cw).
rotate_dir(w,n,ccw).
rotate_dir(w,s,cw).
rotate_dir(n,n,null).
rotate_dir(e,e,null).
rotate_dir(s,s,null).
rotate_dir(w,w,null).

needed_rotate_dir(DirA, DirB, RDir) :- rotate_dir(DirA, DirB, RDir).
needed_rotate_dir(n,s,ccw).
needed_rotate_dir(e,w,ccw).
needed_rotate_dir(s,n,RDir).
needed_rotate_dir(w,e,RDir).

get_random_pointX(RandomNumber,X) :- (RandomNumber <= 0.16 & X = 0) | (RandomNumber <= 0.32 & X = 1) | (RandomNumber <= 0.48 & X=2) | (RandomNumber <= 0.64 & X=3) | (RandomNumber <= 0.80 & X=4) | (RandomNumber <= 1 & X=5).
get_random_pointY(R1,R2,X1,X,Y) :- (R1 <= 0.5 & R2 <= 0.5 & X = X1*-1 & Y = (5-X1)*-1) | (R1 <= 0.5 & R2 > 0.5 & X = X1 & Y = (5-X1)*-1) | (R1 > 0.5 & R2 <= 0.5 & X = X1*-1 & Y = 5-X1) |(R1 > 0.5 & R2 > 0.5 & X = X1 & Y = 5-X1).

inspect_dispenser(R1,X,Y,TX,TY) :- (RandomNumber <= 0.5 & TX = X -1 & TY = Y) | (RandomNumber <= 1 & TX = X & TY = Y-1).

// 【opposite_rotation】Get opposite rotation direction
opposite_rotation(cw, ccw).
opposite_rotation(ccw, cw).

// 【count_location(B,N)】 Given the object type of the query, query the number of beliefs of that type in the belief base.
count_location(B,N) :- .count(location(B,_,_,_),N).

// 【random_dir】 Given a list of candidate directions, randomly select a direction from the list.
random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).
