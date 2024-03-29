%----------------------------QRtoSTL-----------------------%
% -Input one or two qr codes to be converted into an 3D matrix of cubes in
% stl format
% -If only one embedded code is desired then name the false QR "ONLYONE"
% -If two embedded codes are desired, they must have the same
% cellsize, cell dimension, and quiet space size
% -This MATLAB code is designed to work with any two codes from the same
% qr generator

clear; clc;

factor=0; applyfog=false;
CorrectQR = 'Embedded Code.png'; %input('Please input the filename of the Correct QR code =>','s');

FalseQR = 'ONLYONE'; %input('Now input the filename of the False QR code =>','s');


str = input('Add a Fog? Y/N: ','s');

if strcmp(str,'Y')
    applyfog=true;
    str1 = input('Fog Size? 2 - 3 - 4 - 5: ');
    factor = str1;
end

if strcmp(FalseQR,'ONLYONE') %check to see if there are one or two qr codes
    
    [ARRAY,cellsize,allDetectedOrigins,placement]=singleEmbeddedCode_(CorrectQR,factor);
    
else
    [ARRAY]=doubleEmbeddedCode_(CorrectQR,FalseQR);
end

if applyfog
    
    if ~strcmp(FalseQR,'ONLYONE')
        disp('Adding Second Code...')
        [ARRAY] = SecondEmbeddedCode_(ARRAY,FalseQR,allDetectedOrigins,placement,factor);
    end
    disp('Generating Fog...')
    
    [ARRAY,allDetectedOrigins]=FOGgenerator_(ARRAY,cellsize,placement,allDetectedOrigins);
    
end

size(allDetectedOrigins)
str2 = input('Do you want Spherical parts Y/N: ','s');

if strcmp(str2,'Y')
    disp('Converting to Spheres...')
    [faces, vertices]=cube2sphere_(allDetectedOrigins,cellsize);
    
    stlfilename = strcat('QRstl-',CorrectQR(1:end-4),'-',FalseQR(1:end-4),'.stl'); %create a unique filename / (1:end-4) removes the .png or .jpg from the strings
    disp('Generating STL...')
    stlwrite(stlfilename,faces,vertices);%downloaded function which triangulates the data
else
    disp('Generating STL...')
    fv = isosurface(~ ARRAY, 0);
    stlfilename = strcat('QRstl-',CorrectQR(1:end-4),'-',FalseQR(1:end-4),'.stl');
    stlwrite(stlfilename,fv)
end%downloaded function which triangulates the data

%stlwrite should display "Wrote 3 faces" in the command line
