function [F,gradF, hessF] = Banded_Trigonometric(n)
%BANDED_TRIGONOMETRIC Summary of this function goes here
%   Detailed explanation goes here
    F = @objective_function;
    gradF= @gradient_function;
    hessF = @hessian_function;
    
    function f_val = objective_function(x)
        x_col = x(:);
        f_val = 0;
        
        sin_x = sin(x_col);
        cos_x = cos(x_col);

        for i = 1:n
            term_i_cos_xi = 1 - cos_x(i);
            
            term_i_sin_xim1 = 0;
            if i > 1
                term_i_sin_xim1 = sin_x(i-1);
            end
            
            term_i_sin_xip1 = 0;
            if i < n
                term_i_sin_xip1 = sin_x(i+1);
            end
            
            f_val = f_val + i * (term_i_cos_xi + term_i_sin_xim1 - term_i_sin_xip1);
        end
    end

    function grad_val = gradient_function(x)
        x_col = x(:);
        grad_val = zeros(n, 1);
        
        sin_x = sin(x_col);
        cos_x = cos(x_col);

        for k = 1:n
            term1 = k * sin_x(k);
            
            term2 = 0;
            if k < n
                term2 = (k+1) * cos_x(k);
            end
            
            term3 = 0;
            if k > 1
                term3 = -(k-1) * cos_x(k);
            end
            grad_val(k) = term1 + term2 + term3;
        end
    end

    function H_mat = hessian_function(x)
        x_col = x(:);

        sin_x = sin(x_col);
        cos_x = cos(x_col);
        
        diag_H = zeros(n, 1);

        for k = 1:n
            term1 = k * cos_x(k);
            
            term2 = 0;
            if k < n
                term2 = -(k+1) * sin_x(k);
            end
            
            term3 = 0;
            if k > 1
                term3 = -(-(k-1) * sin_x(k)); 
            end
            diag_H(k) = term1 + term2 + term3;
        end
        
        H_mat = spdiags(diag_H, 0, n, n);
    end
end

