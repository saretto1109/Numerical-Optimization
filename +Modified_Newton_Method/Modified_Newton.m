function x_min= Modified_Newton(x0, f, g, H, tol)
%MODIFIED_NEWTON_METHOD implements the modified Newton Method, embedded with a back-tracking strategy for the line search.
%   Inputs: starting point x0, the function (handle) f, the gradient g (handle), the hessian H (hanlde), a tolerance value 
%   Output: the solution of the minimization x_min (approximated accordig to tol)

%parameters
alpha_0=1;   
rho= 0.5;
c=1e-4;
t = 1e-3;

n=length(x0); x=x0; fx=f(x); gx=g(x);

while norm(gx) > tol

    Hx=H(x);                                                               %updating H(x)
    
    t_curr = t;                                                            %using t_curr as a small little increment

    while true
        B = Hx + t_curr*speye(n);
        [L, p] = chol(B, 'lower');                                         %using Cholesky factorization to check if B is positive definite
        if p == 0  
            t=t_curr;                                                      %keep track of t used so far
            break;
        else
            t_curr = t_curr * 10;                                          %incrementing t_curr if B is not positive definite
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

end

x_min=x;

end




