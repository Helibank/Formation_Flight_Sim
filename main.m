close all;
clear all;
clc;
disp('Formation program start!!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%init%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num=4;%�����ӵ����˻���ʼ����
target_num=4;
quad_init_x=12*rand(num,1);%��ʼλ������
quad_init_y=12*rand(num,1);
goal=[3 3;
      3 8;
      8 3;
      8 8];% Ŀ���λ�� [x(m),y(m)]
temp_goal=goal;
goal_series=[1;2;3;4];
obstacleR=0.5;% ��ͻ�ж��õ��ϰ���뾶
global dt; dt=0.1;% ʱ��[s]

% �������˶�ѧģ��
% ����ٶ�m/s],�����ת�ٶ�[rad/s],���ٶ�[m/ss],��ת���ٶ�[rad/ss],
% �ٶȷֱ���[m/s],ת�ٷֱ���[rad/s]]
Kinematic=[1.0,toRadian(25.0),0.2,toRadian(50.0),0.01,toRadian(1)];
% ���ۺ������� [heading,dist,velocity,predictDT]
evalParam=[0.1,0.3,0.1,3.0 ];
area=[-1 12 -1 12];% ģ������Χ [xmin xmax ymin ymax]
mirror_dis=zeros(4,4);
% ģ��ʵ��Ľ��
result.quad1=[];
result.quad2=[];
result.quad3=[];
result.quad4=[];
traj1=[];
traj2=[];
traj3=[];
traj4=[];
tic;
% Main loop
writerObj=VideoWriter('formation.avi');  % ����һ����Ƶ�ļ������涯��  
open(writerObj);                    % �򿪸���Ƶ�ļ�  
%Target Allocation
[goal]=Target_Allocation(goal,quad_init_x,quad_init_y,num,target_num,goal_series,temp_goal,mirror_dis);
x=[quad_init_x(1,1) quad_init_y(1,1) atan2((goal(1,2)-quad_init_y(1,1)),(goal(1,1)-quad_init_x(1,1))) 0 0;
   quad_init_x(2,1) quad_init_y(2,1) atan2((goal(2,2)-quad_init_y(2,1)),(goal(2,1)-quad_init_x(2,1))) 0 0;
   quad_init_x(3,1) quad_init_y(3,1) atan2((goal(3,2)-quad_init_y(3,1)),(goal(3,1)-quad_init_x(3,1))) 0 0;
   quad_init_x(4,1) quad_init_y(4,1) atan2((goal(4,2)-quad_init_y(4,1)),(goal(4,1)-quad_init_x(4,1))) 0 0]';% �����˵ĳ���״̬[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
% x=[quad_init_x(1,1) quad_init_y(1,1) pi/2 0 0;
%    quad_init_x(2,1) quad_init_y(2,1) pi/2 0 0;
%    quad_init_x(3,1) quad_init_y(3,1) pi/2 0 0;
%    quad_init_x(4,1) quad_init_y(4,1) pi/2 0 0]';% �����˵ĳ���״̬[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:5000
    % DWA��������
    obstacle1=[x(1,2) x(2,2);x(1,3) x(2,3);x(1,4) x(2,4)];
    obstacle2=[x(1,1) x(2,1);x(1,3) x(2,3);x(1,4) x(2,4)];
    obstacle3=[x(1,1) x(2,1);x(1,2) x(2,2);x(1,4) x(2,4)];
    obstacle4=[x(1,1) x(2,1);x(1,2) x(2,2);x(1,3) x(2,3)];
    if norm(x(1:2,1)-goal(1,:)')>0.1
        [x(:,1),traj1]=distributed_planning(x(:,1),Kinematic,goal(1,:),evalParam,obstacle1,obstacleR);
    end
    if norm(x(1:2,2)-goal(2,:)')>0.1
        [x(:,2),traj2]=distributed_planning(x(:,2),Kinematic,goal(2,:),evalParam,obstacle2,obstacleR);
    end
    if norm(x(1:2,3)-goal(3,:)')>0.1
        [x(:,3),traj3]=distributed_planning(x(:,3),Kinematic,goal(3,:),evalParam,obstacle3,obstacleR);
    end
    if norm(x(1:2,4)-goal(4,:)')>0.1
        [x(:,4),traj4]=distributed_planning(x(:,4),Kinematic,goal(4,:),evalParam,obstacle4,obstacleR);
    end
    
    % ģ�����ı���
    result.quad1=[result.quad1; x(:,1)'];
    result.quad2=[result.quad2; x(:,2)'];
    result.quad3=[result.quad3; x(:,3)'];
    result.quad4=[result.quad4; x(:,4)'];
    % �Ƿ񵽴�Ŀ�ĵ�
    if norm(x(1:2,1)-goal(1,:)')<0.1 && norm(x(1:2,2)-goal(2,:)')<0.1 && norm(x(1:2,3)-goal(3,:)')<0.1 && norm(x(1:2,4)-goal(4,:)')<0.1
        disp('Arrive Goal!!');break;
    end
    
    %====Animation====
    hold off;
    ArrowLength=0.5;% 
    % ������

    plot(result.quad1(:,1),result.quad1(:,2),'-b');hold on;
    plot(result.quad2(:,1),result.quad2(:,2),'-m');hold on;
    plot(result.quad3(:,1),result.quad3(:,2),'-r');hold on;
    plot(result.quad4(:,1),result.quad4(:,2),'-c');hold on;    
    plot(goal(1,1),goal(1,2),'*b');hold on;
    plot(goal(2,1),goal(2,2),'*m');hold on;
    plot(goal(3,1),goal(3,2),'*r');hold on;
    plot(goal(4,1),goal(4,2),'*c');hold on;
%     for s = 1:length(obstacle(:,1))
%         Circle(obstacle(s,1),obstacle(s,2),obstacleR);hold on;
%     end
    % ̽���켣
    if ~isempty(traj1)
        for it=1:length(traj1(:,1))/5
            ind=1+(it-1)*5;
            plot(traj1(ind,:),traj1(ind+1,:),'-g');hold on;
        end
    end
    
    if ~isempty(traj2)
        for it=1:length(traj2(:,1))/5
            ind=1+(it-1)*5;
            plot(traj2(ind,:),traj2(ind+1,:),'-g');hold on;
        end
    end
        
    if ~isempty(traj3)
        for it=1:length(traj3(:,1))/5
            ind=1+(it-1)*5;
            plot(traj3(ind,:),traj3(ind+1,:),'-g');hold on;
        end
    end
        
    if ~isempty(traj4)
        for it=1:length(traj4(:,1))/5
            ind=1+(it-1)*5;
            plot(traj4(ind,:),traj4(ind+1,:),'-g');hold on;
        end
    end
%     DrawQuadrotor(x(1,1),x(2,1));
    quiver(x(1,1),x(2,1),ArrowLength*cos(x(3,1)),ArrowLength*sin(x(3,1)),'ok');hold on;
%     DrawQuadrotor(x(1,2),x(2,2));
    quiver(x(1,2),x(2,2),ArrowLength*cos(x(3,2)),ArrowLength*sin(x(3,2)),'ok');hold on;
%     DrawQuadrotor(x(1,3),x(2,3));
    quiver(x(1,3),x(2,3),ArrowLength*cos(x(3,3)),ArrowLength*sin(x(3,3)),'ok');hold on;
%     DrawQuadrotor(x(1,4),x(2,4));
    quiver(x(1,4),x(2,4),ArrowLength*cos(x(3,4)),ArrowLength*sin(x(3,4)),'ok');hold on;    
    axis(area);
    grid on;
    drawnow;
    frame = getframe;            %// ��ͼ�������Ƶ�ļ���  
    writeVideo(writerObj,frame); %// ��֡д����Ƶ  
end
toc
close(writerObj); %// �ر���Ƶ�ļ����  
close all;