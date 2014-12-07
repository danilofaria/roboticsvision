function [largest_blob, max_area] = calculateBlob( hsv_color, hsv_img )
 hsv_mask_range=0.1;
 
 lower_hue = hsv_color(1)-hsv_mask_range;
 if (lower_hue < 0)
 	hsv_mask = hsv_img(:,:,1) >= lower_hue | hsv_img(:,:,1) >= 1+lower_hue ;
 else
	hsv_mask = hsv_img(:,:,1) >= lower_hue;
 end
 upper_hue = hsv_color(1)+hsv_mask_range;
 if (upper_hue > 1)
  hsv_mask = hsv_mask & (hsv_img(:,:,1) < upper_hue | hsv_img(:,:,1) < 1-upper_hue);
 else
  hsv_mask = hsv_mask & hsv_img(:,:,1) < upper_hue;
 end
 
 hsv_mask_range=0.3;
 hsv_mask = hsv_mask & hsv_img(:,:,2) >= hsv_color(2)-hsv_mask_range & hsv_img(:,:,2) < hsv_color(2)+hsv_mask_range; %& img(:,:,2) > color(2)-mask_range & img(:,:,2) < color(2)+mask_range & img(:,:,3) > color(3)-mask_range & img(:,:,3) < color(3)+mask_range 
 %hsv_mask_range=0.1;
 %hsv_mask = hsv_mask & hsv_img(:,:,3) >= hsv_color(3)-hsv_mask_range & hsv_img(:,:,3) < hsv_color(3)+hsv_mask_range; 
 figure();
 imshow(hsv_mask);
 hsv_mask= bwmorph(hsv_mask, 'erode',3)
 
 figure();
 imshow(hsv_mask);
 
 labeled_img = bwlabel(hsv_mask);
 num = max(unique(labeled_img));
 max_area = 0;

 for a = 1:num
    %find specific object
     objectlabel = a;
     regionOfObject = (labeled_img==a);
     areaOfObject = sum(regionOfObject(:));
     if (areaOfObject > max_area)
     	max_area = areaOfObject;
     	largest_blob = regionOfObject;
     end
 end
 
 if(max_area >0)
    largest_blob= bwmorph(largest_blob, 'dilate',3)
 else
     largest_blob =0;
 end
 
 
%  figure();
%  imshow(largest_blob);
 % [x,y]=calculateCentroid( largest_blob, max_area )
 %Plot Centroid
 % hold on; line(x, y, 'Marker', '*', 'MarkerEdgeColor', 'r');
end
