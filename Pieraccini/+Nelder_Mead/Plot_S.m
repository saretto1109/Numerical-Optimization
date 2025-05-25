function Plot_S(S)
%PLOT_S creates a plot of the simplex
%   Input: the simplex S
%   Output: the plot of the simplex S

S_t = S';
S_closed = [S_t; S_t(1,:)];
fill(S_closed(:,1), S_closed(:,2), [0.2 0.6 1], 'FaceAlpha', 0.3, 'EdgeColor', 'k');
plot(S_closed(:,1), S_closed(:,2), 'ko-', 'LineWidth', 0.8, 'MarkerFaceColor', 'w');
xlabel('x'); ylabel('y'); axis equal; grid on;

end

