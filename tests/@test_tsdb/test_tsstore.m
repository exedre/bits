function self = test_load(self)
% Bank-IT Time Series Toolbox Test Suite

if ~exist('rootpwd')
    rootpwd='';
end

% setup test db
dbROOT = tsdb('J:mysql','root',rootpwd)
dbROOT=tslog(dbROOT,0);
tsadmin(dbROOT,'setup','BITS','testcase');

dbI = tsdb('J:bitsdemo','BITS','');
dbI=tslog(dbI,0);

dbO = tsdb('J:bitstestcase','BITS','');
dbO=tslog(dbO,0);

% Last release loading
ts = tsload(dbI,'BDESPISDH');
assert(floor(nanmean(ts))==98);
tsstore(dbO,ts);
ts = tsload(dbO,'BDESPISDH');
assert(floor(nanmean(ts))==98);

% Specific release loading
ts = tsload(dbI,'BDESPISDH', 733101);
assert(floor(nanmean(ts))==98);
tsstore(dbO,ts);
ts = tsload(dbO,'BDESPISDH', 733101);
assert(floor(nanmean(ts))==98);

% All release loading
r = tsreleases(dbI,'BDESPISDH');
ts = tsload(dbI,'BDESPISDH', r);
assert(floor(mean(nanmean(ts)))==98);
tsstore(dbO,ts);
r = tsreleases(dbO,'BDESPISDH');
ts = tsload(dbO,'BDESPISDH', r);
assert(floor(mean(nanmean(ts)))==98);

% 
% Multiple (All) series loading
s = tsseries(dbI);
[tsM,tsQ] = tsload(dbI,s);
assert(floor(mean(nanmean(tsM)))==7017);
assert(floor(mean(nanmean(tsQ)))==138422);
tsstore(dbO,tsM);
tsstore(dbO,tsQ);
s = tsseries(dbO);
[tsM,tsQ] = tsload(dbO,s);
assert(floor(mean(nanmean(tsM)))==7017);
assert(floor(mean(nanmean(tsQ)))==138422);

 
% Multiple series specific release loading
s = tsseries(dbI);
[tsM,tsQ] = tsload(dbI,s,733101);
assert(floor(mean(nanmean(tsM)))==6887);
assert(floor(mean(nanmean(tsQ)))==138120);
tsstore(dbO,tsM);
tsstore(dbO,tsQ);
s = tsseries(dbO);
[tsM,tsQ] = tsload(dbO,s,733101);
assert(floor(mean(nanmean(tsM)))==6887);
assert(floor(mean(nanmean(tsQ)))==138120);
 
% % Multiple series multiple release
r = tsreleases(dbI,s);
s = tsseries(dbI);
[tsM,tsQ] = tsload(dbI,s,r);
assert(floor(mean(nanmean(tsM)))==6965);
assert(floor(mean(nanmean(tsQ)))==138346);
tsstore(dbO,tsM);
tsstore(dbO,tsQ);
r = tsreleases(dbO,s);
s = tsseries(dbO);
[tsM,tsQ] = tsload(dbO,s,r);
assert(floor(mean(nanmean(tsM)))==6965);
assert(floor(mean(nanmean(tsQ)))==138346);

close(dbI);
close(dbO);
%tsadmin(dbROOT,'drop','bitstestcase');
close(dbROOT);