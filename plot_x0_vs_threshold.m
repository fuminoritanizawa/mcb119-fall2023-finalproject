%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repressilator ODE function for modleing lambda phage (c1, rcsA); Hasty et
% al. 2001 doi.org/10.1063/1.1345702. This function is only for showing the
% graph of inserction for x0 and is not really important. The main is
% mcb_final_2023fall_main.m file.
% Author: Fumi Tanizawa, Ethan Goroza
% Date:   2023-12-03
% Called by: mcb_final_2023fall_main.m
% Other routines needed: None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_x0_vs_threshold()
    % Fixed parameters
    m = 1; 
    alpha = 11;
    sigma1 = 2; 
    sigma2 = 0.08;
    gamma_x = 0.004;
    gamma_xy = 0.1; % Fixed gamma_xy value
    t_fixed = 5; % Specific time point
    x0_values = 0:0.1:10; % Range of x0 values

    % Array to store the threshold y values for each x0
    threshold_y_values = zeros(size(x0_values));

    for i = 1:length(x0_values)
        x0 = x0_values(i);
        threshold_y_values(i) = calculate_threshold(m, alpha, sigma1, sigma2, gamma_x, gamma_xy, x0, t_fixed);
    end

    % Plotting x0 vs threshold y values
    figure;
    plot(x0_values, threshold_y_values, '-o');
    xlabel('x0');
    ylabel('rcsA Threshold (y at intersection)');
    title('rcsA Threshold vs x0');
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