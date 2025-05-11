function print_exec_time(i, time,output)
%PRINT_EXEC_TIME prints the execution time of the i-th iteration, converted in seconds or minutes or hours
%   Input: time in seconds, i (i-th execution), output of the execution (Success/Failure)
%   Output: time in seconds, minutes or hours
if time < 60
    tempo_str = [num2str(time, '%.3f'), ' sec'];
elseif time < 3600
    tempo_str = [num2str(time/60, '%.3f'), ' min'];
else
    tempo_str = [num2str(time/3600, '%.3f'), ' ore'];
end

disp(['Esecuzione ', num2str(i), ': ', output, ' >>> Tempo di esecuzione: ', tempo_str]);
end

