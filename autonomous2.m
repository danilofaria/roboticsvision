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

function Autonomous2(serPort)
 img = imread('http://192.168.0.102/img/snapshot.cgi?');
 resolution=size(img);
 width=resolution(2);

 hsv_img=rgb2hsv(img);
 hsv_color = [0.6604 0.3397 0.6118];
 [largest_blob, max_area] = calculateBlob2( hsv_color, hsv_img )
 [centerPositionX, centerPositionY] = calculateCentroid( largest_blob, max_area );
 old_max_area = max_area;
 old_centerPositionX = centerPositionX;
 delta_area = 0;
 delta_x = 0;

 % The state of the robot
 current_pos_x = 0;
 current_pos_y = 0;
 current_angle = 0;
 % parameter for the velocity of the roomba

largest_door_area = 0
angle_largest_door = 0
%Define Robot States
LOOKING_FOR_DOOR = 0;
CENTERING_CENTROID = 1;
GO_STRAIGHT = 2;
KNOCKING = 3;

knocking_state = 0;
GO_BACK = 0;
GO_KNOCK = 1;

bump_pos_x = 0;
bump_pos_y = 0;
% no_bumps_so_far = true
% away_bump = false

% degrees per
spin_vel = 10*pi/180
currentState = LOOKING_FOR_DOOR;
SetFwdVelAngVelCreate(serPort,0, spin_vel);

% if max_area > 0
%  currentState = CENTERING_CENTROID;
% else    
%  SetFwdVelAngVelCreate(serPort,0, spin_vel);
%  currentState = LOOKING_FOR_DOOR;
% end



% Enter main loop
while true
    % Poll sensors
    [BumpRight, BumpLeft, WheDropRight, WheDropLeft, WheDropCaster, ...
        BumpFront] = BumpsWheelDropsSensorsRoomba(serPort);
    bumped=0;   
    bumped = BumpRight || BumpFront;
    
    % Wall = WallSensorReadRoomba(serPort);
    
    % Update current position
    distance = DistanceSensorRoomba(serPort);
    current_pos_x = current_pos_x+distance*cos(current_angle);
    current_pos_y = current_pos_y+distance*sin(current_angle);
    current_angle = current_angle+AngleSensorRoomba(serPort);

    % delta_area = max_area-old_max_area
    % delta_x = centerPositionX-old_centerPositionX

    % alpha=0.00008;
     eta = 0.0005;
    % SetFwdVelAngVelCreate(serPort,-delta_area*alpha,-delta_x*eta);
    
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
       case LOOKING_FOR_DOOR
            if (max_area > largest_door_area)
                largest_door_area = max_area
                angle_largest_door = current_angle
            end
            if current_angle > 2*pi
                turnAngle(serPort, 0.05, angle_largest_door*180/pi);
                currentState = CENTERING_CENTROID;
            end    
        case CENTERING_CENTROID
            centering_trheshold = 50;
            delta_x = centerPositionX-width/2
            if abs(delta_x) < centering_trheshold 
                currentState = GO_STRAIGHT;
            else
                SetFwdVelAngVelCreate(serPort,0,-delta_x*eta);
            end
        case GO_STRAIGHT
            SetFwdVelAngVelCreate(serPort,0.1,0);
            if bumped
                currentState = KNOCKING;
                knocking_state = GO_BACK;
                bump_pos_x = current_pos_x; 
                bump_pos_y = current_pos_y;
                SetFwdVelAngVelCreate(serPort,-0.15,0);
            end
        case KNOCKING
            distance_bump = sqrt((bump_pos_x- current_pos_x)^2+(bump_pos_y- current_pos_y)^2);
            switch(knocking_state)
                case GO_BACK
                    SetFwdVelAngVelCreate(serPort,-0.15,0);
                    if distance_bump > 0.1
                        SetFwdVelAngVelCreate(serPort,0.15,0);
                        knocking_state = GO_KNOCK;
                    end
                case GO_KNOCK
                    SetFwdVelAngVelCreate(serPort,0.15,0);
                    if bumped
                        %make noise
                        %call it a day
                        fwrite(serPort, [140 3 7 48 40 48 40 55 40 55 40 57 40 57 40 55 80]);
                        fwrite(serPort, [141 3])
                        SetFwdVelAngVelCreate(serPort,0,0);
                        break;
                    end   
            end
        otherwise
    end
    
    pause(0.3)

    img = imread('http://192.168.0.102/img/snapshot.cgi?');
    hsv_img=rgb2hsv(img);
    [largest_blob, max_area] = calculateBlob2( hsv_color, hsv_img );
    [centerPositionX, centerPositionY] = calculateCentroid( largest_blob, max_area );

end
end

