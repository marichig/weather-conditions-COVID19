function [Exposure,shift,znum]=delaySolve2(Infection,Dist,varargin)

% this code gets a vector of reported Infection and a delay distribution
% (Dist) and provides the estimated exposure/true infection

p=inputParser;
addOptional(p,'Penalty',0.2,@isnumeric);  %the penalty for variance in Exposure over time
parse(p,varargin{:});
alpha=p.Results.Penalty;

Dist=Dist/sum(Dist);    %making sure Dist adds to 1
Dist(cumsum(Dist)==1 & Dist==0)=[]; % remove trailing zeros
ilen=numel(Infection);
czdist=cumsum(Dist==0); %counting early zeros
if max(czdist)>0
    znum=czdist(Dist==max(Dist));
else
    znum=0;
end
Dist=flip(Dist);

if ilen<1
    Exposure=[];
    shift=0;
else
    drn=numel(Dist);
    
    coeff=zeros(ilen,ilen+drn);
    for i=1:ilen
        coeff(i,i:i+drn-1)=Dist;
    end
    dropped=sum(coeff,1)==0;
    coeff(:,dropped)=[];
    %coeff(:,ilen+1:end)=[];
    xlen=size(coeff,2);
    pnl=eye(xlen);
    pnl(2:end,1:end-1)=pnl(2:end,1:end-1)-eye(xlen-1);
    pnl(1:end-1,2:end)=pnl(1:end-1,2:end)-eye(xlen-1);
    pnl=pnl+eye(xlen);
    pnl(1,1)=1;pnl(end,end)=1;
    Ex=quadprog(coeff'*coeff+alpha*pnl,-coeff'*Infection',-eye(xlen),zeros(xlen,1));
    Exposure=zeros(numel(Infection)+drn,1);
    Exposure(1:numel(Ex))=Ex;
    shift=drn;
end

end