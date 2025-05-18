function [F,gradF, hessF] = Chained_Rosenbrock(n)
%CHAINED_ROSENBROCK builds the Chained Rosenbrock function as defined and returns is, along with its gradient and its hessian matrix
%   Input: a vector x in R^n
%   Output: the Chained Rosenbrock function F, its gradient gradF and its hessian matrix hessF

F = @(x) sum(100*(x(2:n) - x(1:n-1).^2).^2 + (1 - x(1:n-1)).^2);           %function

gradF = @(x) gradient(x,n);                                                %gradient

hessF = @(x) hessian_sparse(x,n);                                          %hessian sparse
end


%GRADIENT AND HESSIAN------------------------------------------------------

%Function calculating the gradient of the Chained Rosenbrock
function g = gradient(x,n)
     g = zeros(n,1);
     g(1) = -400*(x(2) - x(1)^2)*x(1) - 2*(1 - x(1));
     for i = 2:n-1
        g(i) = 200*(x(i) - x(i-1)^2) - 400*(x(i+1) - x(i)^2)*x(i) - 2*(1 - x(i));
     end
     g(n) = 200*(x(n) - x(n-1)^2);
end

%Function caluculating the hessian using a "white boxe" approach, exploiting the structure of the function
function H = hessian_sparse(x, n)
    main_diag_vals = zeros(n, 1);
    off_diag_vals = zeros(n-1, 1);

    main_diag_vals(1) = 1200*x(1)^2 - 400*x(2) + 2;
    for i = 2:n-1
        main_diag_vals(i) = 1200*x(i)^2 - 400*x(i+1) + 202;
    end
    main_diag_vals(n) = 200;

    for i = 1:n-1
        off_diag_vals(i) = -400*x(i);
    end

    H = sparse(1:n, 1:n, main_diag_vals, n, n) + sparse(1:n-1, 2:n, off_diag_vals, n, n) + sparse(2:n, 1:n-1, off_diag_vals, n, n);
end