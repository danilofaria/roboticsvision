%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMS W4733 Computational Aspects of Robotics 2014
%
% Homework 5
%
% Team number: 6
% Team leader: Bach Nguyen (bn2252)
% Team members: Danilo Faria (df2553) Daniel Cintra (dl2901)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Autonomous(serPort)

[hsv_color, hsv_img] = InitColorTracker();
[largest_blob, max_area] = calculateBlob( hsv_color, hsv_img )
[centerPositionX, centerPositionY] = calculateCentroid( largest_blob, max_area )
old_max_area = max_area
old_centerPositionX = centerPositionX
delta_area = 0
delta_x = 0

% The state of the robot
current_pos_x = 0;
current_pos_y = 0;
current_angle = 0;
currentState = 0;
% parameter for the velocity of the roomba
max_v = 0.3 % max possible is 0.5, however it seems to introduce too much error
SetFwdVelAngVelCreate(serPort,max_v,0);

% bump_pos_x = 0
% bump_pos_y = 0
% no_bumps_so_far = true
% away_bump = false

% Enter main loop
while true
    % Poll sensors
    [BumpRight, BumpLeft, WheDropRight, WheDropLeft, WheDropCaster, ...
        BumpFront] = BumpsWheelDropsSensorsRoomba(serPort);

    
    bumped= BumpRight || BumpFront;
    
    Wall = WallSensorReadRoomba(serPort);
    
    % Update current position
    distance = DistanceSensorRoomba(serPort);
    current_pos_x = current_pos_x+distance*cos(current_angle)
    current_pos_y = current_pos_y+distance*sin(current_angle)
    current_angle = current_angle+AngleSensorRoomba(serPort)

    delta_area = max_area-old_max_area
    delta_x = centerPositionX-old_centerPositionX

    alpha=0.1
    eta = 0.1
    SetFwdVelAngVelCreate(serPort,-delta_area*alpha,-delta_x*eta);
    
    % if (delta_x > 0)
    %     % turn right
    % else
    %     % turn left
    % end
    % if (delta_area > 0)
    %     % go backwards
    % else
    %     % go forward
    % end

    switch(currentState)
            
        otherwise
    end
    
    pause(0.3)

    old_max_area = max_area
    old_centerPositionX = centerPositionX
    img = imread('http://192.168.0.102/img/snapshot.cgi?');
    hsv_img=rgb2hsv(img);
    [largest_blob, max_area] = calculateBlob( hsv_color, hsv_img )
    [centerPositionX, centerPositionY] = calculateCentroid( largest_blob, max_area )

end
end

