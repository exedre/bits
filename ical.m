function ical
%ICAL Calendar browser with ISO week numbers.
%   Browse calendar with Arrow keys. Any other key quits.
%
%   See also CAL, ISOWEEK, CALENDAR

%   Author: Jonas Lundgren <splinefit@gmail.com> 2012

% Hidden figure with callbacks
fh = figure('Name','ical');
set(fh,'NumberTitle','off')
set(fh,'WindowStyle','modal')
set(fh,'Position',[0 0 1 1])
set(fh,'KeyPressFcn',@keypress)
set(fh,'WindowScrollWheelFcn',@scrollwheel)
set(fh,'DeleteFcn',@removehelp)

% Help text
helptext = [10,'         <<   arrow keys   '];
nh = numel(helptext);
nb = 0;

% Calendar of current month
[year,month] = datevec(now);
printcal(0)


% Nested functions
%--------------------------------------------------------------------------
    function keypress(varargin)
        % Key press callback
        switch varargin{2}.Key
            case 'uparrow', printcal(-1)
            case 'downarrow', printcal(1)
            case 'leftarrow', printcal(-1)
            case 'rightarrow', printcal(1)
            otherwise, delete(fh)
        end
    end

    function scrollwheel(varargin)
        % Scroll wheel callback
        step = varargin{2}.VerticalScrollCount;
        printcal(step)
    end

    function removehelp(varargin)
        % Remove help text at exit
        backspace = zeros(1,nh-1) + 8;
        fprintf(char(backspace))
    end

    function printcal(step)
        % Print calendar and help text
        month = month + step;
        backspace = zeros(1,nb) + 8;
        str = cal(month,year);
        fprintf([backspace,10,str,helptext])
        nb = 1 + numel(str) + nh;
    end

end
