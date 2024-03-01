function ctrb_check(A,B)

ctrb_rank = rank(ctrb(A,B));

if ctrb_rank == length(A)
    fprintf('Controllability Matrix Rank = %1.0i\nThis system is controllable!\n\n',ctrb_rank)
elseif ctrb_rank < length(A)
    fprintf('Controllability Matrix Rank = %1.0i\nThis system is NOT controllable!\n\n',ctrb_rank)
end
end