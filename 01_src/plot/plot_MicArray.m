
function plot_MicArray(Theta, Phi, R)
%% About Program
% Author:      Amin Aslanzadeh
% Date:        October, 2023
% Description: Plots a spherical microphone array and displays the
%              microphone indices according to their position order.
%
% Inputs:
%   Theta - Elevation angles of microphone positions (rad)
%   Phi   - Azimuth angles of microphone positions (rad)
%   R     - Radius of the spherical array (m)
%
% Contact:     Aslanzadeh.Amin78@gmail.com

%% Array Configuration

% Number of microphones
nMics = length(Theta);

% Array center
arrayCenter = [3, 2.5, 1.5];

% Camera viewing angles
thk = 51.33;
phk = 90;

%% Microphone Positions

% Convert spherical coordinates to Cartesian coordinates
X = R * sin(Theta) .* cos(Phi);
Y = R * sin(Theta) .* sin(Phi);
Z = R * cos(Theta);

% Shift microphone positions to the array center
X = X + arrayCenter(1);
Y = Y + arrayCenter(2);
Z = Z + arrayCenter(3);

%% Spherical Surface

% Generate a unit sphere
[XSph, YSph, ZSph] = sphere;

% Scale and shift the sphere
XSph = R * XSph + arrayCenter(1);
YSph = R * YSph + arrayCenter(2);
ZSph = R * ZSph + arrayCenter(3);

%% Plot Microphone Array

figure;

% Plot microphones
plot3(X, Y, Z, ...
    'Marker', 'o', ...
    'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'k', ...
    'MarkerSize', 20);

hold on;

% Initial axis settings
set(gca, 'ClippingStyle', 'rectangle');
xlim([0 6]);
ylim([0 5]);
zlim([0 4]);

%% Plot Spherical Surface

surf(XSph, YSph, ZSph, ...
    'FaceColor', 'g', ...
    'EdgeColor', 'k');

view(thk, phk);

%% Display Microphone Indices

for q = 1:nMics
    text( ...
        arrayCenter(1) + 1.1 * (X(q) - arrayCenter(1)), ...
        arrayCenter(2) + 1.1 * (Y(q) - arrayCenter(2)), ...
        arrayCenter(3) + 1.1 * (Z(q) - arrayCenter(3)), ...
        num2str(q), ...
        'Color', 'y', ...
        'FontSize', 15);
end

%% Plot Additional Reference Point

plot3(1, 1, 1, ...
    'Marker', 'o', ...
    'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'k', ...
    'MarkerSize', 40);

%% Figure Settings

set(gca, 'ClippingStyle', 'rectangle');

axis equal;

% Final axis limits (preserved from the original implementation)
xlim([0 4]);
ylim([0 6]);
zlim([0 5]);

xlabel('X');
ylabel('Y');
zlabel('Z');

title('Microphone Arrangement in Spherical Array');

grid on;
lighting gouraud;
camlight('right');

hold off;

end
