function [F,gradF, hessF] = Least_Square82(n)
%LEAST_SQUARE82 builds the least square function of problem 82 and returns it, along with its gradient and its hessian matrix
%   Input: the dimension n of the problem
%   Output: the function F of problem 82, its gradient gradF and its hessian matrix hessF

F = @objective_function;
gradF= @gradient_function;
hessF = @hessian_function;

function f = objective_function(x)
    x_col= x(:);
    f = 0.5 * x_col(1)^2; 
    for k = 2:n
        fk = cos(x(k-1)) + x_col(k) - 1;
        f = f + 0.5 * fk^2;
    end
end

function g = gradient_function(x)
    g = zeros(n, 1);
    x_col= x(:);

    f = zeros(n, 1);
    f(1) = x(1);
    for k = 2:n
        f(k) = cos(x_col(k-1)) + x_col(k) - 1;
    end

    g(1) = x_col(1) - sin(x_col(1)) * f(2);
    for k = 2:n-1
        g(k) = f(k) - sin(x_col(k)) * f(k+1);
    end
    g(n) = f(n);
end

function H = hessian_function(x)
    x = x(:);                     
    n = length(x);              

    f_terms = [x(1); cos(x(1:end-1)) + x(2:end) - 1]; 

    main_diag = [ 1 - cos(x(1)) * f_terms(2) + sin(x(1))^2; ...
    1 + sin(x(2:end-1)).^2 - cos(x(2:end-1)) .* f_terms(3:end); ...
    1];

    off_diag = -sin(x(1:end-1)); 

    H = spdiags([[off_diag; 0], main_diag, [0; off_diag]], -1:1, n, n);
end
end

