function [bout,bint,sz,rsqr]=testSynthetic2(Data,testNum,numC,tm,scnNm, varargin)
%testing our equations on various mixes of actual data on weather


p=inputParser;

addOptional(p,'simL',50);   %simulation length
addOptional(p,'bCntB',3);   %R0 to use
addOptional(p,'stdR',0.3);   %standard deviation of R0 multipier
addOptional(p,'initInf',3);   %initial infectious population
addOptional(p,'rcvDly',20);   %delay in recovery
addOptional(p,'dtcFrac',0.1);   %detection fraction
addOptional(p,'PopD',[500000 200000]);   %population mean and standard deviation
addOptional(p,'normalizeR','correlated');   %wheather to normalize R0 based on weather ('scale'), use random base R0 ('random') or use 'correlated' with R0
addOptional(p,'mxR0',95);   %maximum R0 percentile to include in analysis
addOptional(p,'minR0',0);   %minimum R0 percentile to include in analysis
addOptional(p,'minEx',1);   %minimum exposure to include in analysis
addOptional(p,'oldDrop',[]);   %whether to drop days where X-14 days before we had no more exposure than 1
addOptional(p,'earlyDrop',10);   %whether to drop days where X-14 days before we had no more exposure than 1
addOptional(p,'nofixed',1);   %no fixed effects
addOptional(p,'notrend',0);   %no linear trend term
addOptional(p,'notrend2',1);   %no second order trend term
addOptional(p,'nolint',1);   %no linear trend with a break point that is case specific
addOptional(p,'nosqr',0);   %no square term in temperature regressions
addOptional(p,'Penalty',0.2);   %penalt for solving exposure
addOptional(p,'ExpsSpec',1);    %wheather to use the flow specification (1) or cumulative (0)
addOptional(p,'Placebo','None');    %Whether to use time or city shifts as placebo. 'Time' and 'City' are the inputs
addOptional(p,'ShiftLength',5);   %length of time shift
addOptional(p,'dtcFr',[]);   % calculating (minimum) future fractional detection rate as a function of daily exposure
addOptional(p,'importData',[]);   % data imported rather than using simulated data
addOptional(p,'wReg',0);   % using weighted regression
addOptional(p,'truExp',0); %use true exposure or estimated one
addOptional(p,'truInf',0); % use true infections rather than summed version
addOptional(p,'randExposure',1); %wheather to use random exposure or expected value exposure
addOptional(p,'trndStarMeas',1); %wheather to start trend line at first measured infection, or from beginning of time
addOptional(p,'nsSeed',[]);  %noise see to pass in case
addOptional(p,'cmlReg',0);  %if to use cumulative formulation, and for how many days
addOptional(p,'cmlMovAg',0);  %if to use moving average version of cumulative formulation
addOptional(p,'minTempVar',0);  %the percentile for temperature variance to be included in the simulation sample

parse(p,varargin{:});

simL=p.Results.simL;
bCntB=p.Results.bCntB;
stdR=p.Results.stdR;
initInf=p.Results.initInf;
rcvDly=p.Results.rcvDly;
dtcFracBase=p.Results.dtcFrac;
PopD=p.Results.PopD;
normalizeR=p.Results.normalizeR;
mxR0=p.Results.mxR0;
minR0=p.Results.minR0;
minEx=p.Results.minEx;
oldDrop=p.Results.oldDrop;
earlyDrop=p.Results.earlyDrop;
nofixed=p.Results.nofixed;
notrend=p.Results.notrend;
notrend2=p.Results.notrend2;
nolint=p.Results.nolint;
nosqr=p.Results.nosqr;
Penalty=p.Results.Penalty;
ExpsSpec=p.Results.ExpsSpec;
ShiftLength=p.Results.ShiftLength;
TimeShift=(strcmp(p.Results.Placebo,'Time') | strcmp(p.Results.Placebo,'Both'))*ShiftLength;
CityShift=(strcmp(p.Results.Placebo,'City') | strcmp(p.Results.Placebo,'Both'));
dtcFr=p.Results.dtcFr;
impD=p.Results.importData;
wReg=p.Results.wReg;
truExp=p.Results.truExp;   %use true exposure or estimated one
truInf=p.Results.truInf;   % use true infections rather than summed version
randExposure=p.Results.randExposure; %wheather to use random exposure or expected value exposure
trndStarMeas=p.Results.trndStarMeas;
nsSeed=p.Results.nsSeed;
cmlReg=p.Results.cmlReg;
cmlMovAg=p.Results.cmlMovAg;
minTempVar=p.Results.minTempVar;


trng=[-30 50];  %range of temperatures to include in analysis

% regression parameters


% graphing parameters
writegraph=1;   %weather to save graphs
scatteron=0;    %wheather to draw scatter plot by group at the end of each run
singleparamon=0;    %wheather to graph single parameters individually
RGraph=0;       %whether to graph the LN(R) values for the first city

% create the weather impact function
wimp=@(t)exp(tm(1)*ones(size(t))+tm(2)*t+tm(3)*t.^2);

% the weight function for weighted regression; input is exposure, output is
% the weight for that data point
wtx=@(x)1./(0.45*x.^(-0.57)).^2;

%% Estimating the delay shape and recovery distribution
dtcPrb=DelayEstimation();
dtcMx=numel(dtcPrb);
[~,dtcMode]=max(dtcPrb);

% set recovery distribution using poisson
dist= poissrnd(rcvDly,100000,1);
cml=hist(dist,[1:max(dist)]);
cml(cml<500)=0;
cml(cumsum(cml)==1 & cml==0)=[]; % remove trailing zeros
cml=cml/sum(cml);
rcvPrb=cml;
rcvMx=numel(rcvPrb);

% read  data
D=Data;

% limiting sampling to more variable temperatures
tVar=(std(D,[],2));
locinx=(tVar>prctile(tVar,minTempVar)).*(1:numel(tVar))';
locinx(locinx==0)=[];

dSz=numel(locinx);
if ~isempty(nsSeed)
    rng(nsSeed);
end

%% conduct main analysis
for i=1:testNum
    if isempty(nsSeed)
        rng(i); %fix random seed
    end
    Y=[];X=[];EX=[];Xlbl={'constanttemp','temp','temp2','label','time'};
    
    ord=randperm(dSz);
    
    for k=1:numC
        %pick the city to simulate
        inx=locinx(ord(k));
        inx2=locinx(floor(rand()*dSz)+1);
        
        switch normalizeR
            case 'scale'
                bCnt=bCntB/rcvDly/mean(wimp(D(1:simL)));
            case 'random'
                bCnt=max(0,bCntB/rcvDly*normrnd(1,stdR));
            case 'correlated'
                bCnt=max(0,bCntB/rcvDly*normrnd(1,stdR)*(40+mean(D(1:simL)))/50);
        end
        bCnt=max(0,bCnt);
        %generate pandemic and measure outcome
        infD=zeros(1,simL);
        expD=zeros(1,simL);
        rcvD=zeros(1,simL+rcvMx);
        msrD=zeros(1,simL+dtcMx);
        if isempty(dtcFr)   %using dtcFr function to set the initial detection fraction
            dtcFrac=dtcFracBase*ones(size(msrD));
        else
            dtcFrac=dtcFr(0)*ones(size(msrD));
        end
        susD=zeros(1,simL);
        susD(1)=max(1000,round(normrnd(PopD(1),PopD(2))));
        %initialize epidemic
        infD(1)=initInf;
        rcvD(1:rcvMx)=rcvD(1:rcvMx)+mnrnd(infD(1),rcvPrb);
        dtcPrbAg=[dtcPrb.*dtcFrac(1:numel(dtcPrb)) 1-sum(dtcPrb.*dtcFrac(1:numel(dtcPrb)))];
        msrAdd=mnrnd(infD(1),dtcPrbAg);
        msrD(1:dtcMx)=msrD(1:dtcMx)+msrAdd(1:end-1);
        
        %create epidemic and measures using a simulation
        for j=1:simL
            
            expD(j)=poissrnd(infD(j)*bCnt*wimp(D(inx,j))*susD(j)/susD(1))*randExposure+...
                (1-randExposure)*round(infD(j)*bCnt*wimp(D(inx,j))*susD(j)/susD(1));
            susD(j+1)=max(0,susD(j)-expD(j));      %update susceptible
            rcvD(1+j:j+rcvMx)=rcvD(1+j:rcvMx+j)+mnrnd(round(expD(j)),rcvPrb); %create recoveries
            if ~isempty(dtcFr)
                dtcFrac(1+j:end)=max(dtcFrac(j+1),dtcFr(expD(j)));
            end
            
            dtcPrbAg=[dtcPrb.*dtcFrac(1+j:j+numel(dtcPrb)) max(0,1-sum(dtcPrb.*dtcFrac(1+j:j+numel(dtcPrb))))];
            msrAdd=mnrnd(expD(j),dtcPrbAg);
            msrD(1+j:dtcMx+j)=msrD(1+j:dtcMx+j)+msrAdd(1:end-1);  %create measurements
            infD(j+1)=max(0,infD(j)+expD(j)-rcvD(j));              %track infected stock
        end
        
        %estimate exposure
        if truExp
            estmX=expD';
        else
            if ExpsSpec
                [estmX,shift]=delaySolve2(msrD,dtcPrb,'Penalty',Penalty);
                if shift>0
                    estmX(1:shift)=[];
                end
            else
                cmsrD=[cumsum(msrD)]';
                estmX=(cmsrD(dtcMode+1:end)-cmsrD(dtcMode:end-1));   %these are people identified on day dtcMode:end. They inform the number of exposures on day 1:....
            end
        end
        
        if truInf
            estmI=infD(1:end-1)';
        else
            estmI=movsum(estmX,[rcvDly 0])-estmX;
        end
        estmR=estmX./estmI*rcvDly;
        
        
        % create dependent and independent variable vectors
        if numel(oldDrop)>0
            extend=zeros(numel(estmX)+rcvDly,1);
            extend(rcvDly+1:end)=estmX;
            smpl3=extend(1:end-rcvDly)>minEx;
        else
            smpl3=ones(size(estmX));
        end
        if numel(earlyDrop)>0
            xTr=estmX>minEx;
            inxT=find(xTr,1);
            smpl4=ones(size(estmX));
            smpl4(1:min(inxT+earlyDrop,numel(estmX)))=0;
        else
            smpl4=ones(size(estmX));
        end
        
        smpl=estmR<prctile(estmR,mxR0) & estmR>prctile(estmR,minR0) & estmX>minEx & smpl3 & smpl4;
        if trndStarMeas
            msln=zeros(size(estmR));
            msln(1:min(numel(msrD),numel(estmR)))=msrD(1:min(numel(msrD),numel(estmR)));
            tms=cumsum(msln>0);
        else
            tms=[1:numel(estmR)]';
        end
        tmps=[D(inx*(1-CityShift)+CityShift*inx2,1+TimeShift:numel(estmR)+TimeShift)]';
        lbl=k*ones(size(estmR));
        if cmlReg>0         %when using cumulative formulations
            if cmlMovAg     %when using cumulative with moving average
                cmlX=movsum(estmX,[0 cmlReg-1]);
                cmlSumI=movsum(estmX,[rcvDly 0])-estmX;
                cmlI=movsum(cmlSumI,[0 cmlReg-1]);
                estmCmlR=cmlX./cmlI*rcvDly;
                cmSmpl=true(size(estmCmlR));
                cmSmpl(1:rcvDly)=0; %removing early points where we don't have enough cumulative cases
                cmSmpl(end-cmlReg+2:end)=0; %removing trailing points without enough averaging interval
                cmSmpl2=estmCmlR<prctile(estmCmlR,mxR0) & estmCmlR>prctile(estmCmlR,minR0) & cmlX>minEx;
                cmSmpl=cmSmpl & cmSmpl2;
                
                tmsCml=movsum(tms,[0 cmlReg-1])/cmlReg;
                tmpsCml=movsum(tmps,[0 cmlReg-1])/cmlReg;
                tmpsCml2=movsum(tmps.^2,[0 cmlReg-1])/cmlReg;
                lblCml=lbl;
                XaddCml=[ones(size(tmpsCml(cmSmpl))) tmpsCml(cmSmpl) tmpsCml2(cmSmpl) lbl(cmSmpl) tmsCml(cmSmpl)];
                Y=[Y;estmCmlR(cmSmpl)];
                X=[X;XaddCml];
                EX=[EX;cmlX(cmSmpl)];
            else              %when using cumulative with non-overlapping windows
                initL=numel(estmX);
                tinx=[initL-floor(initL/cmlReg)*cmlReg+1:initL];
                cmlX=sum(reshape(estmX(tinx),cmlReg,[]),1)';
                cmlSumI=movsum(estmX,[rcvDly 0])-estmX;
                cmlI=sum(reshape(cmlSumI(tinx),cmlReg,[]),1)';
                estmCmlR=cmlX./cmlI*rcvDly;
                cmSmpl=true(size(estmCmlR));
                cmSmpl(1:round(rcvDly/cmlReg))=0; %removing early points where we don't have enough cumulative cases
                cmSmpl2=estmCmlR<prctile(estmCmlR,mxR0) & estmCmlR>prctile(estmCmlR,minR0) & cmlX>minEx;
                cmSmpl=cmSmpl & cmSmpl2;
                
                lblCml=k*ones(size(estmCmlR));
                tmsCml=mean(reshape(tms(tinx),cmlReg,[]),1)';
                tmpsCml=mean(reshape(tmps(tinx),cmlReg,[]),1)';
                tmpsCml2=mean(reshape(tmps(tinx).^2,cmlReg,[]),1)';
                XaddCml=[ones(size(tmpsCml(cmSmpl))) tmpsCml(cmSmpl) tmpsCml2(cmSmpl) lblCml(cmSmpl) tmsCml(cmSmpl)];
                Y=[Y;estmCmlR(cmSmpl)];
                X=[X;XaddCml];
                EX=[EX;cmlX(cmSmpl)];
                
            end
            
        else
            
            Y=[Y;estmR(smpl)];
            Xadd=[ones(size(tmps(smpl))) tmps(smpl) tmps(smpl).^2 lbl(smpl) tms(smpl)];
            X=[X;Xadd];
            EX=[EX;estmX(smpl)];
        end
    end
    
    %drop cases with extreme values of temperature (likely errors in temp data)
    smpx=trng(1)<X(:,2) & trng(2)>X(:,2);
    X(~smpx,:)=[];
    Y(~smpx,:)=[];
    EX(~smpx,:)=[];
    
    lbls=X(:,4);    %labels for cities
    ctms=X(:,5);    %times for cities
    
    for k=1:numC
        if sum(lbls==k)>3
            z=log(Y(lbls==k));
            zb=ischange(z,'linear','MaxNumChanges',1);
            zt=zb'*ctms(lbls==k);
            minT=min(ctms(lbls==k));
            
            Xf=[lbls==k (lbls==k).*(ctms-minT) (lbls==k).*(ctms-minT).^2 (lbls==k).*(ctms-zt).*(ctms>zt)]; %(lbls==k).*(ctms-minT).^3
            X=[X,Xf];
            Xlbl=[Xlbl, {'fixed','trend1','trend2','lint1'}]; %,'trend3'
        end
    end
    
    
    
    X(:,[4 5])=[];  %drop constant time and lable from X
    Xlbl([4 5])=[];
    
    %getting the X vector into right shape based on inclusion criteria
    Index1=[];Index2=[];Index3=[];Index4=[];Index5=[];
    if notrend
        Index1 = find(contains(Xlbl,'trend1'));
    end
    if nofixed
        Index2 = find(contains(Xlbl,'fixed'));
    end
    if nolint
        Index3 = find(contains(Xlbl,'lint'));
    end
    if notrend2
        Index4 = find(contains(Xlbl,'trend2'));
    end
    if nosqr
        Index5 = find(contains(Xlbl,'temp2'));
    end
    % removing independent variables that don't change at all
    Index6=(std(X(:,2:end),[],1)==0).*[2:size(X,2)];
    Index6(Index6==0)=[];
    IndexAll=unique([Index1 Index2 Index3 Index4 Index5 Index6]);
    XInc=1:size(X,2);
    XInc(IndexAll)=[];
    XLInc=Xlbl(XInc);
    Xreg=X(:,XInc);
    
    if wReg
        w=wtx(EX);
        [coef,cstd] = lscov(Xreg,log(Y),w);
        intv=[coef-1.96*cstd,coef+1.96*cstd];
        r2(i)=(corr(Xreg*coef,log(Y)))^2;
    else
        [coef,intv,~,~,stats]=regress(log(Y),Xreg);
        r2(i)=stats(1);
    end
    vcoef{i}=coef;
    vintv{i}=intv;
    
    bout(:,i)=coef(XInc(XInc<4));
    bint(:,:,i)=intv(XInc(XInc<4),:);
    
    
    %
    Xregnf=X(:,find(contains(XLInc,'temp')));
    [coefnf,intvnf]=regress(log(Y+0.01),Xregnf);
    boutnf(:,i)=coefnf;
    bintnf(:,:,i)=intvnf;
    
    if RGraph & i==1
        figure
        hold on
        for k=1:numC
            plot(log(Y(lbls==k)));
        end
    end
    %
    if scatteron
        
        
        
        
        coefNoTemp=coef;
        coefNoTemp(find(contains(XLInc,'temp')))=0;
        YLpred=Xreg*coefNoTemp;
        
        figure
        
        gscatter(Xreg(:,2),log(Y)-YLpred,lbls);
        
        hold on
        temprang=[-20:40];
        if isempty(find(contains(XLInc,'fixed')))
            fixedEff=0;
        else
            fixedEff=mean(coef(find(contains(XLInc,'fixed'))));
        end
        
        if nosqr
            sqrEff=0;
        else
            sqrEff=temprang.^2*coef(3);
        end
        plot(temprang,coef(1)+temprang*tm(2)+temprang.^2*tm(3)+fixedEff,':k','LineWidth',2);
        plot(temprang,coef(1)+temprang*coef(2)+sqrEff+fixedEff);
        title('Temperature vs. R controlling for fixed effects-random');
        if writegraph
            saveas(gcf,[scnNm 'ScatterCityWithFixed.jpg']);
        end
        
        figure
        
        gscatter(X(:,2),log(Y),lbls);
        
        hold on
        if nosqr
            sqrEffnf=0;
        else
            sqrEffnf=temprang.^2*coefnf(3);
        end
        plot(temprang,coefnf(1)+temprang*tm(2)+temprang.^2*tm(3),':k','LineWidth',2);
        plot(temprang,coefnf(1)+temprang*coefnf(2)+sqrEffnf);
        title('Temperature vs. R with no controls-random');
        if writegraph
            saveas(gcf,[scnNm 'ScatterCityTrueNoControl.jpg']);
        end
        'estimates and 95% CI with fixed effects                   estimates and 95% CI with no controls (rows: constant, temp, temp^2)';
        %   [intv(1:3,1),coef(1:3),intv(1:3,2),zeros(3,5),intvnf(1:3,1),coefnf(1:3),intvnf(1:3,2)]
        
    end
    szx(i)=numel(Y);
end

if singleparamon
    figure
    plot(squeeze(bint(3,1,:)))
    hold on
    plot(squeeze(bint(3,2,:)))
    plot(squeeze(bout(3,:)),'LineWidth',3)
    plot(ones(1,testNum)*tm(3),':k','LineWidth',2)
    %ylim([-(abs(tm(3)*1.5)) abs(tm(3)*1.5)])
    title([num2str(numC) 'Cities-sqr term.' num2str(truExp)]);
    if writegraph
        saveas(gcf,[scnNm 'Cities-CoeffSq.jpg']);
    end
    
    figure
    plot(squeeze(bint(2,1,:)))
    hold on
    plot(squeeze(bint(2,2,:)))
    plot(squeeze(bout(2,:)),'LineWidth',3)
    plot(ones(1,testNum)*tm(2),':k','LineWidth',2)
    ylim([-abs(tm(2)*1.5) abs(tm(2)*1.5)])
    title([num2str(numC) 'Cities-linear term' num2str(truExp)])
    if writegraph
        saveas(gcf,[scnNm 'Cities-CoeffLin.jpg']);
    end
    
    figure
    hold on
    peaks=-0.5*squeeze(bout(2,:))./squeeze(bout(3,:));
    trupeaks=ones(1,testNum)*(-0.5*tm(2)/tm(3));
    plot(peaks,'LineWidth',3);
    plot(trupeaks,':k','LineWidth',2);
    title('Temperature of true peaks vs. estimated');
    ylim(trng);
    if writegraph
        saveas(gcf,[scnNm 'Cities-PeakLocation.jpg']);
    end
    
end


figure
hold on
temps=trng(1):trng(2);
for i=1:testNum
    if size(bout,1)>2
        plot(temps,squeeze(bout(2,i))*temps+squeeze(bout(3,i))*temps.^2)
    else
        plot(temps,squeeze(bout(2,i))*temps)
    end
end
plot(temps, tm(2)*temps+tm(3)*temps.^2,':k','LineWidth',3)
title(scnNm);
ylabel('Change in Ln(R)');
xlabel('Temperature');
if writegraph
    saveas(gcf,[scnNm 'Relationships.jpg']);
end


rsqr=mean(r2);

sz=mean(szx);


end
