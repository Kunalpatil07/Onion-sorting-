% Read background images
Background=imread('black.jpeg');
 
% Read the current frame image
CurrentFrame=imread('on2.jpeg');
 
% Convert images to grayscale
Background_gray = rgb2gray(Background);
CurrentFrame_gray = rgb2gray(CurrentFrame);
 
% Reduction of grayscale imagery
Subtraction = (double(Background_gray)-double(CurrentFrame_gray));
Min_S = min(Subtraction(:));
Max_S = max(Subtraction(:));
Subtraction = ((Subtraction-Min_S)/(Max_S-Min_S))*255;
Subtraction = uint8(Subtraction);
 
% Converting images to binary using the Otsu method
Subtraction = ~im2bw(Subtraction,graythresh(Subtraction));
 
% Morphological surgery
bw = imfill(Subtraction,'holes');
bw = bwareaopen(bw,5000);
 
% Making masking and cropping processes
[row,col] = find(bw==1);
h_bw = imcrop(CurrentFrame,[min(col) min(row) max(col)-min(col) max(row)-min(row)]);
 
[a,b] = size(bw);
mask = false(a,b);
mask(min(row):max(row),min(col):max(col)) = 1;
mask =  bwperim(mask,8);
mask = imdilate(mask,strel('square',3));
 
R = CurrentFrame(:,:,1);
G = CurrentFrame(:,:,2);
B = CurrentFrame(:,:,3);
 
R(mask) = 255;
G(mask) = 0;
B(mask) = 0;
 
RGB = cat(3,R,G,B);
figure, imshow(RGB);