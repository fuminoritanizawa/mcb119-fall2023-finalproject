%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repressilator ODE function for modleing lambda phage (c1, rcsA); Hasty et
% al. 2001 doi.org/10.1063/1.1345702. This function is only for showing the
% graph of inserction for gamma xy and is not really important. The main is
% mcb_final_2023fall_main.m file.
% Author: Fumi Tanizawa, Ethan Goroza
% Date:   2023-12-03
% Called by: mcb_final_2023fall_main.m
% Other routines needed: None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_gamma_xy_vs_threshold()
    % Fixed parameters
    m = 1; 
    alpha = 11;
    sigma1 = 2; 
    sigma2 = 0.08;
    gamma_x = 0.004;
    x0 = 2; % Fixed x0 value
    t_fixed = 5; % Specific time point
    gamma_xy_values = 0:0.01:0.5; % Range of gamma_xy values

    % Array to store the threshold y values for each gamma_xy
    threshold_y_values = zeros(size(gamma_xy_values));

    for i = 1:length(gamma_xy_values)
        gamma_xy = gamma_xy_values(i);
        threshold_y_values(i) = calculate_threshold(m, alpha, sigma1, sigma2, gamma_x, gamma_xy, x0, t_fixed);
    end

    % Plotting gamma_xy vs threshold y values
    figure;
    plot(gamma_xy_values, threshold_y_values, '-o');
    xlabel('gamma_xy');
    ylabel('rcsA Threshold (y at intersection)');
    title('rcsA Threshold vs gamma_xy');
end

function threshold_y = calculate_threshold(m, alpha, sigma1, sigma2, gamma_x, gamma_xy, x0, t_fixed)
    y_values = 0:100; % Range of y values
    x_diff = zeros(length(y_values), 1);

    for j = 1:length(y_values)
        y = y_values(j);
        parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];
        [t, x] = ode45(@hasty, [0, 10], x0, [], parvals);

        x_diff(j) = interp1(t, x, t_fixed) - x0;
    end

    % Find intersection point
    sign_change_idx = find(diff(sign(x_diff)) ~= 0, 1, 'first');
    if ~isempty(sign_change_idx)
        threshold_y = interp1(x_diff(sign_change_idx:sign_change_idx+1), y_values(sign_change_idx:sign_change_idx+1), 0);
    else
        threshold_y = NaN; % No intersection found
    end
end
