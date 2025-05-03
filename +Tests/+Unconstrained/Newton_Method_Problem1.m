import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Problem1.*

N= [10^3, 10^4 10^5];  

for j=1:1
    %Preparing Modified Newton's inputs
    n=N(j);
    x0= starting_point(n);
    points= Random_Points(x0);
    [f,g,H]= Chained_Rosenbrock(n);

    %MODIFIED NEWTON ------------------------------------------------------
    Solution= ones(n,1);

    disp(['MODIFIED NEWTON - TEST ', num2str(j) ' >> n=', num2str(n)]);
    for i=1:10
        tic;
        Successo= Modified_Newton(points(:,i),f,g,H,0.0001) - Solution < 1e-4;
        time= toc;
        if Successo
            out='Successo';
        else
            out='Fallimento';
        end
        disp(['Esecuzione ', num2str(i), ': ', out, ' >>> Tempo di esecuzione: ', num2str(time), ' secondi']);
    end
    
    fprintf('\n');
end