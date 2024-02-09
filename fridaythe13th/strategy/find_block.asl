/* This module is used to manage the agent's strategy for finding blocks. */

// 【!move_to】 Given the coordinates of a dispenser, navigate through the target by querying suggested_dir for a suggested direction of travel.
@move_to_dispenser_check[atomic] 
+!move_to_dispenser(X,Y,Type): self_location(X0,Y0) & suggested_dir((X-X0),(Y-Y0),null) <-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Agent already in ",X,",",Y);
	!check_direction(X,Y,Type).

@move_to_dispenser_move[atomic] 
+!move_to_dispenser(X,Y,Type): self_location(X0,Y0) & suggested_dir((X-X0),(Y-Y0),Dir)
    & not(Dir = null) & get_dir(X1,Y1,Dir)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Agent (", X0,",",Y0,") move", Dir, "to the dispenser at ",X,",",Y);
	-+self_location(X0+X1,Y0+Y1);		
	move(Dir).

// 【-!move_to_dispenser(X,Y,Type)】 When the execution of the move_to_dispenser plan fails, an alternate plan is executed, i.e., a random walk based on a fast strategy.
@move_to_backup[atomic] 
-!move_to_dispenser(X,Y,Type):  self_location(X0,Y0)<-
    +!move_agent.
    .print("test ", X-X0, Y-Y0).


// 【!check_direction】 The agent will issue a block request to the dispenser if the dispenser's location satisfies the condition of being adjacent to the agent.
+!check_direction(X,Y,Type) : self_location(X0,Y0) & get_dir(X-X0,Y-Y0,Dir) & available_dir(Dir)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Agent (", X0,",",Y0,") check dispenser at ",X,",",Y);
	!request_block(X,Y,Type).

// 【!check_direction】If the position of the agent and the dispenser satisfy the adjacency condition, but the requested direction does not match the available direction, 
// 					  the agent is rotated and the block direction and available direction are updated.
@check_direction[atomic]
+!check_direction(X,Y,Type) :  self_location(X0,Y0) & get_dir(X-X0,Y-Y0,DirA) & available_dir(DirB) & rotate_dir(DirA,DirB,RDir) & not DirA == DirB <-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Agent rotate from ",DirB," to ",DirA," (",RDir,") for dispenser at ",X,",",Y);
	!update_rotated_block_dir(RDir);
	!update_rotated_available_dir(RDir);
	rotate(RDir).

// 【!request_block】 This scheme is used for block request operations when the agent meets certain conditions (e.g., the current direction does not carry a block).
@request_block[atomic]
+!request_block(X,Y,Type) : self_location(X0,Y0) & get_dir((X-X0),(Y-Y0),Dir) & not block(Dir,Type) & not location(block,Type,X,Y)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Agent (", X0,",",Y0,") request block at ",X,",",Y, "for direction ", Dir);
	+location(block,Type,X,Y);
	request(Dir).

// 【!request_block】 This plan is used to perform the operation of mounting a block when the agent has successfully requested a block.
+!request_block(X,Y,Type) : self_location(X0,Y0) & get_dir((X-X0),(Y-Y0),Dir) & not block(Dir,Type) & location(block,Type,X,Y)<-
	.time(H,M,S,MS);
	.print("[",H,":",M,":",S,":",MS,"] ","Agent (", X0,",",Y0,") request block at ",X,",",Y, "for direction ", Dir);
	!attach_block(X,Y,Type).

// 【!attach_block】 This plan is used for the agent to perform the operation of mounting a block. When mounting a block, the agent will shift
// 					to explore mode and notify other agents of conflict information via have_block broadcast. It then removes an available direction
// 				    and the location where the block was previously located. The assign_dispenser plan will also be removed, causing the agent to exit find_blocks mode. 
// 					Finally the agent will add a block message indicating that a block is currently mounted.
@attach_block[atomic] 
+!attach_block(X,Y,Type) : self_location(X0,Y0) & location(block,Type,X,Y) & get_dir((X-X0),(Y-Y0),Dir)<-
	.time(H,M,S,MS); 	
	.print("[",H,":",M,":",S,":",MS,"] ","Block ",Type," successfully attached");
	-+mode(explore);
	+have_block(Dir,Type);
	-available_dir(Dir);
	-target_dispenser(_,_,_);
	-location(block,Type,X,Y);
	+block(Dir,Type);
	attach(Dir).

@rotation_individual[atomic]
+!rotation(B, Dir, RDir): rotate_dir(NewDir,Dir,RDir) <-
    .print("Rotate from ", Dir, " to ", NewDir);
    -block(Dir, B);
	+block(NewDir, B).
    

// 【!update_rotated_block_dir】 Updates the orientation of the block based on the given direction of rotation.
@update_rotated_block_dir_all[atomic]
+!update_rotated_block_dir(RDir) : block(n,B1) & block(e,B2) & block(s,B3) & block(w,B4)<-
    .print("Rotate all");
    !rotation(B1, n, RDir);
	!rotation(B2, e, RDir);
	!rotation(B3, s, RDir);
	!rotation(B4, w, RDir).

// 【!update_rotated_block_dir】 Updates the orientation of the block based on the given direction of rotation.
@update_rotated_block_dir_3[atomic]
+!update_rotated_block_dir(RDir) : block(Dir1,B1) & block(Dir2,B2) & block(Dir3,B3) &
    (not(Dir1 = Dir2)) & (not(Dir2 = Dir3)) & (not(Dir1 = Dir3)) <-
	.print("Rotate ", Dir1, Dir2, Dir3);
    !rotation(B1, Dir1, RDir);
	!rotation(B2, Dir2, RDir);
	!rotation(B3, Dir3, RDir).

// 【!update_rotated_block_dir】 Updates the orientation of the block based on the given direction of rotation.
@update_rotated_block_dir_2[atomic]
+!update_rotated_block_dir(RDir) : block(Dir1,B1) & block(Dir2,B2) & (not(Dir1 = Dir2)) <-
    .print("Rotate ", Dir1, Dir2);
    !rotation(B1, Dir1, RDir);
	!rotation(B2, Dir2, RDir).

// 【!update_rotated_block_dir】 Updates the orientation of the block based on the given direction of rotation.
@update_rotated_block_dir_single[atomic]
+!update_rotated_block_dir(RDir) : block(Dir,B) <-
    .print("Rotate ", Dir);
    !rotation(B, Dir, RDir).
	
// 【!update_rotated_available_dir】 Updates the new available direction based on the given direction of rotation and the current available direction.
@update_rotated_available_dir_3[atomic]
+!update_rotated_available_dir(RDir): available_dir(Dir1) & available_dir(Dir2) & available_dir(Dir3)
    & (not(Dir1 = Dir2)) & (not(Dir2 = Dir3)) & (not(Dir1 = Dir3))
	& .difference([n, s, w, e], [Dir1, Dir2, Dir3], [Dir]) & rotate_dir(Dir, OldDir, RDir) <-
	-available_dir(OldDir);
	+available_dir(Dir).

// 【!update_rotated_available_dir】 Updates the new available direction based on the given direction of rotation and the current available direction.
@update_rotated_available_dir_2_adjacent[atomic]
+!update_rotated_available_dir(RDir): available_dir(Dir1) & available_dir(Dir2) & not(Dir1 = Dir2)
    & rotate_dir(Dir2, Dir1, RDir) & rotate_dir(NewDir, Dir2, RDir) <-
	-available_dir(Dir1);
	+available_dir(NewDir).

// 【!update_rotated_available_dir】 Updates the new available direction based on the given direction of rotation and the current available direction.
@update_rotated_available_dir_2_opposite[atomic]
+!update_rotated_available_dir(RDir): available_dir(Dir1) & available_dir(Dir2) & not(Dir1 = Dir2)
    & rotate_dir(NewDir1, Dir1, RDir) & rotate_dir(NewDir2, Dir2, RDir) <-
	-available_dir(Dir1);
	-available_dir(Dir2);
	+available_dir(NewDir1);
	+available_dir(NewDir2).

// 【update_rotated_available_dir】 Updates the new available direction based on the given direction of rotation and the current available direction.
@update_rotated_available_dir11[atomic]
+!update_rotated_available_dir(RDir): available_dir(Dir) & rotate_dir(NewDir, Dir, RDir) <-
    -available_dir(Dir);
	+available_dir(NewDir).