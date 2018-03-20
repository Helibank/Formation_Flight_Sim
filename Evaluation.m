function [evalDB,trajDB]=Evaluation(x,Vr,goal,ob,R,model,evalParam)% ���ۺ����ļ���
% 
evalDB=[];
trajDB=[];
for vxt=Vr(1):model(4):Vr(2)
    for vyt=Vr(3):model(4):Vr(4)%�������п��ܵ��ٶȺͽ��ٶ�
        % �켣�Ʋ�; �õ� xt: ��������ǰ�˶����Ԥ��λ��; traj: ��ǰʱ�� �� Ԥ��ʱ��֮��Ĺ켣
        [xt,traj]=GenerateTrajectory(x,vxt,vyt,evalParam(4));  %evalParam(4),ǰ��ģ��ʱ��;
        % �����ۺ����ļ���
        dist=CalcDistEval(xt,ob,R);
        Predist=CalcPreDist(xt,ob,R);
        dist=dist+Predist;
        heading=CalcHeadingEval(xt,goal);
        vel=sqrt(vxt*vxt+vyt*vyt);
        % �ƶ�����ļ���
        stopDist=CalcBreakingDist(vel,model);
        if dist>stopDist % 
            evalDB=[evalDB;[vxt vyt heading dist vel]];
            trajDB=[trajDB;traj];
        end
    end
end