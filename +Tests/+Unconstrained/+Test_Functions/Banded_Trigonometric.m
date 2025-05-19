function [F,gradF, hessF] = Banded_Trigonometric(n)
%BANDED_TRIGONOMETRIC builds the Banded Trigonometric function as defined and returns is, along with its gradient and its hessian matrix
%   Input: the dimension n of the problem
%   Output: the Banded Trigonometric function F, its gradient gradF and its hessian matrix hessF

F = @objective_function;
gradF= @gradient_function;
hessF = @hessian_function;

function f = objective_function(x)
    x_col = x(:);
    x_ext = [0; x_col; 0];
    f = 0;
    for i = 1:n
        f = f + i * (1 - cos(x_col(i)) + sin(x_ext(i)) - sin(x_ext(i+2)));
    end
end

function g = gradient_function(x)
    x_col = x(:);
    g = zeros(n, 1);

    for i = 1:n
        if i > 1
            g(i-1) = g(i-1) + i * cos(x_col(i-1));
        end
        
        g(i) = g(i) + i * sin(x_col(i));
        
        if i < n
            g(i+1) = g(i+1) - i * cos(x_col(i+1));
        end
    end
end

function H = hessian_function(x)
    x_col = x(:);
    main_diag  = zeros(n,1);

    for i = 1:n
        main_diag(i) = main_diag(i) + i * cos(x_col(i));
        
        if i > 1
            main_diag(i-1) = main_diag(i-1) - i * sin(x_col(i-1));
        end
        
        if i < n
            main_diag(i+1) = main_diag(i+1) + i * sin(x_col(i+1));
        end
    end

    H = spdiags(main_diag, 0, n, n);
end
end
