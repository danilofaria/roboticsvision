function [hsv_color, hsv_img] = InitColorTracker()
 img = imread('http://192.168.0.102/img/snapshot.cgi?');
 disp('===============');
 disp('Click on a pixel to init color tracker with the color of that pixel and press enter');
 
 imshow(img);
 coords=ginput(1);

 hsv_img=rgb2hsv(img);
 hsv_color = impixel(hsv_img,coords(1),coords(2));
 % [largest_blob, max_area] = calculateBlob( hsv_color, hsv_img )
end

