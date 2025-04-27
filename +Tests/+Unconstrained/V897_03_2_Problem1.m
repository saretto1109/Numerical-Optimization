import Nelder_Mead.*
import Modified_Newton_Method.*
import Tests.Unconstrained.Problem1.*

N_Mead= [10, 25, 50];
N= [10^3, 10^4 10^5];  

%NELDER MEAD --------------------------------------------------------------

%Test 1 Inputs
x01= starting_point(N_Mead(1));
points1= Random_Points(x01);
[f1, g1, H1]= Chained_Rosenbrock(N_Mead(1));

%Test 2 Inputs
x02= starting_point(N_Mead(2));
points2= Random_Points(x02);
[f2, g2, H2]= Chained_Rosenbrock(N_Mead(2));

%Test 3 Inputs
x03= starting_point(N_Mead(3));
points3= Random_Points(x03);
[f3, g3, H3]= Chained_Rosenbrock(N_Mead(3));

%NEALDER MEAD - TEST 1: n=10
Solution= ones(10,1);

disp('NEALDER MEAD - TEST 1 >> n=10');
for i=1:10
    tic;
    Successo= Nelder_Mead(points1(:,i),f1,0.0001) - Solution < 1e-4;
    time= toc;
    if Successo
        out='Successo';
    else
        out='Fallimento';
    end
    disp(['Esecuzione ', num2str(i), ': ', out, ' >>> Tempo di esecuzione: ', num2str(time), ' secondi']);
end

fprintf('\n');

%NEALDER MEAD - TEST 2: n=25
Solution= ones(25,1);

disp('NEALDER MEAD - TEST 2 >> n=25');
for i=1:10
    tic;
    Successo= Nelder_Mead(points2(:,i),f2,0.0001) - Solution < 1e-4;
    time= toc;
    if Successo
        out='Successo';
    else
        out='Fallimento';
    end
    disp(['Esecuzione ', num2str(i), ': ', out, ' >>> Tempo di esecuzione: ', num2str(time), ' secondi']);
end

fprintf('\n'); 


%NEALDER MEAD - TEST 3: n=50
Solution= ones(50,1);

disp('NEALDER MEAD - TEST 3 >> n=50');
for i=1:10
    tic;
    Successo= Nelder_Mead(points3(:,i),f3,0.0001) - Solution < 1e-4;
    time= toc;
    if Successo
        out='Successo';
    else
        out='Fallimento';
    end
    disp(['Esecuzione ', num2str(i), ': ', out, ' >>> Tempo di esecuzione: ', num2str(time), ' secondi']);
end