function Vr=CalcDynamicWindow(x,model)
%
global dt;
% �����ٶȵ������С��Χ
Vs=[model(1) model(2) model(1) model(2)];

% ���ݵ�ǰ�ٶ��Լ����ٶ����Ƽ���Ķ�̬����
Vd=[x(3)-model(3)*dt x(3)+model(3)*dt x(4)-model(4)*dt x(4)+model(4)*dt];

if Vd(:,1)>Vs(:,1)
    Vr(:,1)=Vd(:,1);
else
    Vr(:,1)=Vs(:,1);
end

if Vd(:,2)<Vs(:,2)
    Vr(:,2)=Vd(:,2);
else
    Vr(:,2)=Vs(:,2);
end

if Vd(:,3)>Vs(:,3)
    Vr(:,3)=Vd(:,3);
else
    Vr(:,3)=Vs(:,3);
end

if Vd(:,4)<Vs(:,4)
    Vr(:,4)=Vd(:,4);
else
    Vr(:,4)=Vs(:,4);
end
