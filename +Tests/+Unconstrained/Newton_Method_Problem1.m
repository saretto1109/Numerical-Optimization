import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Test_Functions.*
warning('off', 'all');

N= [10^3, 10^4, 10^5];
tol= 1e-6;
times = zeros(10*length(N),1);
results = strings(10*length(N),1);

for j=1:length(N)
    %Preparing Modified Newton's inputs
    n=N(j);
    x0= starting_point(n);
    points= Random_Points(x0);                  
    [f,g,H]= Chained_Rosenbrock(n);

    %MODIFIED NEWTON ------------------------------------------------------
    Solution= ones(n,1);

    fprintf('%10s | %10s | %10s\n', 'n', 'Tempo [s]', 'IsGlobal?');
    fprintf('---------------------------------------------\n');

    for i=1:10
        tic;
        x= Modified_Newton(points(:, i),f,g,H,tol);
        times(i)=toc;
        Successo= norm(x - Solution) <= tol;
        if Successo
            results(i)='Sì';
        else
            results(i)='No';
        end 
        fprintf('%10d | %10.4f | %10s\n', n, times(i), results(i));
    end   
    fprintf('\n');
end

