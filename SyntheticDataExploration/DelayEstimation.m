function cnt=DelayEstimation(varargin)
% calculating the distribution of exposure to case report in COVID-19
% you can input parameters 'Scale' 'SampleSize' and 'Threshold'

p=inputParser;
addOptional(p,'Scale',1,@isnumeric);  %the scaling parameter for overall length; set at 1 unless for sensitivity analysis
addOptional(p,'SampleSize',1e7);  % size of the sample for calculating the delay
addOptional(p,'Threshold',0.01,@isnumeric);   % fractional number to be excluded on the tails to keep the size of the vector manageable

parse(p,varargin{:});
scale=p.Results.Scale;
sz=p.Results.SampleSize;
trs=p.Results.Threshold;

%% specify the delay parameters for each piece
inc_m=1.62; % from lauer et al
inc_s=0.418;    % from lauer et al

%m=4*scale;        %based on CDC number
%m=5.6*scale;  % from supplementary data by Linton et al
m=5*scale;      %mean for onset-to-detection; averaging based on Linton and CDC information
v=2.8^2*scale^2;  % stdev for onset-to-detection;  from supplementary data by Linton et al, excluding a few people with 12+ delays that skew the results

% lognormal parameters
det_m= log((m^2)/sqrt(v+m^2));
det_s = sqrt(log(v/(m^2)+1));
%% generate data

% generate incubation data
inc_ml=log(exp(inc_m*scale));
inc_sl=inc_s;

incd=lognrnd(inc_ml,inc_sl,sz,1);

% generate detection data

detd=lognrnd(det_m,det_s,sz,1);

% estimate total delay
totd=incd+detd;

% getting the data rounded into days
rndl=round(totd);

cnt=hist(rndl,[1:100]);
%cnt(cnt<trs*sz)=[];\
cnt=cnt/sum(cnt);

cnt(cnt<trs)=0;
cnt=cnt/sum(cnt);
cnt(cumsum(cnt(1:end-1))>1-trs/10)=[];
cnt=cnt/sum(cnt);
cnt(cumsum(cnt)>0.9999 & cnt==0)=[]; % remove trailing zeros
end