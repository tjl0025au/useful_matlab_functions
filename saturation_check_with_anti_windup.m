function [output,Ki_out,error_sum_out,flag_out] = saturation_check_with_anti_windup(input,input_limit,Ki_in,error_sum_in,error_sum_flag)

error_sum_out = error_sum_in;
flag = error_sum_flag;
if abs(input) > input_limit
    if input>0
        output = input_limit;
        Ki_out = 0;
        flag_out = 1;
    else
        output = -input_limit;
        Ki_out = 0;
        flag_out = 1;
    end 
else
    output = input;
    Ki_out = Ki_in;
    if flag == 1
        error_sum_out = 0;
        flag_out = 0;
    else
        error_sum_out = error_sum_in;
        flag_out = flag;
    end
end