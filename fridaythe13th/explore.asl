+!add_to_map(dispenser): self_pos(X, Y) & thing(X1, Y1, dispenser, Type) <-
    .print("found dispenser at", X+X1, ", ", Y+Y1);
    +thing_loc(X+X1, Y+Y1, dispenser, Type).

+!add_to_map(block): self_pos(X, Y) & thing(X1, Y1, block, Type) <-
    .print("found block at", X+X1, ", ", Y+Y1);
    +thing_loc(X+X1, Y+Y1, block, Type).

+!add_to_map(goal): self_pos(X, Y) & goal(X1, Y1) <-
    .print("found goal terrain at", X+X1, ", ", Y+Y1);
    +thing_loc(X+X1, Y+Y1, goal, goal).

+!add_to_map(obstacle): self_pos(X, Y) & obstacle(X1, Y1) <-
    .print("found obstacle at", X+X1, ", ", Y+Y1);
    +thing_loc(X+X1, Y+Y1, obstacle, obstacle).

+!add_to_map(Type): true.

+!add: thing(_, _, _, _) | goal(_, _) | obstacle(_, _) <-
    !add_to_map(dispenser);
    !add_to_map(block);
    !add_to_map(goal);
    !add_to_map(obstacle).

+!add: true.