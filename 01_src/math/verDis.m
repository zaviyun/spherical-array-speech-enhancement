function dis = verDis(O,B,S)
%% About program
% Author:      Amin Aslanzadeh
% Date:        April,2024
% Discription: O and S are on line D and B is a point outside the line D. 
%              This is a function that take 3 points of space(O,B,S) then
%              calcualate veritical distance of point B from line D.

%        -Spherical Array-
%            ******* B.
%        *             *    |   |    |   | |
%      *                 *  |   |    |   | |
%     *                   * |   |    |   | |
%    *           O.........*|...|....|...|.|.S.............(D)
%     *                   * |   |    |   | |
%      *                 *  |   |    |   | |
%        *             *    |   |    |   | |
%            *******
%
% Contact:     Amin.Aslanzadeh.M@gmail.com
%/////////////////////////////////Manuals\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% O------------------------Coordinates of Origin or every point on line
%                          (For array this is origin of Sphere) in
%                          cartesian coordinates
% B------------------------Coordinates of point outside the line (For array
%                          this is microphones coordinates) in cartesian 
%                          coordinates
% S------------------------Coordinates of other point on line (For array 
%                          this is source coordinates) in cartesian 
%                          coordinates
% verDis-------------------Veritical distance of point B from line D
%/////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%% Setup:
%-------------------------------------------
U_D = S - O;
OB = B - O;
hh = norm(cross(U_D,OB))/norm(U_D);
BS = S - B;
dis = sqrt((norm(BS))^2 - hh^2);
end