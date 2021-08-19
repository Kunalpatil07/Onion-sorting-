vid = videoinput('webcam', 1, 'YUY2_800x600');
set(vid,'ReturnedColorSpace','RGB');
preview(vid);
pause(3.00);
img=getsnapshot(vid);
stoppreview(vid);