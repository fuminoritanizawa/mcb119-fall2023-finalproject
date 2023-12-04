    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repressilator ODE function for modeling lambda phage (c1, rcsA); Hasty et al. 
% 2001, doi.org/10.1063/1.1345702
% Author: Fumi Tanizawa, Ethan Goroza
% Date:   2023-12-02
% Other routines needed: hasty.m., repressilator_with_sliders.m,
% plot_gamma_xy_vs_threshold.m, plot_x0_vs_threshold.m
% original: mcb_final_2023fall.m; I modified this original code deleting
% the first and third graphs and addded the function to call
% repressilator_with_sliders.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Setting parameter for all following graphs + hasty.m (another file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters: extracted from hasty et al. 2001 (page 12)
m = 1; 
alpha = 11;
sigma1 = 2; % keep it larger than sigma2
sigma2 = 0.08;
gamma_x = 0.004;
gamma_xy = 0.1; % arbitary; x25 protease degradation relative to spontaneous degradation of c1 

% Initial condition
x0 = 2;

% Time span
t_init = 0;
t_final = 10;

% Array of y values
y_values_1 = [0.1, 0.5, 1, 2, 3, 4, 5, 10, 20, 30, 35, 40, 50, 55, 100];
% y_values_1 = [100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculating threshold of y where c1 conc going negative/positive for the
%%% second graph below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Specific time point
t_fixed = 5; % Adjust the desired time point
y_values_2 = 0:100; % Array of y values from 0 to 100

% Initialize array to store the difference x(t_fixed) - x0
x_diff = zeros(length(y_values_2), 1);

% Loop over y values again to get the difference at t_fixed
for i = 1:length(y_values_2)
    y = y_values_2(i);
    parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];
    [t, x] = ode45(@hasty, [t_init, t_final], x0, [], parvals);

    % Interpolate to find x at t_fixed and calculate the difference
    x_diff(i) = interp1(t, x, t_fixed) - x0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Second graph: Showing the difference at t_fixed for y values from 0
%%% to 100 with 1 increment step
%%% Showing extracted values from Figure 1 at t=5 for differnt y values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the difference x(t_fixed) - x0 versus y for the second graph

% Calculate the intersection point
% Find where the sign of x_diff changes
sign_change_idx = find(diff(sign(x_diff)) ~= 0, 1, 'first');
if ~isempty(sign_change_idx)
    % Interpolate to find the exact point of intersection
    y_interpolate = interp1(x_diff(sign_change_idx:sign_change_idx+1), y_values_2(sign_change_idx:sign_change_idx+1), 0);
else
    y_interpolate = NaN; % No intersection found
end

% Plot the difference x(t_fixed) - x0 versus y for the second graph
figure;
hold on;
plot(y_values_2, x_diff, '-o', 'LineWidth', 2);
plot(y_values_2, zeros(size(y_values_2)), 'r--', 'LineWidth', 1.5); % Horizontal red dashed line at x = 0

% Plot the intersection point
if ~isnan(y_interpolate)
    plot(y_interpolate, 0, 'kp', 'MarkerSize', 10, 'MarkerFaceColor', 'green'); % 'kp' means black pentagram
    text(y_interpolate, 0, sprintf(' (%.2f, 0)', y_interpolate), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

hold off;

xlabel('y (rcsA concentration)', 'FontSize', 16);
ylabel(sprintf('Difference in x from x0 = %g at t = 5', x0), 'FontSize', 16);
title(sprintf('Difference from initial x0 at t = %g for different values of y', t_fixed), 'FontSize', 16);


% main.m
% Call the repressilator GUI function
repressilator_with_sliders;

% call the intersection graphing functions
plot_gamma_xy_vs_threshold;
plot_x0_vs_threshold;