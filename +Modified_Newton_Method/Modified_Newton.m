function x_min= Modified_Newton(x0, f, g, H, tol)
%MODIFIED_NEWTON_METHOD implements the modified Newton Method, embedded with a back-tracking strategy for the line search.
%   Inputs: starting point x0, the function (handle) f, the gradient g (handle), the hessian H (hanlde), a tolerance value 
%   Output: the solution of the minimization x_min (approximated accordig to tol)

%parameters
alpha_0= 10;   %Is it correct?
rho= 0.5;
c=1e-4;

n=length(x0); x=x0; fx=f(x); gx=g(x);

while norm(gx) > tol

    Hx=H(x);                                                               %updating H(x)

    t = 1e-6;                                                              %using t as a small little increment

    while true
        B = Hx + t*speye(n);
        [L, p] = chol(B, 'lower');                                         %using Cholesky factorization to check if B is positive definite
        if p == 0  
            break;
        else
            t = t * 10;                                                    %imcrementing t if B is not positive definite
        end
    end
    
    p_k = - L\gx;                                                          %solving the system in order to find p_k
    
    if gx' * p_k > -1e-12                                                  %if the direction is NOT descendent, fallback on gradient
        p_k = -gx;
    end

    if norm(p_k) > 1e3
        p_k = p_k / norm(p_k) * 1e3;
    end

    alpha=alpha_0; 
    count = 0;
    maxiter=20;
   
    while true                                                             %backtracking line search
        x_new = x + alpha * p_k;
        f_new= f(x_new);
        if f_new <= fx + c * alpha * (gx' * p_k)
            break;
        end

        alpha = rho * alpha;

        count = count + 1;
        if count > maxiter || alpha < 1e-10
            break;
        end
    end

    x = x_new;                                                             %updating x
    fx= f(x);                                                              %updating f(x)
    gx= g(x);                                                              %updating g(x)

    %fprintf(['f_new: ', num2str(f_new), ' norma gx: ', num2str(norm(gx)), '\n']);
end

x_min=x;

end




