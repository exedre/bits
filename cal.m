function out = cal(month,year)
%CAL Calendar with ISO week numbers.
%   CAL displays current month
%   CAL(M) displays month M of current year
%   CAL(M,Y) displays month M of year Y
%
%   EXAMPLE
%   cal(1,2000)
%
%   See also ICAL, ISOWEEK, CALENDAR

%   Author: Jonas Lundgren <splinefit@gmail.com> 2012

if nargin < 1, [year,month] = datevec(now); end
if nargin < 2, [year,dummy] = datevec(now); end %#ok

% Month number must be 1-12
q = floor((month-1)/12);
month = month - 12*q;
year = year + q;

% First day of the month
first = datenum(year,month,1);

% List of days
monday = first - mod(first-3,7);
sunday = monday + 41;
days = monday:sunday;

% Dates and week numbers
dvec = datevec(days);
week = isoweek(days(1:7:end));

% Build string
form = '%2.2d%6d%4d%4d%4d%4d%4d%4d \n';
data = [week; reshape(dvec(:,3),7,[])];
a = datestr(first,'               mmm yyyy\n\n');
b = sprintf('W     Mo  Tu  We  Th  Fr  Sa  Su \n');
c = sprintf(form,data);
str = [a,b,c];

% Mark todays date
n = floor(now);
if n >= monday && n <= sunday
    k = find(days == n);
    ii = [55 58] + 4*k + 6*ceil(k/7);
    str(ii) = '[]';
end

% Display
if nargout
    out = str;
else
    disp(str)
end
