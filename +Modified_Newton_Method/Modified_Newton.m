function x_min= Modified_Newton(x0, f, g, H, tol)
%MODIFIED_NEWTON_METHOD implements the modified Newton Method, embedded with a back-tracking strategy for the line search.
%   Inputs: starting point x0, the function (handle) f, the gradient g (handle), the hessian H (hanlde), a tolerance value 
%   Output: the solution of the minimization x_min (approximated accordig to tol)

%parameters
alpha_0=1;   
rho= 0.5;
c=1e-4;
t0=1e-4;

n=length(x0); x=x0; gx=g(x);

while norm(gx) > tol
    Hx=H(x);                                                               %updating H(x)
    
    t=t0;
    [L, p] = chol(Hx, 'lower');                                            %using Cholesky factorization to check if H is positive definite
    while p~=0
        [L, p] = chol(Hx + t*speye(n), 'lower');                           %using Cholesky factorization to check if B is positive definite
        t=t*10;                                                            %incrementing t if B is not positive definite
    end
                                                         
    p_k = L' \ (L \ -gx);                                                  %solving the system in order to find p_k                                                
                                                                
    alpha=alpha_0; 
   
    while f(x + alpha * p_k) > f(x) + c * alpha * (gx' * p_k)              %backtracking line search
        alpha = rho * alpha;
    end

    x = x + alpha * p_k;                                                   %updating x
    gx= g(x);  

end
x_min=x;
end




