function out = isoweek(n,form)
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
%   METHOD
%   Count Thursdays. The nth week contains the nth Thursday of the year.
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

% Check input
if ~isfloat(n) || ~isreal(n) || ~all(isfinite(n(:)))
    error('isoweek:datenumber','N must be an array of date numbers.')
end

% Reshape input
s = size(n);
n = n(:);

% ISO weekday number
n = floor(n);
d = mod(n-3,7) + 1;

% Thursday of the week
n = n - d + 4;

% The ISO week-numbering year is the year of the Thursday
v = datevec(n);
y = v(:,1);

% First Thursday of the year
m = datenum(y,1,1);
m = m + mod(6-m,7);

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

