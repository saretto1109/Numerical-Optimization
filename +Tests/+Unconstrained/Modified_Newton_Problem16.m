import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Test_Functions.*

N= [10^3, 10^4, 10^5];
tol= 1e-6;
times = strings(10*length(N),1);

for j=1:length(N)
    %Preparing Modified Newton's inputs
    n=N(j);
    x0= starting_point(n);
    points= Random_Points(x0);                  
    [f,g,H]= Banded_Trigonometric(n);

    %MODIFIED NEWTON ------------------------------------------------------
    fprintf('%10s | %10s | %10s | %10s\n', 'n', 'Time', 'F(x)', 'IsGlobal?');
    fprintf('----------------------------------------------------\n');

    for i=1:10
        tic;
        [x, fx]= Modified_Newton(points(:, i),f,g,H,tol);
        t=toc;
        times(i)=print_exec_time(t);

        fprintf('%10d | %10s | %10.4f | %10s\n', n, times(i), fx, 'Unknown');
    end   
    fprintf('\n');
end

