function out = isoweek_custom(n,form,varargin)
%ISOWEEK Week number or week date according to ISO 8601.
%   W = ISOWEEK(N) outputs ISO week numbers. The input N is an array
%   of serial date numbers as given by DATENUM.
%
%   V = ISOWEEK(N,'vec') outputs ISO week dates on vector format.
%   V is the array [Y,W,D] where Y is the ISO week-numbering year,
%   W is the week number and D is the weekday number (1 is Monday).
%   
%   S = ISOWEEK(N,'str') outputs ISO week dates on string format.
%
%   S = ISOWEEK(N,'str',scal) outputs week dates according to different day 
%   (1=Sunday, 2=Monday, 3= Tues, 4=Wed., 5=Thu, 6=Fri, 7=Sat)
%   The first week of a year is defined as the first week containing the day in question
%   the last week (52 or 53) is defined as the last containing the day in
%   question
%    METHOD
%   Count Thu. or else. The nth week contains the nth Thursday/else of the year.
% 
%   EXAMPLES
%   isoweek(now:now+6)
%   isoweek(now:now+6,'vec')
%   isoweek(now:now+6,'str')
%   isoweek(datenum(2000,1,1:4),'str')
%
%   See also DATENUM, DATESTR, DATEVEC

%   Author: Jonas Lundgren <splinefit@gmail.com> 2012

if nargin < 1 || isempty(n), n = now; end
if nargin < 2, form = ''; end

% Default behavior: Thursday occurs on the 6th day of Matlab datenum system
%  Friday on the 7th, 
baseday=2;
dayofweek=7;

if nargin==3
    baseday=varargin{1};
    switch(baseday)
        case 'Thu'
            disp('qui')
            baseday=6; % Returns isoweeks
            dayofweek=4;
        case 'Fri'
            baseday=7;
            dayofweek=5;
        case 'Sat'
            baseday=1;
            dayofweek=6;
        case 'Sun'
            baseday=2;
            dayofweek=7;
        case 'Mon'
            baseday=3;
            dayofweek=1;
        case 'Tue'
            baseday=4;
            dayofweek=2;
        case 'Wed'
            baseday=5;
            dayofweek=3;
    end
    
            
end    

% Check input
if ~isfloat(n) || ~isreal(n) || ~all(isfinite(n(:)))
    error('isoweek:datenumber','N must be an array of date numbers.')
end

% Reshape input
s = size(n);
n = n(:);


n = floor(n);
% Returns ordinal weekday number (1=Mon, 2=Tue 3=Wed,4 = Thu, 5=Fri, 6=Sa, 7= Sun )
% Since datenum = 0 corresponds to a friday (day 5 in the week)
d = mod(n-3,7) + 1;


% Thursday of the corresponding week (if dayofweek=4, else see cases up)
n = n - d + dayofweek;

% The ISO week-numbering year is the year of the Thursday
v = datevec(n);
y = v(:,1);

% First Thursday of the year (we know that day 0 in Matlab is a friday)
% Therefore the matlab 6 is a thursday
day1 = datenum(y,1,1);
m = day1 + mod(baseday-day1,7);

% ISO week number
w = (n - m)/7 + 1;

% Output
switch form
    case 'vec'
        % Week date vector
        out = [y,w,d];
    case 'str'
        % Week date string
        y(y < 0) = nan;
        out = sprintf('%4.4d-W%2.2d-%d',[y,w,d]');
        out = reshape(out,10,[])';
    otherwise
        % Week number
        out = reshape(w,s);
end

