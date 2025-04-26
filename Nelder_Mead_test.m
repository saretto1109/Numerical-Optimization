import Nelder_Mead.*

f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;

x0= [1.2, 1.2];
x1= [-1.2, 1];
x2= [0.001, 0.001];

disp(Nelder_Mead(x0,f, 0.0001));
disp(fminsearch(f,x0)');


disp(Nelder_Mead(x1,f, 0.0001));
disp(fminsearch(f,x1)');
