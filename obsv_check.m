function obsv_check(A,C)

obsv_rank = rank(obsv(A,C));

if obsv_rank == length(A)
    fprintf('Observability Matrix Rank = %1.0i\nThis system is observable!\n\n',obsv_rank)
elseif obsv_rank < length(A)
    fprintf('Observability Matrix Rank = %1.0i\nThis system is NOT observable!\n\n',obsv_rank)
end
end