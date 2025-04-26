function x_best= Modified_Newton_NOT_SCALABLE(x0, f, vars, tol)
%MODIFIED_NEWTON_METHOD Summary of this function goes here
%   Detailed explanation goes here

%parameters
alpha_0= 1;
rho= 0.5;
c=1e-4;

x=x0;
g = double(subs(gradient(f, vars), vars, x));

while ~(norm(g) < tol)
   
    H = double(subs(hessian(f, vars), vars, x)); 

    t = 1e-6;
    while true
        [R, p] = chol(H + t*eye(length(x)));
        if p == 0  
            break;
        else
            t = t * 2;
        end
    end
    
    B = H + t*eye(length(x));

    p_k = B\(-g);

    alpha = alpha_0;
    
    f_old= double(subs(f, vars, x));

    while true
        f_new= double(subs(f, vars, num2cell(x + (alpha*p_k).')));
        if f_new > f_old + c*alpha*(g'*p_k)
            alpha = rho * alpha;
        else
            break;
        end
    end

    x = x + (alpha*p_k).';
    g = double(subs(gradient(f, vars), vars, x));
end

x_best=x;

end




