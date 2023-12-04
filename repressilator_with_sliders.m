%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repressilator ODE function for modleing lambda phage (c1, rcsA); Hasty et
% al. 2001 doi.org/10.1063/1.1345702. This function is only for slidebar
% graphing and is not really important. The main is
% mcb_final_2023fall_main.m file.
% Author: Fumi Tanizawa, Ethan Goroza
% Date:   2023-12-03
% Called by: mcb_final_2023fall_main.m
% Other routines needed: None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function repressilator_with_sliders
    % Fixed parameters
    m = 1; 
    alpha = 11;
    sigma1 = 2; 
    sigma2 = 0.08;
    gamma_x = 0.004;
    t_fixed = 5; % Specific time point

    % Create a figure for sliders
    f = figure('Name', 'Repressilator Model', 'Position', [100, 100, 400, 400]);

    % Slider and value indicator for x0
    uicontrol('Parent', f, 'Style', 'text', 'Position', [50, 350, 100, 20], 'String', 'x0 (0-10)');
    x0_slider = uicontrol('Parent', f, 'Style', 'slider', 'Position', [50, 330, 300, 20], 'min', 0, 'max', 10, 'Value', 2, 'Callback', @updateGraphs);
    x0_val = uicontrol('Parent', f, 'Style', 'text', 'Position', [360, 330, 40, 20], 'String', '2');

    % Slider and value indicator for gamma_xy
    uicontrol('Parent', f, 'Style', 'text', 'Position', [50, 300, 100, 20], 'String', 'gamma_xy (0-0.4)');
    gamma_xy_slider = uicontrol('Parent', f, 'Style', 'slider', 'Position', [50, 280, 300, 20], 'min', 0, 'max', 0.5, 'Value', 0.01, 'Callback', @updateGraphs);
    gamma_xy_val = uicontrol('Parent', f, 'Style', 'text', 'Position', [360, 280, 40, 20], 'String', '0.1');

    % Function to update graphs and slider value indicators
    function updateGraphs(~, ~)
        % Read values from sliders
        x0 = get(x0_slider, 'Value');
        gamma_xy = get(gamma_xy_slider, 'Value');

        % Update slider value indicators
        set(x0_val, 'String', num2str(x0, '%.2f'));
        set(gamma_xy_val, 'String', num2str(gamma_xy, '%.2f'));

        % Call the function to plot the graphs
        plotGraphs(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x, t_fixed);
    end

    % Function to plot the graphs
    function plotGraphs(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x, t_fixed)
        % plotGraph1(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x);
        plotGraph2(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x, t_fixed);
        % plotGraph3(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x, t_fixed);
    end

    % Function to plot the first graph
    function plotGraph1(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x)
        y_values_1 = [0.1, 0.5, 1, 2, 3, 4, 5, 10, 20, 30, 35, 40, 50, 55, 100];
    
        figure;
        hold on;
    
        for y = y_values_1
            % Update parameter values with new x0 and gamma_xy
            parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];
    
            % Solver
            [t, x] = ode45(@hasty, [0, 10], x0, [], parvals);
    
            % Plot the solution
            p = plot(t, x, 'LineWidth', 2);
            text(t(end), x(end), sprintf('y = %g', y), 'FontSize', 8);
        end
    
        hold off;
        xlabel('Time', 'FontSize', 16);
        ylabel('c1 concentration', 'FontSize', 16);
        title('c1 concentration over time for various rcsA levels', 'FontSize', 16);
    end
    
    % Function to plot the second graph
    function plotGraph2(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x, t_fixed)
        y_values_2 = 0:100;
        x_diff = zeros(length(y_values_2), 1);
    
        for i = 1:length(y_values_2)
            y = y_values_2(i);
            parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];
            [t, x] = ode45(@hasty, [0, 10], x0, [], parvals);
    
            % Interpolate to find x at t_fixed and calculate the difference
            x_diff(i) = interp1(t, x, t_fixed) - x0;
        end
    
        % Calculate the intersection point
        sign_change_idx = find(diff(sign(x_diff)) ~= 0, 1, 'first');
        if ~isempty(sign_change_idx)
            y_interpolate = interp1(x_diff(sign_change_idx:sign_change_idx+1), y_values_2(sign_change_idx:sign_change_idx+1), 0);
        else
            y_interpolate = NaN; % No intersection found
        end
    
        % Plotting the graph
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
        title(sprintf('Diff from x0 at t = %g for y (x0 = %.2f, gamma_xy = %.2f)', t_fixed, x0, gamma_xy), 'FontSize', 16);
    end

    % Function to plot the third graph
    function plotGraph3(x0, gamma_xy, m, alpha, sigma1, sigma2, gamma_x, t_fixed)
        y_values_3 = 35:0.1:40;
        x_diff_3 = zeros(length(y_values_3), 1);
    
        for i = 1:length(y_values_3)
            y = y_values_3(i);
            parvals = [m, alpha, sigma1, sigma2, gamma_x, gamma_xy, y];
            [t, x] = ode45(@hasty, [0, 10], x0, [], parvals);
    
            % Interpolate to find x at t_fixed and calculate the difference
            x_diff_3(i) = interp1(t, x, t_fixed) - x0;
        end
    
        figure;
        hold on;
        plot(y_values_3, x_diff_3, '-o', 'LineWidth', 2);
        plot(y_values_3, zeros(size(y_values_3)), 'r--', 'LineWidth', 1.5); % Horizontal red dashed line at x = 0
        hold off;
    
        xlabel('y (rcsA concentration)', 'FontSize', 16);
        ylabel(sprintf('Difference in x from x0 at t = %g', t_fixed), 'FontSize', 16);
        title(sprintf('Difference from initial x0 at t = %g for y range 30 to 50', t_fixed), 'FontSize', 16);
    end
end
