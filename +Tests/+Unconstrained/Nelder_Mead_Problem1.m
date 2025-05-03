import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Problem1.*

N= [10, 25, 50];  

%TESTS --------------------------------------------------------------------
for j=1:3    
    %Preparing Nelder Mead's inputs
    n=N(j);
    x0= starting_point(n);
    points= Random_Points(x0);
    [f,~, ~]= Chained_Rosenbrock(n);

    %NELDER MEAD ----------------------------------------------------------
    Solution= ones(n,1);

    disp(['NEALDER MEAD - TEST ', num2str(j) ' >> n=', num2str(n)]);
    for i=1:10
        tic;
        Successo= Nelder_Mead(points(:,i),f,0.0001) - Solution < 1e-4;
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

