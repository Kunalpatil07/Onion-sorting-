clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 13;
% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
  % User does not have the toolbox installed.
  message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
  reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
  if strcmpi(reply, 'No')
    % User said No, so exit.
    return;
  end
end
% Read in a standard MATLAB color demo image.
folder = 'C:\Users\INDIA\Desktop\matlab codes';
baseFileName = 'on1.jpeg';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
  % Didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 3, 1);
imshow(rgbImage);
%{
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Get the dimensions of the image.  
% numberOfColorBands should be = 3 for an RGB image.
[rows, columns, numberOfColorBands] = size(rgbImage);
if numberOfColorBands > 1
  % Convert it to gray scale by taking only the green channel.
  % The green channel will have the highest contrast for these green seeds.
  grayImage = rgbImage(:, :, 2); % Take green channel.
end
% Display the original green channel gray scale image.
subplot(2, 3, 2);
imshow(grayImage, []);
title('Green Channel Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
% Let's compute and display the histogram.
[pixelCount, grayLevels] = imhist(grayImage);
subplot(2, 3, 3); 
bar(grayLevels, pixelCount);
grid on;
title('Histogram of Green Channel', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
%}
% Create a binary image via thresholding.
binaryImage = grayImage > 55;
% Display the image.
subplot(2, 3, 4);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize);
% Clean up.
binaryImage = imclearborder(binaryImage);
binaryImage = imfill(binaryImage, 'holes');
binaryImage = bwareaopen(binaryImage, 500);
% Display the image.
subplot(2, 3, 5);
imshow(binaryImage, []);
title('Cleaned Binary Image', 'FontSize', fontSize);

% Mask the RGB image using bsxfun() function
maskedRgbImage = bsxfun(@times, rgbImage, cast(binaryImage, class(rgbImage)));
% Display the image.
subplot(2, 3, 6);
imshow(maskedRgbImage, []);
title('Masked RGB Image', 'FontSize', fontSize);