function Test()
 hsv_color=InitColorTracker();
 while(1)
 	img = imread('http://192.168.0.102/img/snapshot.cgi?');
	hsv_img=rgb2hsv(img);
	[largest_blob, max_area] = calculateBlob( hsv_color, hsv_img )
 	[x,y]=calculateCentroid( largest_blob, max_area )
 	%Plot Centroid
 	figure();
 	imshow(largest_blob);
 	hold on; line(x, y, 'Marker', '*', 'MarkerEdgeColor', 'r');
 	pause(0.1)
 end
end