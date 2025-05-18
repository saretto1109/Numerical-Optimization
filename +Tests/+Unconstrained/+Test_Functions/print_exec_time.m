function time= print_exec_time(t)
%PRINT_EXEC_TIME prints the execution time of the i-th iteration, converted in seconds or minutes or hours
%   Input: time t in seconds
%   Output: time in seconds, minutes or hours (strings)
if t < 60
    time = [num2str(t, '%.3f'), ' sec'];
elseif t < 3600
    time = [num2str(t/60, '%.3f'), ' min'];
else
    time= [num2str(t/3600, '%.3f'), ' hour'];
end
end

