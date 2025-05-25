import Modified_Newton_Method.*

f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
g = @(x) [-400*(x(2) - x(1)^2)*x(1) - 2*(1 - x(1)); 200*(x(2) - x(1)^2)];
H= @(x) [1200*x(1)^2 - 400*x(2) + 2, -400*x(1); -400*x(1), 200];


x0= [1.2, 1.2];
x1= [-1.2, 1];

disp(Modified_Newton(x0, f, g, H, 0.0001));

disp(Modified_Newton(x1, f, g, H, 0.0001));
