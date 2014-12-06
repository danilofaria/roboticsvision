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

% The state of the robot
current_pos_x = 0;
current_pos_y = 0;
current_angle = 0;

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
    
    switch(currentState)
            
        otherwise
    end
    
    pause(0.1)
end
end

