
function point = coordPoint(A, B, dis)
% coordPoint Computes a point on the line passing through A and B.
%
%   point = coordPoint(A, B, dis) calculates the coordinates of point C,
%   located at distance dis from point A along the direction from A to B.
%
%   Scenario:
%
%       |------- dis -------|
%       A___________________C______________________B
%
% Inputs:
%   A   - Coordinates of point A in Cartesian coordinates [x, y, z].
%   B   - Coordinates of point B in Cartesian coordinates [x, y, z].
%   dis - Distance of point C from point A along the line AB.
%
% Output:
%   point - Cartesian coordinates of point C [x, y, z].
%
% Author:      Amin Aslanzadeh
% Date:        April 2024
% Contact:     Amin.Aslanzadeh.M@gmail.com
%
% Example:
%   A = [0, 0, 0];
%   B = [1, 1, 1];
%   dis = 2;
%   point = coordPoint(A, B, dis);

    %% Input Validation
    validateattributes(A, {'numeric'}, ...
        {'real', 'finite', 'vector', 'numel', 3}, mfilename, 'A');

    validateattributes(B, {'numeric'}, ...
        {'real', 'finite', 'vector', 'numel', 3}, mfilename, 'B');

    validateattributes(dis, {'numeric'}, ...
        {'real', 'finite', 'scalar'}, mfilename, 'dis');

    %% Coordinate Calculation
    A = A(:).';
    B = B(:).';

    AB = B - A;
    normAB = norm(AB);

    if normAB == 0
        error('coordPoint:CoincidentPoints', ...
            'Points A and B must be different.');
    end

    unitAB = AB / normAB;
    point = A + dis * unitAB;

end
