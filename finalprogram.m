% FINAL version of program for AEA pap and proc paper

clear; 
close all;


pub = 0; % 0 to make colored graphs for appendix. 
if pub; % B& W for publication 
    set(0,'DefaultAxesColorOrder',[0,0,0])
end; 



%--------------target--------------------------%
% target 
load ..\data\target.dat;
% target starts Sept 13, 74
% stop in 20011130
target=target(1:end-20,:); 

target_date = target(:,1:3);
target = target(:,4);

%--------------treasuries----------------------%
% 19620201 is the start date
% 20011130 is the end date
load ..\data\dgs1.dat;
load ..\data\dgs2.dat;
load ..\data\dgs3.dat;
load ..\data\dgs5.dat;
load ..\data\dgs10.dat;
%load ..\data\dtb3.dat; 
%load ..\data\dtb6.dat;

yields=[dgs10(:,1) dgs1(:,2) dgs3(:,2) dgs5(:,2) dgs10(:,2)];

% take average of past observations for missing ones
% take John's approach:
% different than Monika since there are serveral places with 
% multiple zeros. 

T=length(yields);
M=size(yields,2);
for t=1:T;
    for m=2:M
        if yields(t,m)< 1E-4;
            yields(t,m)=yields(t-1,m);
        end
    end
end

dates=dgs10(:,1);
yield_yr = floor(dates/10000);
yield_mo = dates-10000*yield_yr;
yield_mo = floor(yield_mo/100);
yield_day = dates-10000*yield_yr-100*yield_mo;

yield_date_graph = yield_yr + (yield_mo-1)/12 + (yield_day-1)/365;
%date for graphing. It would be better to recognize different days in each mol.


% --------------- eurodollars ---------------- %
% starts o1041971
% ends 11302001

load ..\data\ed1m.dat;
load ..\data\ed3m.dat;
load ..\data\ed6m.dat;

euros = [ed1m(:,1) ed1m(:,2) ed3m(:,2) ed6m(:,2)];
T=length(euros);
M=size(euros,2);
for t=1:T;
    for m=2:M
        if euros(t,m)< 1E-4;
            euros(t,m)=euros(t-1,m);
        end
    end
end


%--------------fed funds rate ------------------%
% fed funds rate starts in 1954 ends 2001 12 09
% start in 19620201 like the others
load ..\data\dff.dat;
dff=dff(2773:end,:);

% fed funds rate has weekends, 
% take those out
ff=dff(1:2,:); 
for i=5:7:length(dff);
    j=(i:i+4)';
    ff=[ff;dff(j,:)];
end;
% stop in 20011130
ff=ff(1:end-5,:);


% ------------------------------------------------%
% target index 2449      to end
%        1 February 1984 
% have data from 3292       to 3292+1308
%                3292+2448  to end

% we certainly have policy shocks from 
% February 1984 onwards

% start in February 1984
dates =dates(3292+2448:end,:);
yields = yields(3292+2448:end,:);
target = target(2449:end,:);
target_date=target_date(2449:end,:);
yield_date_graph = yield_date_graph(3292+2448:end,:);
euros = euros(3413:end,:);
ff = ff(3292+2448:end,:);

% IMPORTANT TIMING: 
% In response to a target move at t, 
% Eurorates react at t+1
% LIBOR are usually collected in the morning at 11 am
% so that the target move at 2 pm in the east coast afternoon
% gets reflected the next day 11 am London time. 
% Treasury yields are fine, they seem to react at t.
% look at January 3, 2001 move. 

dates=dates(1:end-1);
yields=yields(1:end-1,:);
yield_date_graph=yield_date_graph(1:end-1);
yield_yr = yield_yr(1:end-1);
yield_mo = yield_mo(1:end-1);

target_date=target_date(1:end-1,:);
target=target(1:end-1,:);
euros=euros(2:end,:);
ff=ff(1:end-1,:);

%------------------------------------------------------------------------%
% ALSO ADD 2-year TREASURY (which only starts in 1976)
%------------------------------------------------------------------------% 
T=length(dgs2);
for t=1:T;
        if dgs2(t,2)< 1E-4;
            dgs2(t,2)=dgs2(t-1,2);
        end
    end

% date, 1, 2, 3, 5, 10 year
yields=[yields(:,1:2) dgs2(2003:end,2) yields(:,3:end)];

%-------------------------------------------------------------------------%
% SELECTION OF YIELDS
%-------------------------------------------------------------------------%

bigyields = [euros(:,2:end) yields(:,2:end)]; % 1 3 6 mo Euros then 1 2 5 10 yields %

e1m=euros(:,2);
euros=euros(:,[3]);         %1 month, 6 month  MP: No, 3 month, right? 
yields=yields(:,[3 5 6]);     %2, 5, 10 year

yields=[euros yields];


%-------------------------------------------------------------------------%
% DATA FOR MONTHLY VAR
% macro data: pcom, nonfarm, cpi from 1984:2 to 1999:12
% yield data: FB yields stop in 1999:12
%             make Treasuries stop in 1999:12 as well
%------------------------------------------------------------------------%

% COLLECT END OF THE MONTH TARGET AND TREASURY YIELDS
% construct month and year during sample
% monthly fed funds data from 1954:7 to 2001:11 

load ..\data\fedfunds.dat;
fedfunds=fedfunds(92:end,:); 

mese=fedfunds(265:end,1);
anno= floor(mese); 
mese = round(100*(mese-anno));

T=length(yields);
i=1;
for t=2:T
    if yield_mo(t)~=yield_mo(t-1);
        target_m(i,:)=target(t,:);
        yields_m(i,:)=yields(t,:);
        i=i+1;
    end;
end

yields_m(i,:)=yields(end,:);
target_m(i,:)=target(end,:);

%----------LOAD FB YIELDS-----------------------------------------------------%

yesfb = 0; 
if yesfb; 
 load fyldave6.dat;
 load famablisyld.dat;
 fbdate = famablisyld(:,1);
 fby = famablisyld(:,2:end); % fama bliss 1-5 years. 
 fbdate=fbdate(80:end);
 fby = fby(80:end,:);        % 5901 - now looks like data are percent annual log yeilds, check this!

 fy6date = fyldave6(:,1);
 f6y = fyldave6(:,2:end);        % fama 1-6 mo. Watch 0s in early sample
 f6y(453,6)=f6y(452,6);          % repair a zero in the data
 fy6date=fy6date(109:end);
 f6y = 12*f6y(109:end,:)*100;    % 195901 - 200012; looks like data are monthly log yields--check this!

 % start in 1962:2 as well
 fbdate=fbdate(38:end,:);
 fby=fby(38:end,:);
 fy6date=fy6date(38:end);
 f6y=f6y(38:end,:);

 fbyields=[f6y fby];
end;

 
% ----- LOAD MACRO VARIABLES --------------------------------------------------%
load ..\data\cp.dat;
pcom=cp(:,4);
% data starts in 1959:01, so need to start later
pcom=cp(38:end,4);

load ..\data\payems.dat;
d=payems(194:end-(11+12),1);
nonfarm=100*log(payems(194:end-(11+12),2));

load ..\data\cpiaucsl.dat;
cpi=100*log(cpiaucsl(182:end-(11+12),2));

% -------Now start everything in 1984:2 ------------------------------------%

d=d(265:end);
pcom=pcom(265:end);
nonfarm=nonfarm(265:end);
cpi=cpi(265:end);
funds=fedfunds(265:end,2);

if yesfb;
 fbyields=fbyields(265:end,:);
end;

% ------ End yields in 1999:12 because of PCOM and FByields -----------------%
yields_m=yields_m(1:end-(11+12),:);
target_m=target_m(1:end-(11+12),:);
funds=funds(1:end-(11+12),:);


%----------------------------------------------------------------------------%
% CHOOSE LAG FOR LOW-FREQ VARS
%----------------------------------------------------------------------------%

vlag=6;


%-------------------------------------------------------------------------%
% VAR WITHOUT ANY YIELDS
%-------------------------------------------------------------------------%
K=vlag;
T = size(nonfarm,1);
N = 4; mpos=4;
Y=[nonfarm cpi pcom funds];

rhv = [ones(T-K,1)];
for j = 1:K;
   rhv = [rhv Y(1+K-j:T-j,:)];
end;
lhv = Y(1+K:T,:); 
bv  = rhv\lhv;
errv = lhv-rhv*bv;
coverr = errv'*errv/T;
sig = chol(coverr); % sig'sig=cov sig is upper triangular


A = bv(2:end,:)';
if K >= 2; 
   A = [ A; eye((K-1)*N) zeros((K-1)*N,N)];
end;

% SHOCK SERIES
lhv=Y(1+K:T,mpos);
rhv = [ones(T-K,1)];
for j = 1:K;
   rhv = [rhv Y(1+K-j:T-j,:)];
end;
rhv=[rhv Y(K+1:T,1:(mpos-1))];
bv=rhv\lhv;
mpshock=lhv-rhv*bv;
ceeshock = mpshock; 

% IMPULSE RESPONSES
% x(t+1) = A x(t) + sig' * err orthogonalizes in the given order 
e0 = zeros(N,1);
e0(mpos,1)=1;   %initial m shock
%xt = (sig'*e0); % initial response to shock
xt = e0;
if K>=2;
   xt = [ xt ; zeros((K-1)*N,1)];
end;
xt = xt';   % transform to time series with rows = time

for j=1:120;
   xt = [xt ; (A*xt(end,:)')'];
end;
a=(1:35)';
IR4 = xt(1:length(a),1:N);

% compare to regression approaches. 

% multiple regression
lhv = diff(Y(K+23:T,:));
rhv = [ones(T-K-23,1) mpshock(24:end)];
for j=1:23
   rhv = [rhv mpshock(24-j:end-j)];
end; 
irest = rhv\lhv;
irest = irest(2:end,:);
%[bv,sebv,R2v,v] = olsgmm(lhv,rhv,0,0);
%irest = bv(2:end,:); 
irest_mult = irest; 


% single regression
lhv = diff(Y(K:T,:));
rhv = [ones(T-K,1) mpshock(1:end)];

disp('first 5 change in nonfarm and first 5 shock');
disp([lhv(1:5,1) mpshock(1:5)]);

%irest = rhv\lhv;
[bv,sebv,R2v,v] = olsgmm(lhv,rhv,0,0);
irest = bv(2,:);
irse = sebv(2,:);
for j=1:23
   lhv = lhv(2:end,:);
   rhv = [ones(T-K-j,1) mpshock(1:end-j)];
   %irestadd = rhv\lhv;
   [bv,sebv,R2v,v] = olsgmm(lhv,rhv,0,0);
   irestadd = bv(2,:);
   irseadd = sebv(2,:);
   irest = [irest; irestadd];
   irse = [irse; irseadd ]; 
end; 
irest_sngl = cumsum(irest);
irse_sngl = cumsum(irse.^2).^0.5; % are they independent? 

% single regression of long horizon differences

lhv = diff(Y(K:T,:));
rhv = [ones(T-K,1) mpshock(1:end)];
[bv,sebv,R2v,v] = olsgmm(lhv,rhv,0,0);
irest = bv(2,:);
irse = sebv(2,:);
for j=1:23
   lhv = Y(K+1+j:T,:)-Y(K:T-j-1,:);
   rhv = [ones(T-K-j,1) mpshock(1:end-j)];
   %irestadd = rhv\lhv;
   [bv,sebv,R2v,v] = olsgmm(lhv,rhv,j,1); %using NW weights to keep se positive. Use parametric instead. 
   irestadd = bv(2,:);
   irseadd = sebv(2,:);
   irest = [irest; irestadd];
   irse = [irse; irseadd ]; 
end; 
irest_sngl_long = irest;
irse_sngl_long = irse; 



%graph to compare ir approaches

if not(pub); 
 figure; 
 subplot(2,2,1); 
 plot([IR4(1:24,1) irest_mult(:,1) irest_sngl(:,1) irest_sngl_long(:,1)]);
 hold on; 
 plot([irest_sngl_long(:,1)+irse_sngl_long(:,1) irest_sngl_long(:,1)-irse_sngl_long(:,1)],'c:'); 
 axis([0 24 -1 1.2]);
 title('nonfarm'); 
 legend('AR','multiple','single','single long','+1 se', '-1 se'); 

 subplot(2,2,2); 
 plot([IR4(1:24,2) irest_mult(:,2) irest_sngl(:,2) irest_sngl_long(:,2)]);
 hold on; 
 plot([irest_sngl_long(:,2)+irse_sngl_long(:,2) irest_sngl_long(:,2)-irse_sngl_long(:,2)],'c:'); 
 title('cpi'); 
 %legend('AR','multiple','single');
 axis([0 24 -1 1.2]); 

 subplot(2,2,3); 
 plot([IR4(1:24,3) irest_mult(:,3) irest_sngl(:,3) irest_sngl_long(:,3) ]);
 hold on; 
 plot([irest_sngl_long(:,3)+irse_sngl_long(:,3) irest_sngl_long(:,3)-irse_sngl_long(:,3)],'c:'); 
 title('pcom'); 
 %legend('AR','multiple','single');
 axis([0 24 -1 1.2]);

 subplot(2,2,4); 
 plot([IR4(1:24,4) irest_mult(:,4) irest_sngl(:,4) irest_sngl_long(:,4)]);
 hold on; 
 plot([irest_sngl_long(:,4)+irse_sngl_long(:,4) irest_sngl_long(:,4)-irse_sngl_long(:,4)],'c:'); 
 title('fed funds'); 
 %legend('AR','multiple','single');
 axis([0 24 -1 1.2]);

 print -depsc checkcee.eps;
end; % ends if not pub

% can we forecast the CEE shock with yields? 

rhv = yields_m(K:T-1,:);
lhv = mpshock; 
[bv,sebv,R2v,v] = olsgmm(lhv,rhv,0,0);
disp('regression of cee shock on yields'); 
disp(bv');
disp([bv'./sebv' R2v]);

%------------------------------------------------------------------------%
% VAR WHERE FED REACTS TO TIME t YIELDS (YIELDS DON'T REACT TO FED)      %
%------------------------------------------------------------------------%
K=vlag;
Ny=size(yields_m,2);
T = size(nonfarm,1);

%Y=[nonfarm cpi pcom yields_m(:,[Ny:-1:1]) funds];

Y=[yields_m(:,[Ny:-1:1]) funds];

rhv = [ones(T-K,1)];
for j = 1:K;
   rhv = [rhv Y(1+K-j:T-j,:)];
end;
lhv = Y(1+K:T,:);

N=size(Y,2);
mpos=N;

bv  = rhv\lhv;
errv = lhv-rhv*bv;
coverr = errv'*errv/T;
sig = chol(coverr); % sig'sig=cov sig is upper triangular

A = bv(2:end,:)';
if K >= 2; 
   A = [ A; eye((K-1)*N) zeros((K-1)*N,N)];
end;

% SHOCK SERIES
lhv=Y(1+K:T,mpos);
rhv = [ones(T-K,1)];
for j = 1:K;
   rhv = [rhv Y(1+K-j:T-j,:)];
end;
rhv=[rhv Y(K+1:T,1:(mpos-1))];
bv=rhv\lhv;
mpshock=lhv-rhv*bv;

% IMPULSE RESPONSE
% x(t+1) = A x(t) + sig' * err orthogonalizes in the given order 
e0 = zeros(N,1);
e0(mpos,1)=1;   %initial m shock
%xt = (sig'*e0); % initial response to shock
xt = e0;

if K>=2;
   xt = [ xt ; zeros((K-1)*N,1)];
end;
xt = xt';   % transform to time series with rows = time

for j=1:120;
   xt = [xt ; (A*xt(end,:)')'];
end;

a=(1:35)';
IR2 = xt(1:length(a),1:N);

yshock=mpshock;


%------------------------------------------------------------------------%
% VAR WHERE FED ONLY REACTS TO t-1 YIELDS (YIELDS REACT TO FED)          %
%------------------------------------------------------------------------%
K=vlag;
T = size(nonfarm,1);
%Y=[nonfarm cpi pcom funds yields_m];
Y=[funds yields_m];

rhv = [ones(T-K,1)];
for j = 1:K;
   rhv = [rhv Y(1+K-j:T-j,:)];
end;
lhv = Y(1+K:T,:);

mpos=1;
N=size(Y,2);

bv  = rhv\lhv;
errv = lhv-rhv*bv;
coverr = errv'*errv/T;
sig = chol(coverr); % sig'sig=cov sig is upper triangular

A = bv(2:end,:)';
if K >= 2; 
   A = [ A; eye((K-1)*N) zeros((K-1)*N,N)];
end;

% SHOCK SERIES
lhv=Y(1+K:T,mpos);
rhv = [ones(T-K,1)];
for j = 1:K;
   rhv = [rhv Y(1+K-j:T-j,:)];
end;
%rhv=[rhv Y(K+1:T,1:(mpos-1))];
bv=rhv\lhv;
mpshock=lhv-rhv*bv;


% IMPULSE RESPONSES 
% x(t+1) = A x(t) + sig' * err orthogonalizes in the given order 
e0 = zeros(N,1);
e0(mpos,1)=1;   %initial m shock
%xt = (sig'*e0); % initial response to shock
xt = e0;
if K>=2;
   xt = [ xt ; zeros((K-1)*N,1)];
end;
xt = xt';   % transform to time series with rows = time
for j=1:120;
   xt = [xt ; (A*xt(end,:)')'];
end;

a=(1:35)';
IR3 = xt(1:length(a),1:N);
shocky=mpshock;

%--------------------------------------------------------------------%
% EVENT STUDIES 
%--------------------------------------------------------------------%

if not(pub); 
 figure;
 plot(yield_date_graph(4152:end), target(4152:end), 'k', ...
      yield_date_graph(4152:end), e1m(4152:end), 'r');
 axis([2000.9 2001.9 1.5 7]);
 print -dpsc event.ps;
end; 
 
 X=[target_date target e1m];
%disp(X(4150:end,:));

format short;

disp('December 18 1990 episode');
disp(X(1794:1800,:));

disp('October 15 1998 episode');
disp(X(3834:3840,:));

disp('September 17 2001 episode: surprise');
disp(X(4596:4601,:));

disp('October 2 2001 episode: no surprise');
disp(X(4607:4613,:));

disp('November 6 2001 episode');
disp(X(4632:4638,:))

%---------------------------------------------------------------------------%
% HIGH FREQUENCY SHOCK 
%---------------------------------------------------------------------------%
% CONDITIONING INFORMATION: target, short euros, long treasury 
% MP specification leads to a huge positive shock in 1987. 
% ADD regression of interest rate changes on shock on day of shock. 

nolagy =  [target(1:end)   yields(1:end,:)];

lagy=[target(1)         yields(1,:); ...
      target(1:end-1)   yields(1:end-1,:)];

lagbigy=[target(1)         bigyields(1,:); ...
         target(1:end-1)   bigyields(1:end-1,:)];


lagy=[target(1)         yields(1,:); ...
      target(1)         yields(1,:);
      target(1:end-2)   yields(1:end-2,:)];
   
lagbigy=[target(1)         bigyields(1,:); ...
         target(1)         bigyields(1,:);
         target(1:end-2)   bigyields(1:end-2,:)];

postbigy = [ target(2:end) bigyields(2:end,:); ...
             target(end)   bigyields(end,:)];  % for interest rate change regression

%postbigy = [ target(1:end) bigyields(1:end,:)];


% TRY CUTTING SAMPLE TO SAME SUBSAMPLE
nolagy = nolagy(131:4153,:);
lagy=lagy(131:4153,:);
lagbigy=lagbigy(131:4153,:);
postbigy = postbigy(131:4153,:);

target=target(131:4153);
dates=dates(131:4153);

% SUBSAMPLE OF NONZERO TARGET MOVES
changes=diff(target); %  first difference of target
ind=find(changes);    %  indices of when first difference is nonzero
ind=ind+1;            %  add 1 because first difference starts at 2:end

% DATES FOR THIS SUBSAMPLE
yr = floor(dates(ind)/10000); 
mo = dates(ind)-10000*yr;
mo = floor(mo/100);
day = dates(ind)-10000*yr-100*mo;

% REGRESSION
lhs=target(ind);          %  target levels on days with nonzero move
rhs=lagy(ind,:);          %  yields on those days

% MP: shouldn't newey west lags be zero? 
%[b,varb,R2]=olsnw(lhs,rhs,6);
[b,varb,R2]=olsnw(lhs,rhs,0);
rule=b(1)+rhs*b(2:end);
s=lhs-rule;               % shock series on each day of move 
sdev = sqrt(diag(varb));

disp('regression results for high-frequency rule');
disp('Rhv are target, 3 mo Euro, 2 5 10 year treas');  
disp([b';b'./sdev']');
disp('R2:');
disp(R2);

% plot high frequency forecast and actual 

if not(pub); 
 bigrule = b(1) + nolagy*b(2:end); 
 figure;
 plot(yield_date_graph(131:4153), [nolagy(:,1) bigrule]); 
end; 

% Regression expressed in difference, spread form, and larger regressions for reference

[b,varb,R2]=olsnw(target(ind)-target(ind-1),...
   [lagy(ind,1) lagy(ind,2:end)-lagy(ind,1)*ones(1,size(lagy(ind,2:end),2))],0);
disp('regression of change in target on lagged target and spreads -- identical regression');
sdev = sqrt(diag(varb));
disp([[0 0 3 2 5 10] ; b';b'./sdev']');
disp('R2:');
disp(R2);

expchange =  [ones(size(ind,1),1) lagy(ind,1) lagy(ind,2:end)-lagy(ind,1)*ones(1,size(lagy(ind,2:end),2))]*b; ;

[b,varb,R2]=olsnw(target(ind)-target(ind-1),...
   [lagbigy(ind,1) lagbigy(ind,2:end)-lagbigy(ind,1)*ones(1,size(lagbigy(ind,2:end),2))],0);
disp('regression of change in target on lagged target and all spreads -- 1 3 6 mo 1 2 3 5 10 T');
sdev = sqrt(diag(varb));
disp([[0 0 1 3 6 1 2 3 5 10] ; b';b'./sdev']');
disp('R2');
disp(R2);


% Regression of interest rate changes on expected, unexpected shocks. 

% WHY IS THIS A DISASTER. IT"S IMPORTANT!
disp('WHY IS THIS A DISASTER'); 
disp('WHY DO EXPECTED TARGET CHANGES RAISE OTHER RATES, AND UNEXPECTED COEFFICIENT ISNT MUCH BIGGER?'); 

[b,se,R2,v] = olsgmm(postbigy(ind,:)-lagbigy(ind,:),[ones(size(s,1),1) target(ind)-target(ind-1)],0,0);
disp('regression of yield changes on target change');
disp(' mat const coef tconst tcoef R2'); 
disp([[0 1 3 6 1 2 3 5 10]' b' b'./se' R2]);

[b,se,R2,v] = olsgmm(postbigy(ind,:)-lagbigy(ind,:),[ones(size(s,1),1) expchange],0,0);
disp('regression of yield changes on expected target change');
disp(' mat const coef tconst tcoef R2'); 
disp([[0 1 3 6 1 2 3 5 10]' b' b'./se' R2]);

[b,se,R2,v] = olsgmm(postbigy(ind,:)-lagbigy(ind,:),[ones(size(s,1),1) s],0,0);
disp('regression of yield changes on unexpected target change');
disp(' mat const coef tconst tcoef R2'); 
disp([[0 1 3 6 1 2 3 5 10]' b' b'./se' R2]);

% ADDING SHOCKS UP DURING THE MONTH
ms=s(1);                  
T=length(mo);
mo=[mo;mo(end)+1];
yr=[yr;yr(end)];

s=[s;0];

for t=2:T+1
    if mo(t) ~= mo(t-1)
        shock_hf(t-1,:)=[yr(t-1) mo(t-1) ms];
        ms=s(t);
    else
        ms=ms+s(t);
    end
end

% COLLECT NONZERO SHOCKS DURING THE MONTH
moind=find(shock_hf(:,3));
shock_hf=shock_hf(moind,:);

% month and year during sample from 1984:2 to 2001:11
% do this using monthly fed funds data from 1954:7 to 2001:11 
load ..\data\fedfunds.dat;
fedfunds=fedfunds(92:end,:); 

mese = fedfunds(265:end,1);
anno = floor(mese); 
mese = round(100*(mese-anno));

% AGAIN, CUT TO SAME SUBSAMPLE
mese=mese(7:end-(11+12));
anno=anno(7:end-(11+12));
shock_hf=[shock_hf;[0 0 0]];


i=1;
T=length(mese);
for t=1:T
    if (mese(t)==shock_hf(i,2))*(anno(t)==shock_hf(i,1))>0;
        shock(t,:)=shock_hf(i,:);
        i=i+1;
    else 
        shock(t,:)=[anno(t) mese(t) 0];
    end
end

shock_hf=shock;
save shock_hf.dat shock_hf -ascii;


% ----------------------------------------------------------------------------
% JC approach to high frequency shock from plotjc
% ----------------------------------------------------------------------------

changes=diff(target); %  first difference of target
ind=find(changes);    %  indices of when first difference is nonzero
ind=ind+1;            %  add 1 because first difference starts at 2:end

% DATES FOR THIS SUBSAMPLE

yr = floor(dates(ind)/10000); 
mo = dates(ind)-10000*yr;
mo = floor(mo/100);
day = dates(ind)-10000*yr-100*mo;

e1m = e1m(131:4153);  %  cut to sample

if not(pub); 
	figure; 
	plot([target e1m]);
end; 

lags = 2; % how far back to look for initial rate. ind is the 1st day of new rate
   
   %if change on date ind=4 (i.e. 3 is last day of old rate) then look 
   % at change from 1 to 5. In many episodes it moves first. 
   
e1shock  = e1m(ind+1)-e1m(ind-lags);   

% ADDING SHOCKS UP DURING THE MONTH
ms=e1shock(1);                  
T=length(mo);
mo=[mo;mo(end)+1];
yr=[yr;yr(end)];
e1shock=[e1shock;0];


for t=2:T+1
    if mo(t) ~= mo(t-1)
        e1shock_hf(t-1,:)=[yr(t-1) mo(t-1) ms];
        ms=e1shock(t);
    else
        ms=ms+e1shock(t);
    end
end

% COLLECT NONZERO SHOCKS DURING THE MONTH
moind=find(e1shock_hf(:,3));
e1shock_hf=e1shock_hf(moind,:);
e1shock_hf=[e1shock_hf;[0 0 0]];

i=1;
T=length(mese);
for t=1:T
    if (mese(t)==e1shock_hf(i,2))*(anno(t)==e1shock_hf(i,1))>0;
        shockx(t,:)=e1shock_hf(i,:);
        i=i+1;
    else 
        shockx(t,:)=[anno(t) mese(t) 0];
    end
end

e1shock_hf=shockx;

% ---------------------------------------------------------------------------%
% COMPARISON OF HIGH-FREQUENCY SHOCK AND CEE SHOCK 
% ---------------------------------------------------------------------------%

% PLOT HIGH-FREQUENCY SHOCK AND CEE SHOCK
% better plots below. 
if 0; 
 ax=[1984.5 2000 -1 1];
 figure;
 subplot(2,1,1);
 %plot(shock_hf(:,1)+shock_hf(:,2)/12, shock_hf(:,3));
 plot(shock_hf(:,1)+shock_hf(:,2)/12, shock_hf(:,3));
 title('High-frequency policy shock');
 axis(ax);
 subplot(2,1,2); 

 %plot(shock_hf(vlag+1:end-(11+12),1)+shock_hf(vlag+1:end-(11+12),2)/12, ceeshock);

 plot(shock_hf(:,1)+shock_hf(:,2)/12, ceeshock);
 title('CEE shock');
 axis(ax);
 print -dpsc compare.ps;


 % STANDARD DEVIATIONS OF THESE SHOCKS
 disp('standard deviation of high-freq shock and CEE');
 [m,c]=semom(shock_hf(:,3),4);
 [m2,c2]=semom(ceeshock,4);
 disp([m(2) sqrt(c(2,2)) m2(2) sqrt(c2(2,2))]);
end; 

%---------------------------------------------------------------------------------
% JC IRs 
%---------------------------------------------------------------------------------
% at this point all data are 191 long and all shocks are 185 
% MONIKA: I couldn't understand the dating and I think there were some
% bugs. I started over. 
% I also changed the regressions to differences on shocks

K = 24; % number of IRs

yields=[target_m yields_m]; %Treasuries
mat = [1/30 6 24 60 120];

% NORMALIZE THE SHOCKS 
% Redo this  by normalizing so that the 0 response of fftarget is 1.0

shockst= shock(:,3);
ffsst= ceeshock;
jcst = e1shock_hf(:,3);
ysst= yshock;
syst= shocky;

if not(pub); 
 figure; 
 plot((1984+8/12:1/12:1999+12/12)', 2*[5+ffsst 5+zeros(size(shockst,1),1) 3.75+jcst 2.5+shockst ],...
      (1984+8/12:1/12:1999+12/12)',yields(vlag+1:end,1) );
 title('Target with high-frequency and cee shocks');
 legend('CEE',' ','\Delta 1 mo Euro','regression'); 

 print -depsc shocks.eps; 

 figure; 
 plot((1984+8/12:1/12:1999+12/12)', cumsum([shockst jcst ffsst]), (1984+8/12:1/12:1999+12/12)', yields(vlag+1:end,1));
 title('Target with cumulative high-frequency and cee shock');
 legend('regression','\Delta 1 mo Euro','CEE');
 
 % is a moving average of shocks clearer? 
trash = [ zeros(12,3) ; [shockst jcst ffsst]];
sumshocks = zeros(size(trash));
for j=13:size(sumshocks,1);
   sumshocks(j,:) = sum(trash(j-12:j,:));
   if j<24; 
      sumshocks(j,:) = sumshocks(j,:)/(j-12);
   else;
      sumshocks(j,:) = sumshocks(j,:)/12;
   end;
end; 
sumshocks = sumshocks(13:end,:); 

figure;
plotyy((1984+8/12:1/12:1999+12/12)', sumshocks, (1984+8/12:1/12:1999+12/12)', yields(vlag+1:end,1));
title('Target with moving average of high-frequency and cee shock');
legend('regression','\Delta 1 mo Euro','CEE');
end; 

T=size(yields,1);

%mp: lhvall = [nonfarm(K:T) cpi(K:T) pcom(K:T) y(K:T,:)]; 
% I think this is a mistake -- ignores the initial lags'; T is not the end
% jc: use differences so that spurious correlation of levels, shocks doesn't influence

% THIS WAY DOES FIRST DIFFERENCES, ADDS THEM UP.  NO LONGER USED
if 0; 
 lhvall = diff([nonfarm(vlag:end) cpi(vlag:end) pcom(vlag:end) yields(vlag:end,:)]); 

 disp(' first 5 nonfarm and cee shock');
 disp([lhvall(1:5,1) ffsst(1:5)]);

 IR1 = [ones(T-vlag,1) shockst]\lhvall;
 IR2 = [ones(T-vlag,1) ffsst]\lhvall;
 IR3 = [ones(T-vlag,1) ysst]\lhvall;
 IR4 = [ones(T-vlag,1) syst]\lhvall;

 IR1 = IR1(2,:);
 IR2 = IR2(2,:);
 IR3 = IR3(2,:);
 IR4 = IR4(2,:);

 for indx = 1:K; 
	IR1a = [ones(T-vlag-indx,1) shockst(1:end-indx)]\lhvall(1+indx:end,:);
	IR2a = [ones(T-vlag-indx,1)   ffsst(1:end-indx)]\lhvall(1+indx:end,:);
	IR3a = [ones(T-vlag-indx,1)    ysst(1:end-indx)]\lhvall(1+indx:end,:);
	IR4a = [ones(T-vlag-indx,1)    syst(1:end-indx)]\lhvall(1+indx:end,:);
	
	IR1 = [IR1; IR1a(2,:)];
	IR2 = [IR2; IR2a(2,:)];
	IR3 = [IR3; IR3a(2,:)];
	IR4 = [IR4; IR4a(2,:)];
   
 end;

 % back to levels
 IR1 = cumsum(IR1);
 IR2 = cumsum(IR2);
 IR3 = cumsum(IR3);
 IR4 = cumsum(IR4);
end; 

% LONG DIFFERENCES AND A DIRECT REGRESSION  This gives very similar results. 
% TRY LEVELS A LA MP. YIELDS ARE STATIONARY SO IT SHOULD WORK
if 1; 
 lhvall = [nonfarm(vlag:end) cpi(vlag:end) pcom(vlag:end) yields(vlag:end,:)]; 
 chglhv = lhvall(2:end,:)-lhvall(1:end-1,:);
 [IR1, IR1se, R2, v]  = olsgmm( chglhv, [ones(T-vlag,1) shockst],0,0);  
 [IR2, IR2se, R2, v]  = olsgmm( chglhv, [ones(T-vlag,1) ffsst],0,0);
 [IR3, IR3se, R2, v]  = olsgmm( chglhv, [ones(T-vlag,1) ysst],0,0);
 [IR4, IR4se, R2, v]  = olsgmm( chglhv, [ones(T-vlag,1) syst],0,0);
 [IR5, IR5se, R2, v]  = olsgmm( chglhv, [ones(T-vlag,1) jcst],0,0);
% IR1 = [ones(T-vlag,1) shockst]\(lhvall(2:end,:)-lhvall(1:end-1,:));
% IR2 = [ones(T-vlag,1) ffsst]\(lhvall(2:end,:)-lhvall(1:end-1,:));
% IR3 = [ones(T-vlag,1) ysst]\(lhvall(2:end,:)-lhvall(1:end-1,:));
% IR4 = [ones(T-vlag,1) syst]\(lhvall(2:end,:)-lhvall(1:end-1,:)); 
% IR5 = [ones(T-vlag,1) jcst]\(lhvall(2:end,:)-lhvall(1:end-1,:)); 
 
 IR1 = IR1(2,:);
 IR2 = IR2(2,:);
 IR3 = IR3(2,:);
 IR4 = IR4(2,:); 
 IR5 = IR5(2,:); 
 
 IR1se = IR1se(2,:);
 IR2se = IR2se(2,:);
 IR3se = IR3se(2,:);
 IR4se = IR4se(2,:); 
 IR5se = IR5se(2,:); 
 
 for indx = 1:K;
    
   chglhv = lhvall(2+indx:end,:)-lhvall(1:end-indx-1,:);
 	[IR1a, IR1sea, R2, v]  = olsgmm( chglhv, [ones(T-vlag-indx,1) shockst(1:end-indx)],indx,1);  
 	[IR2a, IR2sea, R2, v]  = olsgmm( chglhv, [ones(T-vlag-indx,1) ffsst(1:end-indx)],indx,1);
 	[IR3a, IR3sea, R2, v]  = olsgmm( chglhv, [ones(T-vlag-indx,1) ysst(1:end-indx)],indx,1);
 	[IR4a, IR4sea, R2, v]  = olsgmm( chglhv, [ones(T-vlag-indx,1) syst(1:end-indx)],indx,1);
 	[IR5a, IR5sea, R2, v]  = olsgmm( chglhv, [ones(T-vlag-indx,1) jcst(1:end-indx)],indx,1);

%   IR1a = [ones(T-vlag-indx,1) shockst(1:end-indx)]\(lhvall(2+indx:end,:)-lhvall(1:end-indx-1,:));
%   IR2a = [ones(T-vlag-indx,1)   ffsst(1:end-indx)]\(lhvall(2+indx:end,:)-lhvall(1:end-indx-1,:));
%   IR3a = [ones(T-vlag-indx,1)    ysst(1:end-indx)]\(lhvall(2+indx:end,:)-lhvall(1:end-indx-1,:));
%   IR4a = [ones(T-vlag-indx,1)    syst(1:end-indx)]\(lhvall(2+indx:end,:)-lhvall(1:end-indx-1,:));
%   IR5a = [ones(T-vlag-indx,1)    jcst(1:end-indx)]\(lhvall(2+indx:end,:)-lhvall(1:end-indx-1,:));
	
	IR1 = [IR1; IR1a(2,:)];
	IR2 = [IR2; IR2a(2,:)];
	IR3 = [IR3; IR3a(2,:)];
	IR4 = [IR4; IR4a(2,:)];
	IR5 = [IR5; IR5a(2,:)];
   
   IR1se = [IR1se; IR1sea(2,:)];
	IR2se = [IR2se; IR2sea(2,:)];
	IR3se = [IR3se; IR3sea(2,:)];
	IR4se = [IR4se; IR4sea(2,:)];
	IR5se = [IR5se; IR5sea(2,:)];
  
 end;
end; 

% Normalize responses so that impact response to funds target is 1.0. 

IR1se = IR1se./IR1(1,4); 
IR2se = IR2se./IR2(1,4); 
IR3se = IR3se./IR3(1,4); 
IR4se = IR4se./IR4(1,4); 
IR5se = IR5se./IR5(1,4); 

IR1 = IR1./IR1(1,4); 
IR2 = IR2./IR2(1,4); 
IR3 = IR3./IR3(1,4); 
IR4 = IR4./IR4(1,4); 
IR5 = IR5./IR5(1,4); 

% scatter plots of some regressions 
% use these to find which data points account for different IRs -- i.e. inflation at y is preceded by shock at x 

% Comment in or out which scatterplots you want to see. 
if not(pub); 
if 1; 
   
 horiz = 12; 
 ys = (lhvall(2+horiz:end,:)-lhvall(1:end-horiz-1,:));
 IR1x = [ones(T-vlag-horiz,1) shockst(1:end-horiz)]\ys;
 IR2x = [ones(T-vlag-horiz,1)   ffsst(1:end-horiz)]\ys;
 IR5x = [ones(T-vlag-horiz,1)    jcst(1:end-horiz)]\ys;
 
 datechar = [8408; 8409; 8410; 8411; 8412; kron((85:99)',ones(12,1))*100+kron(ones(15,1),(1:12)')]; 
 datechar = num2str(datechar); 
 
 figure; 
 plot(shockst(1:end-horiz),ys(:,1),'.-b'); 
 hold on;  
 plot(shockst(1:end-horiz), [ones(T-vlag-horiz,1) shockst(1:end-horiz)]*IR1x(:,1),'-r');
 text(shockst(1:end-horiz),ys(:,1)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
 title('output response to high freq regression shock'); 
 
 
 figure; 
 plot(jcst(1:end-horiz),ys(:,1),'.-b'); 
 hold on; 
 plot(jcst(1:end-horiz), [ones(T-vlag-horiz,1) jcst(1:end-horiz)]*IR5x(:,1),'-r');
 text(jcst(1:end-horiz),ys(:,1)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
 title('output response to 1m Euro shock'); 
  
 figure; 
 plot(ffsst(1:end-horiz),ys(:,1),'.-b'); 
 hold on; 
 plot(ffsst(1:end-horiz), [ones(T-vlag-horiz,1) ffsst(1:end-horiz)]*IR2x(:,1),'-r');
 text(ffsst(1:end-horiz),ys(:,1)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
 title('output response to CEE shock'); 
 
 figure; 
 plot(shockst(1:end-horiz),ys(:,2),'.-b'); 
 hold on; 
 plot(shockst(1:end-horiz), [ones(T-vlag-horiz,1) shockst(1:end-horiz)]*IR1x(:,2),'-r');
 text(shockst(1:end-horiz),ys(:,2)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
 title('price response to regression shock'); 
 
 figure; 
 plot(jcst(1:end-horiz),ys(:,2),'.-b'); 
 hold on; 
 plot(jcst(1:end-horiz), [ones(T-vlag-horiz,1) jcst(1:end-horiz)]*IR5x(:,2),'-r');
 text(jcst(1:end-horiz),ys(:,2)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
 title('price response to 1m Euro shock'); 
  
 figure; 
 plot(ffsst(1:end-horiz),ys(:,2),'.-b'); 
 hold on; 
 plot(ffsst(1:end-horiz), [ones(T-vlag-horiz,1) ffsst(1:end-horiz)]*IR2x(:,2),'-r');
 text(ffsst(1:end-horiz),ys(:,2)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
 title('price response to CEE shock'); 
 
 end; 
end; 

 % YIELD GRAPHS
if not(pub);  
 if 1; 
  % target to 1m Euro
  figure; 
  plot(jcst(1:end-horiz),ys(:,4),'.-b'); 
  hold on; 
  plot(jcst(1:end-horiz), [ones(T-vlag-horiz,1) jcst(1:end-horiz)]*IR5x(:,4),'-r');
  text(jcst(1:end-horiz),ys(:,4)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
  title('Target response to 1m Euro shock'); 
  
  figure; 
  plot(jcst(1:end-horiz),ys(:,6),'.-b'); 
  hold on; 
  plot(jcst(1:end-horiz), [ones(T-vlag-horiz,1) jcst(1:end-horiz)]*IR5x(:,6),'-r');
  text(jcst(1:end-horiz),ys(:,6)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
  title('2 year yield response to 1m Euro shock'); 
  
  %scatter plots of instantaneous response  
  horiz = 1; 
  ys = (lhvall(2+horiz:end,:)-lhvall(1:end-horiz-1,:));
  IR1x = [ones(T-vlag-horiz,1) shockst(1:end-horiz)]\ys;
  IR2x = [ones(T-vlag-horiz,1)   ffsst(1:end-horiz)]\ys;
  IR5x = [ones(T-vlag-horiz,1)    jcst(1:end-horiz)]\ys;

  % 2 year target to 1m Euro
  figure; 
  plot(jcst(1:end-horiz),ys(:,6),'.-b'); 
  hold on; 
  plot(jcst(1:end-horiz), [ones(T-vlag-horiz,1) jcst(1:end-horiz)]*IR5x(:,6),'-r');
  text(jcst(1:end-horiz),ys(:,6)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
  title('2 year yield response to 1m Euro shock'); 
  
  figure; 
  plot(jcst(1:end-horiz),ys(:,7),'.-b'); 
  hold on; 
  plot(jcst(1:end-horiz), [ones(T-vlag-horiz,1) jcst(1:end-horiz)]*IR5x(:,7),'-r');
  text(jcst(1:end-horiz),ys(:,7)+0.1,datechar(1:end-horiz,:),'Fontsize',9); 
  title('5 year yield response to 1m Euro shock'); 
  
  
end; 
end;  

% PLOT IMPLUSE RESPONSES

a=(1:K)';
b=[0 K 0 2.5];

% yield responses
IRy1=IR1(:,4:end);
IRy2=IR2(:,4:end);
IRy3=IR3(:,4:end);
IRy4=IR4(:,4:end);
IRy5=IR5(:,4:end);

IRy1se=IR1se(:,4:end);
IRy2se=IR2se(:,4:end);
IRy3se=IR3se(:,4:end);
IRy4se=IR4se(:,4:end);
IRy5se=IR5se(:,4:end);



% plot of impact multiplier to yields across maturity
% INCREASE TO ALL MATURITIES

if not(pub); 
 figure;
 xs = (1:size(IRy1(1,:),2))';
 errorbar(xs,IRy1(1,:)',IRy1se(1,:)', '-rv'); 
 text(5.15, 0.8, '1 mo Euro');
 text(5.10, 0.55, 'regression'); 
 text(5.05, 0.25, 'CEE VAR'); 
 text(0.8,0.7,'Target');
 text(1.7,0.8,'3 mo');
 text(2.7,0.5,'2 Yr');
 text(3.7,0.2,'5 Yr');
 text(4.7,0.005,'10 Yr'); 

 hold on; 
 errorbar(xs+0.1,IRy5(1,:)',IRy5se(1,:)', '-bo'); 
 hold on; 
 errorbar(xs-0.1,IRy4(1,:)',IRy4se(1,:)', '--k^');
 axis([0.75 5.5 0 1.6]);     
 print -depsc2 cross.eps;
end; 
if pub; 
 figure;
 xs = (1:size(IRy1(1,:),2))';
 errorbar(xs,IRy1(1,:)',IRy1se(1,:)', '-kv'); 
 text(4.2, 0.95, 'Euro','FontSize',16);
 text(4.1, 0.6, 'Regression','FontSize',16); 
 text(4.1, 0.3, 'CEE','FontSize',16); 
 text(0.8,0.7,'Target','FontSize',16);
 text(1.8,0.7,'3 mo','FontSize',16);
 text(2.8,0.45,'2 yr','FontSize',16);
 text(3.8,0.15,'5 yr','FontSize',16);
 text(4.9,0.1,'10 yr','FontSize',16); 
 
 set(gca,'XTick',-1);
 set(gca,'ytick',[0 0.5 1 1.5],'FontSize',16);
 

 hold on; 
 errorbar(xs+0.1,IRy5(1,:)',IRy5se(1,:)', '-ko'); 
 hold on; 
 errorbar(xs-0.1,IRy4(1,:)',IRy4se(1,:)', '--k^');
 axis([0.75 5.2 0 1.6]);     
 print -deps2 cross_a.eps;
end; 

% plot of dynamic yield response
if not(pub); 

 figure;
 plot(1:25,IRy1(:,1),'-r',...
   1:25,IRy1(:,2),'-g',...
   1:25,IRy1(:,3),'-b',...
   1:25,IRy1(:,4),'-c',...
   1:25,IRy1(:,5),'-m',...
   1:25,zeros(25,1),'-k');
 legend('target','3 mo','2 yr','5 yr','10 yr',0);
 title('Regression shock');
 hold on; 
 errorbar([6 18],  [IRy1(6,1)  IRy1(18,1)],[ IRy1se(6,1) IRy1se(18,1)] ,'+r');  
 errorbar([7 19],  [IRy1(7,2)  IRy1(19,2)],[ IRy1se(7,2) IRy1se(19,2)] ,'+g');  
 errorbar([8 20],  [IRy1(8,3)  IRy1(20,3)],[ IRy1se(8,3) IRy1se(20,3)] ,'+b');  
 errorbar([9 21],  [IRy1(9,4)  IRy1(21,4)],[ IRy1se(9,4) IRy1se(21,4)] ,'+c');  
 errorbar([10 22], [IRy1(10,5) IRy1(22,5)],[ IRy1se(10,5) IRy1se(22,5)] ,'+m');  
 print -dpsc IRyield1.eps;

 figure;
 plot(1:25,IRy5(:,1),'-r',...
   1:25,IRy5(:,2),'-g',...
   1:25,IRy5(:,3),'-b',...
   1:25,IRy5(:,4),'-c',...
   1:25,IRy5(:,5),'-m',...
   1:25,zeros(25,1),'-k');
 legend('target','3 mo','2 yr','5 yr','10 yr',0);
 title('1 mo Euro shock');
 hold on; 
 errorbar([6 18],  [IRy5(6,1)  IRy5(18,1)],[ IRy5se(6,1) IRy5se(18,1)] ,'+r');  
 errorbar([7 19],  [IRy5(7,2)  IRy5(19,2)],[ IRy5se(7,2) IRy5se(19,2)] ,'+g');  
 errorbar([8 20],  [IRy5(8,3)  IRy5(20,3)],[ IRy5se(8,3) IRy5se(20,3)] ,'+b');  
 errorbar([9 21],  [IRy5(9,4)  IRy5(21,4)],[ IRy5se(9,4) IRy5se(21,4)] ,'+c');  
 errorbar([10 22], [IRy5(10,5) IRy5(22,5)],[ IRy5se(10,5) IRy5se(22,5)] ,'+m');  
 print -dpsc IRyield2.eps;


 figure;
 plot(1:25,IRy2(:,1),'-r',...
    1:25,IRy2(:,2),'-g',...
   1:25,IRy2(:,3),'-b',...
   1:25,IRy2(:,4),'-c',...
   1:25,IRy2(:,5),'-m',...
   1:25,zeros(25,1),'-k');
 legend('target','3 mo','2 yr','5 yr','10 yr',0);
 title('CEE shock');
 hold on; 
 errorbar([6 18],  [IRy2(6,1)  IRy2(18,1)],[ IRy2se(6,1) IRy2se(18,1)] ,'+r');  
 errorbar([7 19],  [IRy2(7,2)  IRy2(19,2)],[ IRy2se(7,2) IRy2se(19,2)] ,'+g');  
 errorbar([8 20],  [IRy2(8,3)  IRy2(20,3)],[ IRy2se(8,3) IRy2se(20,3)] ,'+b');  
 errorbar([9 21],  [IRy2(9,4)  IRy2(21,4)],[ IRy2se(9,4) IRy2se(21,4)] ,'+c');  
 errorbar([10 22], [IRy2(10,5) IRy2(22,5)],[ IRy2se(10,5) IRy2se(22,5)] ,'+m');  
 print -dpsc IRyield3.eps;
end; 

if pub; 
 figure;
 plot(1:25,IRy1(:,1),'-k',...
   1:25,IRy1(:,2),'-k',...
   1:25,IRy1(:,3),'--k',...
   1:25,IRy1(:,4),'--k',...
   1:25,IRy1(:,5),'--k',...
   1:25,zeros(25,1),'-k');
axis([0,24,-1,3]);
set(gca,'XTick',0:6:24);
 set(gca,'XTickLabel',{'0',' ','12',' ','24'},'FontSize',16);
 set(gca,'ytick',[-1 0 1 2 3 4 5],'FontSize',16);
 
 %legend('target','3 mo','2 yr','5 yr','10 yr',0);
 %title('Regression shock');
 hold on; 
 errorbar([6 18],  [IRy1(6,1)  IRy1(18,1)],[ IRy1se(6,1) IRy1se(18,1)] ,'vk');  
% errorbar([7 19],  [IRy1(7,2)  IRy1(19,2)],[ IRy1se(7,2) IRy1se(19,2)] ,'+k');  
% errorbar([8 20],  [IRy1(8,3)  IRy1(20,3)],[ IRy1se(8,3) IRy1se(20,3)] ,'+k');  
 errorbar([9 21],  [IRy1(9,4)  IRy1(21,4)],[ IRy1se(9,4) IRy1se(21,4)] ,'ok');  
% errorbar([10 22], [IRy1(10,5) IRy1(22,5)],[ IRy1se(10,5) IRy1se(22,5)] ,'+k');  
 print -deps2 IRyield1a.eps;
 
  figure;
 plot(1:25,IRy2(:,1),'-k',...
    1:25,IRy2(:,2),'-k',...
   1:25,IRy2(:,3),'--k',...
   1:25,IRy2(:,4),'--k',...
   1:25,IRy2(:,5),'--k',...
   1:25,zeros(25,1),'-k');
 axis([0,24,-2.5,1.5]);
 set(gca,'XTick',0:6:24);
 set(gca,'XTickLabel',{'0',' ','12',' ','24'},'FontSize',16);
 set(gca,'ytick',[-3 -2 -1 0 1 2 3 4 5],'FontSize',16);
 % CEE SHOCK
 hold on; 
 errorbar([6 18],  [IRy2(6,1)  IRy2(18,1)],[ IRy2se(6,1) IRy2se(18,1)] ,'vk');  
% errorbar([7 19],  [IRy2(7,2)  IRy2(19,2)],[ IRy2se(7,2) IRy2se(19,2)] ,'+g');  
% errorbar([8 20],  [IRy2(8,3)  IRy2(20,3)],[ IRy2se(8,3) IRy2se(20,3)] ,'+b');  
 errorbar([9 21],  [IRy2(9,4)  IRy2(21,4)],[ IRy2se(9,4) IRy2se(21,4)] ,'ok');  
% errorbar([10 22], [IRy2(10,5) IRy2(22,5)],[ IRy2se(10,5) IRy2se(22,5)] ,'+m');  
 print -deps2 IRyield3a.eps;


end; 

% plot marcro resposnes
% Dropped IR 2 3 for simplicity 
% add standard error bars

% version with no se bars
if 1;
if not(pub); 
figure;
 subplot(2,2,1);
 plot(1:25, IR1(:,1), '-r',...
      1:25, IR5(:,1), '-g',...
      1:25, IR2(:,1), '-b',...
      1:25, zeros(size(IR1,1),1), '-k');
 title('Nonfarm employment');
 hold on;
 errorbar([6 18], IR1([6 18],1), IR1se([6 18],1), '+r'); 
 errorbar([7 19], IR5([7 19],1), IR1se([7 19],1), '+g'); 
 errorbar([8 20], IR2([8 20],1), IR1se([8 20],1), '+b'); 
 
 subplot(2,2,2);
 plot(1:25, IR1(:,2), '-r',...
      1:25, IR5(:,2), '-g',...
      1:25, IR2(:,2), '-b',...
      1:25, zeros(size(IR1,1),1), '-k');
   title('CPI');
 legend('regression','1 mo Euro$','CEE',0);
 hold on;
 errorbar([6 18], IR1([6 18],2), IR1se([6 18],2), '+r'); 
 errorbar([7 19], IR5([7 19],2), IR1se([7 19],2), '+g'); 
 errorbar([8 20], IR2([8 20],2), IR1se([8 20],2), '+b'); 
 
 subplot(2,2,3);
 plot(1:25, IR1(:,3), '-r',...
      1:25, IR5(:,3), '-g',...
      1:25, IR2(:,3), '-b',...
      1:25, zeros(size(IR1,1),1), '-k');
 title('Pcom');
 hold on;
 errorbar([6 18], IR1([6 18],3), IR1se([6 18],3), '+r'); 
 errorbar([7 19], IR5([7 19],3), IR1se([7 19],3), '+g'); 
 errorbar([8 20], IR2([8 20],3), IR1se([8 20],3), '+b'); 
 
 subplot(2,2,4);
 plot(1:25, IR1(:,4), '-r',...
      1:25, IR5(:,4), '-g',...
      1:25, IR2(:,4), '-b',...
      1:25, zeros(size(IR1,1),1), '-k');
 title('Target');
 hold on;
 errorbar([6 18], IR1([6 18],4), IR1se([6 18],4), '+r'); 
 errorbar([7 19], IR5([7 19],4), IR1se([7 19],4), '+g'); 
 errorbar([8 20], IR2([8 20],4), IR1se([8 20],4), '+b'); 
 
 print -deps2 newmacro.eps;
end; % ends color version 

if pub; % B&W version
figure;
 plot(1:25, IR1(:,1), '-k',...
      1:25, IR5(:,1), '-k',...
      1:25, IR2(:,1), '--k',...
      1:25, zeros(size(IR1,1),1), '-k');
 axis([0 24 -2 2]); 
 set(gca,'XTick',0:6:24);
 set(gca,'XTickLabel',{'0',' ','12',' ','24'},'FontSize',16);
 set(gca,'ytick',[-3 -2 -1 0 1 2 3 4 5],'FontSize',16);
 % title('Nonfarm employment');
 hold on;
 errorbar([6 18], IR1([6 18],1), IR1se([6 18],1), 'vk'); 
 errorbar([7 19], IR5([7 19],1), IR1se([7 19],1), 'ok'); 
 errorbar([8 20], IR2([8 20],1), IR1se([8 20],1), '^k'); 
 print -deps2 newmacro_1.eps;

 figure; 
 plot(1:25, IR1(:,2), '-k',...
      1:25, IR5(:,2), '-k',...
      1:25, IR2(:,2), '--k',...
      1:25, zeros(size(IR1,1),1), '-k');
 axis([0 24 -1 3]);   
 set(gca,'XTick',0:6:24);
 set(gca,'XTickLabel',{'0',' ','12',' ','24'},'FontSize',16);
 set(gca,'ytick',[-3 -2 -1 0 1 2 3 4 5],'FontSize',16);
 %title('CPI');
 %legend('regression','1 mo Euro$','CEE',0);
 hold on;
 errorbar([6 18], IR1([6 18],2), IR1se([6 18],2), 'vk'); 
 errorbar([7 19], IR5([7 19],2), IR1se([7 19],2), 'ok'); 
 errorbar([8 20], IR2([8 20],2), IR1se([8 20],2), '^k'); 
 print -deps2 newmacro_2.eps;
 
end; % ends B&W version 
end; % ends if 1 to choose this version

% version with no se bars
if 0; 
figure;
 subplot(2,2,1);
 plot([IR1(:,1) IR5(:,1) IR2(:,1) zeros(size(IR1,1),1) ]);
 title('Nonfarm employment');
 subplot(2,2,2);
 plot([IR1(:,2) IR5(:,2) IR2(:,2)  zeros(size(IR1,1),1) ]);
 legend('regression','1 mo Euro$','CEE',0);
 title('Cpi');
 subplot(2,2,3);
 plot([IR1(:,3) IR5(:,3) IR2(:,3) zeros(size(IR1,1),1) ]);
 title('Pcom');
 subplot(2,2,4);
 plot([IR1(:,4) IR5(:,4) IR2(:,4) zeros(size(IR1,1),1)]);
 title('Target');
 print -dpsc newmacro.eps;
end; 




%figure;
%plot(a,IR1(a,1),'r',a,IR3(a,1),'r:',a,IR1(a,2),'b',a,IR3(a,2),'b:');
%legend('employment - high-freq', ' nonfarm - low freq', 'cpi - high-freq', 'cpi - low-freq');
%print -dpsc IRmacro.ps;

STOP;

% --------------------------------------------------------------------------------
% MP IRs 
%---------------------------------------------------------------------------------
K = 12; % number of IRs

%yields=[target_m yields_m]; %Treasuries

yields=[target_m fbyields(:,[1 3 6 7 9 11])]; % zero-coupon responses
mat=[1/30 1 3 6 12 36 60];

% FB yields start in 1984:2, so shift:
yields=yields(vlag+1:end,:);   % up to 1999:12

% high frequency shock starts in 1984:2, so shift
% shock=shock_hf(vlag+1:end-(11+12),3); % goes up to end of 2001

y=yields(K+1:end,:);
shock=shock(K+1:end,3);
ffs=ceeshock(K+1:end);
ys=yshock(K+1:end);
sy=shocky(K+1:end);

% NORMALIZE THE SHOCKS??? 
% does not help, not sure what IR are  
 shockst=(shock-mean(shock))/std(shock);
 ffsst=(ffs-mean(ffs))/std(ffs);
 ysst=(ys-mean(ys))/std(ys);
 syst=(sy-mean(sy))/std(sy);

 figure; 
 plot([y(:,1) shockst ffsst]);
 title('Target with standardized high-frequency shock and cee shock');
 
T=size(y,1);
rhv1 = ones(T-K+1,1);
rhv2 = rhv1;
rhv3 = rhv1;
rhv4 = rhv1; 

for j = 1:K;
   rhv1 = [rhv1   shock(1+K-j:T-j+1)];
   rhv2 = [rhv2      ys(1+K-j:T-j+1)];   
   rhv3 = [rhv3      sy(1+K-j:T-j+1)];
   rhv4 = [rhv4     ffs(1+K-j:T-j+1)]; 
end;

lhvall = [nonfarm(K:T) cpi(K:T) pcom(K:T) y(K:T,:)]; 
bv1 = rhv1\lhvall;
bv2 = rhv2\lhvall;
bv3 = rhv3\lhvall;
bv4 = rhv4\lhvall;

IR1=bv1(2:end,:);
IR2=bv2(2:end,:);
IR3=bv3(2:end,:);
IR4=bv4(2:end,:);

a=(1:K)';
b=[0 K 0 2.5];

IRy1=IR1(:,4:end);
IRy2=IR2(:,4:end);
IRy3=IR3(:,4:end);
IRy4=IR4(:,4:end);

figure;
plot(mat',IRy1(1,:)', 'r', ...
     mat',IRy2(1,:)', 'b', ...
     mat',IRy3(1,:)', 'g', ...
     mat',IRy4(1,:)', 'k');
legend('high-frequency', 'Fed to y(t)', 'Fed to y(t-1)', 'CEE');
title('Cross-sectional response of yields to ?? monetary policy shock');
print -dpsc cross.ps;

figure;
subplot(4,1,1);
% target, 1, 3, 6 month, 1, 2, 3, 5, 10 year  = 9 IRs
%plot(a,IRy1(a,1),'r',a,IRy1(a,2),'m',a, IRy1(a,4), 'g', a,IRy1(a,6),'b',a,IRy1(a,end),'k');
plot(a,IRy1(a,1),'r',a,IRy1(a,2),'g',a,IRy1(a,3),'b',a,IRy1(a,5),'k');

title('high frequency shock');
axis(b);
subplot(4,1,2);
plot(a,IRy2(a,1),'r',a,IRy2(a,2),'g',a,IRy2(a,3),'b',a,IRy2(a,5),'k');

title('Fed reacts to y(t)');
axis(b);
subplot(4,1,3);
plot(a,IRy3(a,1),'r',a,IRy3(a,2),'g',a,IRy3(a,3),'b',a,IRy3(a,5),'k');

%plot(a,IRy3(a,1),'r',a,IRy3(a,2),'m',a, IRy3(a,4), 'g', a,IRy3(a,6),'b',a,IRy3(a,end),'k');
title('Fed reacts to y(t-1)');
axis(b);
subplot(4,1,4);
plot(a,IRy4(a,1),'r',a,IRy4(a,2),'g',a,IRy4(a,3),'b',a,IRy4(a,5),'k');

%plot(a,IRy4(a,1),'r',a,IRy4(a,2),'m',a, IRy4(a,4), 'g', a,IRy4(a,6),'b',a,IRy4(a,end),'k');
axis(b);
title('cee shock');
print -dpsc IRy.ps;


figure;
plot(a,IR1(a,1),'r',a,IR3(a,1),'r:',a,IR1(a,2),'b',a,IR3(a,2),'b:');
legend('nonfarm - high-freq', ' nonfarm - low freq', 'cpi - high-freq', 'cpi - low-freq');
print -dpsc IRmacro.ps;



