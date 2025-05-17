import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Test_Functions.*

N= [10^5];  

for j=1:length(N)
    %Preparing Modified Newton's inputs
    n=N(j);
    x0= starting_point(n);
    points= Random_Points(x0);
    [f,g,H]= Chained_Rosenbrock(n);

    %MODIFIED NEWTON ------------------------------------------------------
    Solution= ones(n,1);

    disp(['MODIFIED NEWTON - TEST ', num2str(j) ' >> n=', num2str(n)]);
    for i=1:1
        tic;
        Successo= Modified_Newton(points(:,i),f,g,H,0.001) - Solution < 1e-3;
        time= toc;
        if Successo
            out='Successo';
        else
            out='Fallimento';
        end
        print_exec_time(i, time,out);
    end
    
    fprintf('\n');
end

