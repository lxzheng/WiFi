%taylorExpansionDemo: Interactive demo of Taylor expansion of a curve
%
%	Usage:
%		taylorExpansionDemo
%
%	Description:
%		taylorExpansionDemo is an animated demo for the first, second, and third order Taylor expansion of a curve obtained by polynomial fitting.
%
%	Example:
%		taylorExpansionDemo

%	Category: Demos
%	Roger Jang, 19960603

x = linspace(1, 10, 10)';
y = [10 7 5 4 3.5 3.2 2 1 2 4]';
order = 9;
coef = polyfit(x, y, order);
xx = linspace(1, 10)';
yy = polyval(coef, xx);
limit = [min(x) max(x) min(y)-1 max(y)+1];

d_coef = [length(coef)-1:-1:1].*coef(1:length(coef)-1);
dd_coef = [length(d_coef)-1:-1:1].*d_coef(1:length(d_coef)-1);
ddd_coef = [length(dd_coef)-1:-1:1].*dd_coef(1:length(dd_coef)-1);

figure('name', 'Polynomial Fitting and Taylor Expansion', 'NumberTitle', 'off');
%colordef(gcf, 'black');
h = plot(x, y, 'o', xx, yy, '-');
set(h(1), 'erase', 'xor', 'linewidth', 3, 'markersize', 10);
set(h(2), 'erase', 'xor', 'linewidth', 3);
fitH = h(1);
curveH = h(2);
axis(limit);
title('Click and drag circles to change the curve.');
xlabel('Click and drag to see first, second, and third order approximation'); 

verticalH = line([nan nan], [min(y)-1 max(y)+1], 'erase', 'xor', 'color', 'k');
circleH = line(nan, nan, 'erase', 'xor', 'color', 'k', 'marker', 'o', 'linewidth', 3, 'markersize', 10);
firstH  = line(xx, nan*xx, 'erase', 'xor', 'color', 'g', 'linewidth', 3, 'linestyle', ':');
secondH = line(xx, nan*xx, 'erase', 'xor', 'color', 'c', 'linewidth', 3, 'linestyle', '-.');
thirdH  = line(xx, nan*xx, 'erase', 'xor', 'color', 'r', 'linewidth', 3, 'linestyle', '--');
AxisH = gca; FigH = gcf;
curr_info = get(AxisH, 'CurrentPoint');
current_x = curr_info(1,1);

% The following is for animation
% action1a, action2a, and action3a are for polynomial fitting
% action1b, action2b, and action3b are for Taylor expansion 

% action when button is first pushed down
action1a = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'start_x=curr_info(1,1);', ...
	'start_y=curr_info(1,2);', ...
	'prev_y = start_y;', ...
	'[junk, index] = min(abs(start_x-x));'];
action1b = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'curr_x=curr_info(1,1);', ...
	'first=polyval(d_coef,curr_x)*(xx-curr_x)+polyval(coef,curr_x);', ...
	'second=0.5*polyval(dd_coef, curr_x)*(xx-curr_x).^2+first;', ...
	'third=1/6*polyval(ddd_coef, curr_x)*(xx-curr_x).^3+second;', ...
	'set(circleH, ''xdata'', curr_x, ''ydata'',polyval(coef, curr_x));', ...
	'set(verticalH, ''xdata'', [curr_x curr_x]);', ...
	'set(firstH, ''ydata'', first);', ...
	'set(secondH, ''ydata'', second);', ...
	'set(thirdH, ''ydata'', third);'];
action1 = ['if gco==curveH,' action1a, 'else ', action1b, 'end'];
% actions after the mouse is pushed down
action2a = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'curr_x=curr_info(1,1);', ...
	'curr_y=curr_info(1,2);', ...
	'y(index) = y(index)+curr_y-prev_y;', ...
	'prev_y = curr_y;', ...
	'set(fitH, ''ydata'', y);', ...
	'coef = polyfit(x, y, order);', ...
	'yy = polyval(coef, xx);', ...
	'set(curveH, ''ydata'', yy);', ...
	'd_coef = [length(coef)-1:-1:1].*coef(1:length(coef)-1);', ...
	'dd_coef = [length(d_coef)-1:-1:1].*d_coef(1:length(d_coef)-1);', ...
	'ddd_coef = [length(dd_coef)-1:-1:1].*dd_coef(1:length(dd_coef)-1);'];
action2b = action1b;
action2 = ['if gco==curveH,' action2a, 'else ', action2b, 'end'];
% action when button is released
action3a = [];
action3b = ['set(fitH, ''visible'', ''on'');', ...
	'set(circleH, ''xdata'', nan, ''ydata'', nan);', ...
	'set(verticalH, ''xdata'', [nan nan]);', ...
	'set(firstH, ''ydata'', nan*xx);', ...
	'set(secondH, ''ydata'', nan*xx);', ...
	'set(thirdH, ''ydata'', nan*xx);'];
action3 = ['if gco==curveH,' action3a, 'else ', action3b, 'end'];

% temporary storage for the recall in the down_action
set(AxisH,'UserData',action2);

% set action when the mouse is pushed down
down_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'',get(AxisH,''UserData''));' ...
    action1];
set(FigH,'WindowButtonDownFcn',down_action);

% set action when the mouse is released
up_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'','' '');', action3];
set(FigH,'WindowButtonUpFcn',up_action);