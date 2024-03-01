function [scaled_signal] = ScaleToOnes(random_signal)

i = 1;
while i <= length(random_signal)
    if random_signal(i)>0
        random_signal(i) = 1;
    else
        random_signal(i) = -1;
    end
    i = i+1;
end

scaled_signal = random_signal;

end