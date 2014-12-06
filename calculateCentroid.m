function [centerPositionX, centerPositionY] = calculateCentroid( blob, area )

 [rows,columns] = size(blob);
 j = ones(rows,1)*[1:columns];
 i = [1:rows]'*ones(1,columns);

 % ----------------------------
 % Calculate Centroid
 % ----------------------------
 centerPositionX = sum(sum(double(blob).*j))/area;
 centerPositionY = sum(sum(double(blob).*i))/area;
end