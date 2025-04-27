function x_min= Modified_Newton(x0, f, g, H, tol)
%MODIFIED_NEWTON_METHOD implements the modified Newton Method, embedded with a back-tracking strategy for the line search.
%   Inputs: starting point x0, the function (handle) f, the gradient g (handle), the hessian H (hanlde), a tolerance value 
%   Output: the solution of the minimization x_min (approximated accordig to tol)

%parameters
alpha_0= 1;
rho= 0.5;
c=1e-4;

x=x0; gx=g(x);

while ~(norm(gx) < tol)
    Hx=H(x);                                     %updating H(x)

    t = 1e-6;                                    %using t as a small little increment

    while true
        B = Hx + t*eye(length(x));
        [~, p] = chol(B);                        %using Cholesky factorization to check if B is positive definite
        if p == 0  
            break;
        else
            t = t * 2;                           %doubling t if B is not positive definite
        end
    end
    
    p_k = B\(-gx);                               %solving the system in order to find p_k

    alpha=alpha_0; 
    count = 0;
    f_old=f(x);
   
    while true                                   %backtracking line search
        f_new= f(x + (alpha*p_k).');
        if f_new > f_old + c*alpha*(gx'*p_k)
            alpha = rho * alpha;
        else
            break;
        end

        count = count + 1;
        if count > 20 || alpha < 1e-8
            break;
        end
    end
    
    x = x + (alpha*p_k).';                       %updating x
    gx=g(x);                                     %updating g(x)
    disp(norm(gx));
    
end

x_min=x;

end




