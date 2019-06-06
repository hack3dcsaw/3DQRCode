%----------------------------QRtoSTL-----------------------%
% -Input one or two qr codes to be converted into an 3D matrix of cubes in
% stl format
% -If only one embedded code is desired then name the false QR "ONLYONE"
% -If two embedded codes are desired, they must have the same 
% cellsize, cell dimension, and quiet space size
% -This MATLAB code is designed to work with any two codes from the same
% qr generator

clear; clc;
CorrectQR = 'Correct QR.png'; %input('Please input the filename of the Correct QR code =>','s');
FalseQR = 'ONLYONE'; %input('Now input the filename of the False QR code =>','s');

if strcmp(FalseQR,'ONLYONE') %check to see if there are one or two qr codes
    [ARRAY, allDetectedOrigins]=singleEmbeddedCode_(CorrectQR);
else
    [ARRAY]=doubleEmbeddedCode_(CorrectQR,FalseQR);
end
    
stlfilename = strcat('QRstl-',CorrectQR(1:end-4),'-',FalseQR(1:end-4),'.stl'); %create a unique filename / (1:end-4) removes the .png or .jpg from the strings

x = allDetectedOrigins(:,1); %store all x values in a col
y = allDetectedOrigins(:,2); %store all y values in a col
z = allDetectedOrigins(:,3); %store all z values in a col

rad = 3; %radius of spheres in spherical QRcode
res = 15; %number of faces of spheres in spherical QRcode
m = size(allDetectedOrigins); %the number of spheres
m = m(:,1);
[sx,sy,sz] = sphere(res);

figure
hold on
for i = 1:m
    fv(i) = patch(surf2patch(rad*sx + x(i),rad*sy + y(i),rad*sz + z(i), 'triangles'), 'EdgeColor', 'none', 'FaceColor', 'black');
    %surfObj = surf(rad*sx + x(i),rad*sy + y(i),rad*sz + z(i), 'EdgeColor', 'none', 'FaceColor', 'black');
end



% fv = isosurface(~ ARRAY, 0); 
%stlwrite(stlfilename,fv) %downloaded function which triangulates the data
%stlwrite should display "Wrote 3 faces" in the command line
