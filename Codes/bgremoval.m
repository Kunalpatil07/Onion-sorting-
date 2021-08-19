
Background=imread('black.jpeg');
% Background=imresize(J,0.5);
CurrentFrame=imread('on1.jpeg');
%CurrentFrame =imresize(I,0.5);

subplot(2,2,1);imshow(Background);title('BackGround');
subplot(2,2,2);imshow(CurrentFrame);title('Current Frame');


[Background_hsv]=round(rgb2hsv(Background));
[CurrentFrame_hsv]=round(rgb2hsv(CurrentFrame));
Out = bitxor(Background_hsv,CurrentFrame_hsv);
%Out =imresize(Out1,0.5);

Out=rgb2hsv(Out);

subplot(2,2,3) ; imshow(Out); title('Test');

[rows columns]=size(Out);



for i=1:rows
for j=1:columns

if Out(i,j) >0

BinaryImage(i,j)=1;

else

BinaryImage(i,j)=0;

end

end
end

imshow(BinaryImage);

%Apply Median filter to remove Noise
FilteredImage=medfilt2(BinaryImage,[6 6]);



%Boundary Label the Filtered Image
[L num]=bwlabel(FilteredImage);

STATS=regionprops(L,'all');
cc=[];
removed=0;


%Remove the noisy regions
for i=1:num
dd=STATS(i).Area;

if (dd < 500)

L(L==i)=0;
removed = removed + 1;
num=num-1;

else

end

end

[L2 num2]=bwlabel(L);


% Trace region boundaries in a binary image.

[B,L,N,A] = bwboundaries(L2);

%Plot the Blob features

%Display results

subplot(2,2,3),  imshow(L2);title('BackGround Detected');
subplot(2,2,4),  imshow(L2);title('Blob Detected');

hold on;

for k=1:length(B),

if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);

for l=find(A(:,k))'
boundary = B{l};
plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
end

end

end
