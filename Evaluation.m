function [evalDB,trajDB]=Evaluation(x,Vr,goal,ob,R,model,evalParam)% ���ۺ����ļ���
% 
evalDB=[];
trajDB=[];
for vt=Vr(1):model(5):Vr(2)
    for ot=Vr(3):model(6):Vr(4)%�������п��ܵ��ٶȺͽ��ٶ�
        % �켣�Ʋ�; �õ� xt: ��������ǰ�˶����Ԥ��λ��; traj: ��ǰʱ�� �� Ԥ��ʱ��֮��Ĺ켣
        [xt,traj]=GenerateTrajectory(x,vt,ot,evalParam(4),model);  %evalParam(4),ǰ��ģ��ʱ��;
        % �����ۺ����ļ���
        dist=CalcDistEval(xt,ob,R);
        Predist=CalcPreDist(xt,ob,R);
        dist=dist+Predist;
        heading=CalcHeadingEval(xt,goal);
        vel=abs(vt);
        % �ƶ�����ļ���
%         str=['dist ' num2str(dist) 'head ' num2str(heading) 'vel ' num2str(vel)];
%         disp(str);
        stopDist=CalcBreakingDist(vel,model);
        if dist>stopDist % 
            evalDB=[evalDB;[vt ot heading dist vel]];
            trajDB=[trajDB;traj];
        end
    end
end