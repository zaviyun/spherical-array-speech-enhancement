
function points = ringOnSphere(O, H, num_points, r)
% ringOnSphere Generates equally spaced points on a spherical ring.
%
%   points = ringOnSphere(O, H, num_points, r) generates equally spaced
%   points on the intersection of a sphere and a plane perpendicular
%   to the vector OH and passing through point H.
%
% Inputs:
%   O          - Sphere center in Cartesian coordinates [x, y, z].
%   H          - Center of the circular ring [x, y, z].
%   num_points - Number of equally spaced points on the ring.
%   r          - Radius of the sphere.
%
% Output:
%   points     - num_points-by-3 matrix containing the Cartesian
%                coordinates of the generated points.
%
% Author:      Amin Aslanzadeh
% Date:        April 2024
% Contact:     Amin.Aslanzadeh.M@gmail.com
%
% Example:
%   O = [0, 0, 0];
%   H = [-0.0324, -0.0243, -0.0081];
%   num_points = 32;
%   r = 0.042;
%   points = ringOnSphere(O, H, num_points, r);

    %% Input Validation
    validateattributes(O, {'numeric'}, ...
        {'real', 'finite', 'vector', 'numel', 3}, mfilename, 'O');

    validateattributes(H, {'numeric'}, ...
        {'real', 'finite', 'vector', 'numel', 3}, mfilename, 'H');

    validateattributes(num_points, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'integer', 'positive'}, ...
        mfilename, 'num_points');

    validateattributes(r, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'positive'}, mfilename, 'r');

    O = O(:).';
    H = H(:).';

    %% Calculate the Direction Vector
    OH = H - O;
    normOH = norm(OH);

    if normOH == 0
        error('ringOnSphere:CoincidentPoints', ...
            'Points O and H must be different.');
    end

    if normOH > r
        error('ringOnSphere:PointOutsideSphere', ...
            'Point H must lie inside or on the sphere.');
    end

    %% Calculate the Ring Radius
    d = sqrt(max(0, r^2 - normOH^2));

    %% Calculate a Perpendicular Unit Vector
    if OH(1) ~= 0 || OH(3) ~= 0
        v = [-OH(3), 0, OH(1)];
    else
        v = [0, -OH(3), OH(2)];
    end

    perp_vector = cross(OH, v);
    perp_vector = perp_vector / norm(perp_vector);

    %% Generate Points Using Rodrigues' Rotation Formula
    rotation_axis = OH / normOH;
    angle = 2 * pi / num_points;

    points = zeros(num_points, 3);

    for i = 1:num_points

        theta = angle * (i - 1);

        ux = rotation_axis(1);
        uy = rotation_axis(2);
        uz = rotation_axis(3);

        c = cos(theta);
        s = sin(theta);

        % Rodrigues' rotation matrix
        R = [
            c + ux^2 * (1-c),       ux*uy*(1-c)-uz*s,   ux*uz*(1-c)+uy*s;
            uy*ux*(1-c)+uz*s,       c + uy^2*(1-c),     uy*uz*(1-c)-ux*s;
            uz*ux*(1-c)-uy*s,       uz*uy*(1-c)+ux*s,   c + uz^2*(1-c)
        ];

        rotated_vector = R * perp_vector';

        points(i, :) = H + d * rotated_vector';

    end

end
