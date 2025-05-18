import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Test_Functions.*


N= [10,25,50];
tol= 1e-6;
times = zeros(10*length(N),1);
results = strings(10*length(N),1);

for j=1:length(N)
    n=N(j);
    x0= starting_point(n);
    points= Random_Points(x0);                  
    [f,~,~]= Chained_Rosenbrock(n);

    %MODIFIED NEWTON ------------------------------------------------------
    Solution= ones(n,1);

    fprintf('%10s | %10s | %10s\n', 'n', 'Tempo [s]', 'IsGlobal?');
    fprintf('---------------------------------------------\n');

    for i=1:10
        tic;
        x= Nelder_Mead(points(:,i),f, tol);
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


