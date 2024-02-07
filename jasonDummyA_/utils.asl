get_ava_dir(Dir) :- (ava_dir(e) & Dir = e)|(ava_dir(s) & Dir = s)|(ava_dir(w) & Dir = w)|(ava_dir(n) & Dir = n).

get_dir(0,-1,Dir) :- Dir = n.
get_dir(0,1,Dir) :- Dir = s.
get_dir(1,0,Dir) :- Dir = e.
get_dir(-1,0,Dir) :- Dir = w.
get_dir(X,Y,e) :- (X > 1 | X < -1) & (Y > 1 | Y < -1).

get_dir_on(0,-1,Dir) :- Dir = s.
get_dir_on(0,1,Dir) :- Dir = n.
get_dir_on(1,0,Dir) :- Dir = w.
get_dir_on(-1,0,Dir) :- Dir = e.
get_dir_on(X,Y,null) :- (X > 1 | X < -1) & (Y > 1 | Y < -1).


//-----------------------------------------------

// check_dir(X,Y,Dir):- (Dir = e& X> 1).
// check_dir(X,Y,Dir):- (Dir = w& X< -1).
// check_dir(X,Y,Dir):- (Dir = s& Y> 1).
// check_dir(X,Y,Dir):- (Dir = n& Y< -1).
// check_dir(X,Y,Dir):- (Dir = e& X>0 & Y=1).
// check_dir(X,Y,Dir):- (Dir = w& X<0 & Y=1).
// check_dir(X,Y,Dir):- (Dir = e& X>0 & Y=-1).
// check_dir(X,Y,Dir):- (Dir = w& X<0 & Y=-1). 
// check_dir(X,Y,Dir):- (Dir = s& X=1 & Y>0).
// check_dir(X,Y,Dir):- (Dir = n& X=1 & Y<0).
// check_dir(X,Y,Dir):- (Dir = s& X=-1 & Y>0).
// check_dir(X,Y,Dir):- (Dir = s& X=-1& Y<0).
// check_dir(X,Y,Dir):- (Dir = e& X>1 &Y=0).
// check_dir(X,Y,Dir):- (Dir = w& X< -1 &Y=0).
// check_dir(X,Y,Dir):- (Dir = s& X=0 &Y>1).
// check_dir(X,Y,Dir):- (Dir = n& X=0 &Y< -1).
// check_dir(0,1,Dir) :- Dir = null.
// check_dir(0,-1,Dir) :- Dir = null.
// check_dir(1,0,Dir) :- Dir = null.
// check_dir(-1,0,Dir) :- Dir = null.


check_dir(X,Y,Dir):- (Dir = e& X> 1).
check_dir(X,Y,Dir):- (Dir = w& X< -1).
check_dir(X,Y,Dir):- (Dir = s& Y> 1).
check_dir(X,Y,Dir):- (Dir = n& Y< -1).
check_dir(X,Y,Dir):- (Dir = e& X>0 & Y=1).
check_dir(X,Y,Dir):- (Dir = w& X<0 & Y=1).
check_dir(X,Y,Dir):- (Dir = e& X>0 & Y=-1).
check_dir(X,Y,Dir):- (Dir = w& X<0 & Y=-1). 
check_dir(X,Y,Dir):- (Dir = s& X=1 & Y>0).
check_dir(X,Y,Dir):- (Dir = n& X=1 & Y<0).
check_dir(X,Y,Dir):- (Dir = s& X=-1 & Y>0).
check_dir(X,Y,Dir):- (Dir = s& X=-1& Y<0).
check_dir(X,Y,Dir):- (Dir = e& X>1 &Y=0).
check_dir(X,Y,Dir):- (Dir = w& X< -1 &Y=0).
check_dir(X,Y,Dir):- (Dir = s& X=0 &Y>1).
check_dir(X,Y,Dir):- (Dir = n& X=0 &Y< -1).
check_dir(X,Y,Dir):- (Dir = null & X=0&Y=1).
check_dir(X,Y,Dir):- (Dir = null & X=0&Y=-1).
check_dir(X,Y,Dir):- (Dir = null & X=1&Y=0).
check_dir(X,Y,Dir):- (Dir = null & X=-1&Y=0).

check_dir_on(X,Y,Dir) :- (Dir=w & X < 0).
check_dir_on(X,Y,Dir) :- (Dir=e & X > 0).
check_dir_on(X,Y,Dir) :- (Dir=n & Y < 0).
check_dir_on(X,Y,Dir) :- (Dir=s & Y > 0).
check_dir_on(X,Y,Dir) :- (Dir=w & X < 0 & Y=0).
check_dir_on(X,Y,Dir) :- (Dir=e & X > 0 & Y=0).
check_dir_on(X,Y,Dir) :- (X=0 & Y < 0 & Dir=n).
check_dir_on(X,Y,Dir) :- (X=0 & Y > 0 & Dir=s).
check_dir_on(X,Y,Dir) :- (X=0 & Dir = null & Y=0).


// check_dir(X,Y,w) :- X < -1.
// check_dir(X,Y,e) :- X > 1.
// check_dir(X,Y,n) :- Y > 1.
// check_dir(X,Y,s) :- Y < -1.

// check_dir(X,-1,w) :- X < 0.
// check_dir(X,-1,e) :- X > 0.
// check_dir(X,1,w) :- X < 0.
// check_dir(X,1,e) :- X > 0.
// check_dir(X,0,w) :- X < -1.
// check_dir(X,0,e) :- X > -1.

// check_dir(-1,Y,n) :- Y < 0.
// check_dir(-1,Y,s) :- Y > 0.
// check_dir(1,Y,s) :- Y > 0.
// check_dir(1,Y,n) :- Y < 0.
// check_dir(0,Y,n) :- Y < -1.
// check_dir(0,Y,s) :- Y > 1.

// check_dir(0,1,Dir) :- Dir = null.
// check_dir(0,-1,Dir) :- Dir = null.
// check_dir(1,0,Dir) :- Dir = null.
// check_dir(-1,0,Dir) :- Dir = null.

// check_dir_on(X,Y,w) :- X < 0.
// check_dir_on(X,Y,e) :- X > 0.
// check_dir_on(X,Y,n) :- Y < 0.
// check_dir_on(X,Y,s) :- Y > 0.
// check_dir_on(X,0,w) :- X < 0.
// check_dir_on(X,0,e) :- X > 0.
// check_dir_on(0,Y,n) :- Y < 0.
// check_dir_on(0,Y,s) :- Y > 0.
// check_dir_on(0,0,Dir) :- Dir = null.

//---------------------------------------------

// check_dir(X,Y,w) :- X < -1.
// check_dir(X,Y,e) :- X > 1.
// check_dir(-1,Y,n) :- Y < 0.
// check_dir(-1,Y,s) :- Y > 0.
// check_dir(1,Y,n) :- Y < 0.
// check_dir(0,Y,n) :- Y < -1.
// check_dir(0,Y,s) :- Y > 1.
// check_dir(0,1,Dir) :- Dir = null.
// check_dir(0,-1,Dir) :- Dir = null.
// check_dir(1,0,Dir) :- Dir = null.
// check_dir(-1,0,Dir) :- Dir = null.

// check_dir_on(X,Y,w) :- X < 0.
// check_dir_on(X,Y,e) :- X > 0.
// check_dir_on(0,Y,n) :- Y < 0.
// check_dir_on(0,Y,s) :- Y > 0.
// check_dir_on(0,0,Dir) :- Dir = null.



rotate_dir(n,e,RDir) :- RDir = ccw.
rotate_dir(n,s,RDir) :- RDir = ccw.
rotate_dir(n,w,RDir) :- RDir = cw.
rotate_dir(e,s,RDir) :- RDir = ccw.
rotate_dir(e,w,RDir) :- RDir = ccw.
rotate_dir(e,n,RDir) :- RDir = cw.
rotate_dir(s,w,RDir) :- RDir = ccw.
rotate_dir(s,n,RDir) :- RDir = ccw.
rotate_dir(s,e,RDir) :- RDir = cw.
rotate_dir(w,n,RDir) :- RDir = ccw.
rotate_dir(w,e,RDir) :- RDir = ccw.
rotate_dir(w,s,RDir) :- RDir = cw.
rotate_dir(n,n,RDir) :- RDir = null.
rotate_dir(e,e,RDir) :- RDir = null.
rotate_dir(s,s,RDir) :- RDir = null.
rotate_dir(w,w,RDir) :- RDir = null.

get_req_type(Req,X,Y,Btype) :- .member(req(X,Y,Btype),Req).

count_location(B,N) :- .count(location(B,_,_,_),N).

count_block(Btype,N) :- .count(block(_,Btype),N).
count_block_all(N) :- .count(block(_,_),N).

test_block(Btype,X,Y,N) :- .count(location(block,Btype,X,Y),N).

random_dir(DirList,RandomNumber,Dir) :- (RandomNumber <= 0.25 & .nth(0,DirList,Dir)) | (RandomNumber <= 0.5 & .nth(1,DirList,Dir)) | (RandomNumber <= 0.75 & .nth(2,DirList,Dir)) | (.nth(3,DirList,Dir)).

update_dir(w,cw,Dir2) :- Dir2 = n.
update_dir(n,cw,Dir2) :- Dir2 = e.
update_dir(e,cw,Dir2) :- Dir2 = s.
update_dir(s,cw,Dir2) :- Dir2 = w.
update_dir(w,ccw,Dir2) :- Dir2 = s.
update_dir(n,ccw,Dir2) :- Dir2 = w.
update_dir(e,ccw,Dir2) :- Dir2 = n.
update_dir(s,ccw,Dir2) :- Dir2 = e.

get_random_pointX(RandomNumber,X) :- (RandomNumber <= 0.16 & X = 0) | (RandomNumber <= 0.32 & X = 1) | (RandomNumber <= 0.48 & X=2) | (RandomNumber <= 0.64 & X=3) | (RandomNumber <= 0.80 & X=4) | (RandomNumber <= 1 & X=5).
get_random_pointY(R1,R2,X1,X,Y) :- (R1 <= 0.5 & R2 <= 0.5 & X = X1*-1 & Y = (5-X1)*-1) | (R1 <= 0.5 & R2 > 0.5 & X = X1 & Y = (5-X1)*-1) | (R1 > 0.5 & R2 <= 0.5 & X = X1*-1 & Y = 5-X1) |(R1 > 0.5 & R2 > 0.5 & X = X1 & Y = 5-X1).

inspect_dispenser(R1,X,Y,TX,TY) :- (RandomNumber <= 0.5 & TX = X -1 & TY = Y) | (RandomNumber <= 1 & TX = X & TY = Y-1).

get_next_dispenser(Dtype,X,Y) :-  dispenser_queue(DQ) & .min(DQ,DSeq) & location(dispenser,Dtype,X,Y).  
get_next_goal(X,Y) :-  dispenser_queue(GQ) & .min(GQ,GSeq) & location(goal,_,X,Y,_).  