function [F,gradF, hessF] = Chained_Rosenbrock(n)
%CHAINED_ROSENBROCK builds the Chained Rosenbrock function as defined and returns is, along with its gradient and its hessian matrix
%   Input: a vector x in R^n
%   Output: the Chained Rosenbrock function F, its gradient gradF and its hessian matrix hessF

F = @(x) sum(100*(x(2:n) - x(1:n-1).^2).^2 + (1 - x(1:n-1)).^2);           %function

gradF = @(x) gradient(x,n);                                                %gradient

%hessF = @(x) hessian(x,n);                                                 %hessian
hessF = @(x) hessian_sparse(x,n);                                         %hessian sparse
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

%Function calculating the hessian of the Chained Rosenbrock
function H = hessian(x,n)
    H = zeros(n,n);
    for i = 1:n-1
        H(i,i) = -400*(x(i+1) - x(i)^2) + 800*x(i)^2 + 2;
        H(i,i+1) = -400*x(i);
        H(i+1,i) = -400*x(i);
    end
    H(n,n) = 200;
end

%Function caluculating the hessian using a "white boxe" approach, exploiting the structure of the function
function H = hessian_sparse(x, n)
    main_diag  = zeros(n,1);                
    sub_diag   = zeros(n,1);   
    super_diag = zeros(n,1);   

    for i = 1:n-1
        main_diag(i) = main_diag(i) + 800*x(i)^2 - 400*(x(i+1) - x(i)^2) + 2;
        sub_diag(i)  = -400*x(i);
        super_diag(i)= -400*x(i);
    end
    main_diag(n) = 200;

    H = spdiags([sub_diag, main_diag, super_diag], [-1 0 1], n, n);
end