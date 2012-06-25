function self = test_tsload(self)
% Bank-IT Time Series Toolbox

db = tsdb('J:bitsdemo','BITS','');

% Last release loading
ts = tsload(db,'BDESPISDH');
assert(floor(nanmean(ts))==98);

% Specific release loading
ts = tsload(db,'BDESPISDH', 733101);
assert(floor(nanmean(ts))==98);

% All release loading
r = tsreleases(db,'BDESPISDH');
assert(length(r{:})==25);
ts = tsload(db,'BDESPISDH', r);
assert(floor(mean(nanmean(ts)))==98);

% Multiple (All) series loading
s = tsseries(db);
[tsM,tsQ] = tsload(db,s);
assert(floor(mean(nanmean(tsM)))==7017);
assert(floor(mean(nanmean(tsQ)))==138422);

% Multiple series specific release loading
s = tsseries(db);
[tsM,tsQ] = tsload(db,s,733101);
assert(floor(mean(nanmean(tsM)))==6887);
assert(floor(mean(nanmean(tsQ)))==138120);

% Multiple series multiple release
r = tsreleases(db,s);
[tsM,tsQ] = tsload(db,s,r);
assert(floor(mean(nanmean(tsM)))==6965);
assert(floor(mean(nanmean(tsQ)))==138346);

close(db);