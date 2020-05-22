% a set of systematic tests to assess different parameterizations and
% specifications

clear all

testNum=20; %number of iterations per experiment
numC=500;  %number of cities per test
tm=[0 -0.01 -0.002]; %the baseline functional form with constant, first order, and quadratic effects
dirNm='C:\Users\hazhi\Dropbox (MIT)\COVID-19\Data analysis\EstimatingDelay\syntheticDataUpdate\PaperUpdate-51720';

xlcl={'B','F','J','N','R','V','Z','AD','AH','AL'};

%% select tests to run
trueInf=1; % test impact of true infections and randomness in results (IN PAPER)
truDifFunc=1; %test performance in different functional forms with true exposure (IN PAPER)
difFunc=1; % test performance in different functional forms (IN PAPER)
cmlDifFunc=1;   % test performance in different functional forms with cumulative exposure estimation (IN PAPER)
fixEffTrn=1;        % test impact of different fixed effect and trend settings (IN PAPER)
weiReg=1;   % test impact of weighting the regressions (IN PAPER)
popVar=1;   % test impact of population variance (IN PAPER)
R0Var=1;   % test the impact of R0 variance (IN PAPER)
RCorrel=1;   % test impact of correlation between temperature and baseline R (IN PAPER)
testFracFunc=1;  % test impact of changing testing fraction initially (IN PAPER)

detFrac=0;   % test the impact of detection fraction
cutUpperR=0;   % test impact of upper cuts mxR0
cutLowExp=0;   % test impact of lower cuts in exposure minEx
oldDrops=0;   % test impact of old drop
useSqtrend=0;   % test impact of using square term in trends
breakLinear=0;   % test impact of using breakdown linear trend
breakPlusLinear=0;   % test impact of using breakdown linear trend plus initial linear
exposPenal=0;   % test impact of different penalties for solving exposure
startTimes=0;   % test impact of different starting times
cumExp=0;   % test impact of cumulative vs. exposure based specification
placeboTest=0;   % test performance under placebo weather (date shifted as well as different city)
earlyDropOn=0;   % test impact of different early drops
optimDesign=0;      % test a proposed optimal mix with different functional forms
avgPrd=0;           % test impact of different averaging periods
excTempVar=0;   % test impact of different exclusion for locations with limited variance in temperature



cd(dirNm);
xlsFN='RegExperimentResults.xlsx';
%get temperature data

load('RealDataTemp');
row=3;

%% test impact of true infections and randomness in results
if trueInf
    xlswrite(xlsFN,{'impact of true infections and randomness in results'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        varNm1='truExp';
        varNm2='randExposure';
        
        switch i
            
            case 1
                rvar1=1;rvar2=1;
            case 2
                rvar1=0;rvar2=1;
            case 3
                rvar1=1;rvar2=0;
        end
        scnNm=[varNm1 num2str(rvar1) varNm2 num2str(rvar2)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, varNm1,rvar1, varNm2, rvar2);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test performance in different functional forms with true exposure
if truDifFunc
    xlswrite(xlsFN,{'performance in different functional forms with true exposure'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        switch i
            case 1
                rvar=[0 +0.05 0];
            case 2
                rvar=[0 -0.05 0];
            case 3
                rvar=[0 0 0.004];
                
        end
        
        scnNm=['TruExp-func-lin-sqr@' num2str(rvar(2)) '@' num2str(rvar(3))];
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,rvar,scnNm,'truExp',1,'nofixed',0,'notrend',0);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end


%% test performance in different functional forms
if difFunc
    xlswrite(xlsFN,{'performance in different functional forms'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        switch i
            case 1
                rvar=[0 +0.05 0];
            case 2
                rvar=[0 -0.05 0];
            case 3
                rvar=[0 0 0.004];
                
        end
        
        scnNm=['func-lin-sqr@' num2str(rvar(2)) '@' num2str(rvar(3))];
        
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,rvar,scnNm);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test performance in different functional forms with cumulative exposure estimation
if cmlDifFunc
    xlswrite(xlsFN,{'performance in different functional forms with cumulative exposure estimation'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        switch i
            case 1
                rvar=[0 +0.05 0];
            case 2
                rvar=[0 -0.05 0];
            case 3
                rvar=[0 0 0.004];
                
        end
        
        scnNm=['CumExp-func-lin-sqr@' num2str(rvar(2)) '@' num2str(rvar(3))];
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,rvar,scnNm,'ExpsSpec',0);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of different fixed effect and trend settings
if fixEffTrn
    xlswrite(xlsFN,{'impact of different fixed effect and trend settings'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        varNm1='notrend';
        varNm2='nofixed';
        
        switch i
            case 1
                rvar1=0;rvar2=1;
            case 2
                rvar1=1;rvar2=1;
            case 3
                rvar1=1;rvar2=0;
                
        end
        scnNm=[varNm1 num2str(rvar1) varNm2 num2str(rvar2)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, varNm1,rvar1, varNm2, rvar2);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of weighting the regressions
if weiReg
    xlswrite(xlsFN,{'impact of weighting the regressions'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:1
        rvar=i;
        scnNm=['wReg' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'wReg',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end


%% test impact of population variance
if popVar
    xlswrite(xlsFN,{'impact of population variance'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        rvar=400000*(i-1);
        scnNm=['PopVar' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'PopD',[500000 rvar]);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test the impact of R0 variance
if R0Var
    xlswrite(xlsFN,{'the impact of R0 variance'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        rvar=0.5*(i-1);
        scnNm=['stdR' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'stdR',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end




%% test impact of cumulative vs. exposure based specification
if cumExp
    xlswrite(xlsFN,{'impact of cumulative vs. exposure based specification'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        if i==1
            rvar=0;
        else
            rvar=1;
        end
        
        scnNm=['ExpsSpec' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'ExpsSpec',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of correlation between temperature and baseline R
if RCorrel
    xlswrite(xlsFN,{'impact of correlation between temperature and baseline R'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:1
        if i==1
            rvar='random';
        else
            rvar='correlated';
        end
        scnNm=['R0-' rvar];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'normalizeR',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of changing testing fraction initially
if testFracFunc
    xlswrite(xlsFN,{'impact of changing testing fraction initially'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        switch i
            case 1
                rvar=@(x)min(0.2,0.001*x);
            case 2
                rvar=@(x)min(0.2,0.05*log10(x+1));
            case 3
                rvar=@(x)min(0.2,0.01*x^0.5);
        end
        scnNm=['TestFrac' num2str(rvar(50)) '-' num2str(rvar(500))];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm,'dtcFr',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end




%% test impact of different averaging periods
if avgPrd
    xlswrite(xlsFN,{'impact of different averaging periods'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:4
        rvar=(i-1)*5+1;
        scnNm=['avgPeriod' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'cmlReg',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test the impact of detection fraction
if detFrac
    xlswrite(xlsFN,{'the impact of detection fraction'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        rvar=0.4*i-0.3;
        scnNm=['dtcFrac' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'dtcFrac',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end



%% test impact of upper cuts mxR0
if cutUpperR
    xlswrite(xlsFN,{'impact of upper cuts mxR0'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:4
        rvar=100-i*5;
        scnNm=['maxRPerc' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'mxR0',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of lower cuts in exposure minEx
if cutLowExp
    xlswrite(xlsFN,{'impact of lower cuts in exposure minEx'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:4
        rvar=round(i^1.5)-1;
        scnNm=['minExps' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'minEx',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end


%% test impact of old drop
if oldDrops
    xlswrite(xlsFN,{'impact of old drop'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        rvar=i==1;
        scnNm=['oldDrop' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'oldDrop',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end



%% test impact of using square term in trends
if useSqtrend
    xlswrite(xlsFN,{'impact of using no fixed effects'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        rvar=i==1;
        scnNm=['noSquareTrend' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'notrend2',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of using breakdown linear trend
if breakLinear
    xlswrite(xlsFN,{'impact of using breakdown linear trend'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        rvar=i==1;
        scnNm=['breakDownTrend' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'nolint',rvar,'notrend',1);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of using breakdown linear trend plus initial linear
if breakPlusLinear
    xlswrite(xlsFN,{'using breakdown linear trend plus initial linear'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:2
        rvar=i==1;
        scnNm=['addBreakSlopeToInit' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'nolint',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of different penalties for solving exposure
if exposPenal
    xlswrite(xlsFN,{'different penalties for solving exposure'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:4
        rvar=0.2^i*10;
        scnNm=['Penalty' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'Penalty',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end
%% test impact of different starting times
if startTimes
    xlswrite(xlsFN,{'impact of different starting times'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        rvar=(i-1)*100+1;
        scnNm=['StartTime' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D(:,rvar:end),testNum,numC,tm,scnNm);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test performance under placebo weather (date shifted as well as different city)
if placeboTest
    xlswrite(xlsFN,{'performance under placebo weather'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:3
        switch i
            case 1
                rvar='None';
            case 2
                rvar='Time';
            case 3
                rvar='City';
                
        end
        scnNm=['Placebo' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm, 'Placebo',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end

%% test impact of different early drops
if earlyDropOn
    xlswrite(xlsFN,{'impact of different early drops'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:4
        rvar=(i-1)*5;
        scnNm=['EarlyDrop' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm,'earlyDrop',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end


%% test a proposed optimal mix with different functional forms
if optimDesign
    xlswrite(xlsFN,{'proposed optimal mix with different functional forms'},'Sheet1',[xlcl{1} num2str(row-2)]);
    
    for i=1:3
        switch i
            case 1
                rvar=[0 +0.05 0];
            case 2
                rvar=[0 0.1 -0.003];
            case 3
                rvar=[0 0 0.004];
                
        end
        optStr='wReg0erDrp10mxR95';
        scnNm=[optStr 'lin-sqr@' num2str(rvar(2)) '@' num2str(rvar(3))];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,rvar,scnNm,'wReg',0,'earlyDrop',10,'mxR0',95);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end


%% test impact of different exclusion for locations with limited variance in temperature
if excTempVar
    xlswrite(xlsFN,{'impact of different exclusion for locations with limited variance in temperature'},'Sheet1',[xlcl{1} num2str(row-2)]);
    for i=1:4
        rvar=30*(i-1);
        scnNm=['minTempVar' num2str(rvar)];
        [coef,intv,sz,rsqr]=testSynthetic2(D,testNum,numC,tm,scnNm,'minTempVar',rvar);
        coef=reshape(mean(coef,2),1,[]);
        intv=mean(intv,3);
        xlswrite(xlsFN,{scnNm},'Sheet1',[xlcl{i} num2str(row-1)]);
        xlswrite(xlsFN,[intv(2:3,1),coef(2:3)',intv(2:3,2)],'Sheet1',[xlcl{i} num2str(row)]);
        xlswrite(xlsFN,[sz 0 rsqr],'Sheet1',[xlcl{i} num2str(row+2)]);
    end
    row=row+6;
end




