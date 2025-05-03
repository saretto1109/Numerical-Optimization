function x_min = Nelder_Mead(x0,f, tol)
%NELDER_MEAD implements the Nelder Mead method with fixed params (p_r=1, p_e=2, p_c=0.5, p_s=0.5)
%   Inputs: a starting point x0, the function (handle) f, a tolerance value tol
%   Output: the solution of the minimization x_min (approximated accordig to tol)

%params
p_r= 1; 
p_e= 2; 
p_c= 0.5; 
p_s= 0.5;

%implementing an adaptive restart strategy 
maxiter=300*length(x0);
i=0;

%figure(1); hold on;          
%axis equal; grid on;
%xlabel('x'); ylabel('y');
%title('Nelder-Mead simplex evolution');

S= Nelder_Mead.Generate_simplex(x0);
[S_sorted,F_sorted]= Nelder_Mead.Sort(S,f);
c=Nelder_Mead.Centroid(S_sorted); 

while ~Nelder_Mead.Acceptable_Diameter(S,tol)
    %Nelder_Mead.Plot_S(S);
    %pause(0.5);
    x_worst=S_sorted(:, end);
    f_best= F_sorted(1);
    f_secworst= F_sorted(end -1);
    f_worst=F_sorted(end);

    x_r= Nelder_Mead.Reflection_Expansion(c, p_r,x_worst);                 %reflected point
    f_r= f(x_r);                                                           %evaluation of the reflected point
    
    if f_r < f_best                                                        %expansion
        x_e= Nelder_Mead.Reflection_Expansion(c,p_e,x_worst);
        f_e=f(x_e);
        if f_e < f_r                                                       %accept expansion
            S_sorted(:,end)= x_e;
            S=S_sorted; 
        else                                                               %accept reflection
            S_sorted(:,end)= x_r;
            S=S_sorted;
        end

    elseif (f_best <= f_r) && (f_r < f_secworst)                           %accept reflection
        S_sorted(:,end)= x_r;
        S=S_sorted;

    elseif (f_secworst <= f_r) && (f_r < f_worst)                          %out contraction
        x_outc= Nelder_Mead.Out_Contraction(c, p_c, x_r);
        f_outc= f(x_outc);
        if f_outc < f_r
            S_sorted(:,end)= x_outc;
            S=S_sorted;          
        else
            S= Nelder_Mead.Shrink(S_sorted,p_s);                           %shrink
        end

    elseif f_r >= f_worst                                                  %in_contraction
        x_inc= Nelder_Mead.In_Contraction(c,p_c,x_worst);
        f_inc= f(x_inc);
        if f_inc < f_worst
            S_sorted(:,end)= x_inc;
            S=S_sorted;
        else 
            S= Nelder_Mead.Shrink(S_sorted,p_s);                           %shrink
        end
    end
    [S_sorted,F_sorted]= Nelder_Mead.Sort(S,f);
    c=Nelder_Mead.Centroid(S_sorted); 

    i=i+1;
    if (i>maxiter)                                                         %restarting from the best x found so far
        S= Nelder_Mead.Generate_simplex(S_sorted(:, 1));
        [S_sorted,F_sorted]= Nelder_Mead.Sort(S,f);
        c=Nelder_Mead.Centroid(S_sorted);
        i=0;
    end

end

x_min= S_sorted(:, 1);

end

