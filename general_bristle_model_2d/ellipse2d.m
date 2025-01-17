function ellipse_points = ellipse2d(F)
    % Define the angles
    theta = linspace(0, 2*pi, 100);
    
    % Create the unit circle
    unit_circle_x = cos(theta);
    unit_circle_y = sin(theta);
    
    % Initialize the ellipse points
    ellipse_points = zeros(2, length(theta));
    
    % Transform the unit circle to the ellipse using inv(F)
    for i = 1:length(theta)
        unit_point = [unit_circle_x(i); unit_circle_y(i)];
        ellipse_point = F * unit_point;
        ellipse_points(:, i) = ellipse_point;
    end

