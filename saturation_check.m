function output = saturation_check(input,input_limit)

if abs(input) > input_limit
    if input>0
        output = input_limit;         
    else
        output = -input_limit;
    end 
else
    output = input;
end
