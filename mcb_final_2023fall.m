%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repressilator ODE function for modeling lambda phage (c1, rcsA); Hasty et al. 
% 2001, doi.org/10.1063/1.1345702
% Author: Fumi Tanizawa, Ethan Goroza
% Date:   2023-12-02
% Other routines needed: hasty.m., repressilator_with_sliders.m,
% plot_gamma_xy_vs_threshold.m, plot_x0_vs_threshold.m
% NOTE: the updated (with slide bar and stuff) version is
% repressilator_with_sliders.m and it is way better.
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% First graph: Showing the x value (c1 concentraion) over time with
%%% different y value from 0 to 100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
hold on;

for y = y_values_1
    % Update parameter values
    parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];

    % Solver
    [t, x] = ode45(@hasty, [t_init, t_final], x0, [], parvals);

    % Plot the solution
    p = plot(t, x, 'LineWidth', 2);
    text(t(end), x(end), sprintf('y = %g', y), 'FontSize', 8);
end

hold off;
xlabel('Time', 'FontSize', 16);
ylabel('c1 concentration', 'FontSize', 16);
title('c1 concentration over time for various rcsA levels', 'FontSize', 16);

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
figure;
hold on;
plot(y_values_2, x_diff, '-o', 'LineWidth', 2);
plot(y_values_2, zeros(size(y_values_2)), 'r--', 'LineWidth', 1.5); % Horizontal red dashed line at x = 0
hold off;

xlabel('y (rcsA concentratio)', 'FontSize', 16);
ylabel(sprintf('Difference in x from x0 at t = %g', t_fixed), 'FontSize', 16);
title(sprintf('Difference from initial x0 at t = %g for different values of y', t_fixed), 'FontSize', 16);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Third graph: Showing the difference at t_fixed for y values from 30
%%% to 50 with 0.2 increment step
%%% Just a zoom-in version of Figure 2 above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% New range for zoomed-in of figure 2
y_values_3 = 35:0.1:40;

% Initialize array to store the difference x(t_fixed) - x0 for the new y range
x_diff_3 = zeros(length(y_values_3), 1);

% Loop over the new range of y values to get the difference at t_fixed
for i = 1:length(y_values_3)
    y = y_values_3(i);
    parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];
    [t, x] = ode45(@hasty, [t_init, t_final], x0, [], parvals);

    % Interpolate to find x at t_fixed and calculate the difference
    x_diff_3(i) = interp1(t, x, t_fixed) - x0;
end

% Plot the difference x(t_fixed) - x0 versus y
figure;
hold on;
plot(y_values_3, x_diff_3, '-o', 'LineWidth', 2);
plot(y_values_3, zeros(size(y_values_3)), 'r--', 'LineWidth', 1.5); % Horizontal red dashed line at x = 0
hold off;

xlabel('y (rcsA concentratio)', 'FontSize', 16);
ylabel(sprintf('Difference in x from x0 at t = %g', t_fixed), 'FontSize', 16);
title(sprintf('Difference from initial x0 at t = %g for y range 30 to 50', t_fixed), 'FontSize', 16);
