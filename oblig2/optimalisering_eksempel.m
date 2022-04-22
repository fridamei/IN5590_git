function [ ] = TUT_optim( )

% Optimalisering av funksjon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%% PATTERN SEARCH

clear all;
global internalSearchValues;

fun = @tutorialFunToBeOptimized;

x0 = [0 0];
lb = [-4, -4];
ub = [4, 4];
z = patternsearch(fun, x0, [], [], [], [], lb, ub);

z = tutorialFunToBeOptimized(0, 'plot');
plotPointCloud(internalSearchValues(1:200,:), 15, 'dark', 'fill', 'col', [0 0 1]);

% Plotter forløp
fig2; 
plott(1:200, internalSearchValues(1:200,3), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:200, cummin(internalSearchValues(1:200,3)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'Patternsearch');

%%%%%%%%%%%%%%% GA

clear all;
global internalSearchValues;

fun = @tutorialFunToBeOptimized;

lb = [-4, -4];
ub = [4, 4];
z  = ga(fun, 2,  [], [], [], [], lb, ub);

z = tutorialFunToBeOptimized(0, 'plot');
plotPointCloud(internalSearchValues(1:200,:), 15, 'dark', 'fill', 'col', [0 0 1]);


% Plotter forløp
fig2; plott(1:200, internalSearchValues(1:200,3), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:200, cummin(internalSearchValues(1:200,3)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'GA');

%%%%%%%%%%%%%% PARTICLE SWARM

clear all;
global internalSearchValues;

fun = @tutorialFunToBeOptimized;

lb = [-4, -4];
ub = [4, 4];
z  = particleswarm(fun, 2, lb, ub);

z = tutorialFunToBeOptimized(0, 'plot');
plotPointCloud(internalSearchValues(1:200,:), 15, 'dark', 'fill', 'col', [0 0 1]);

% Plotter forløp
fig2; plott(1:200, internalSearchValues(1:200,3), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:200, cummin(internalSearchValues(1:200,3)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'Particle Swarm');

%%%%%%%%%%%%%% SIM ANNEALING

clear all;
global internalSearchValues;

fun = @tutorialFunToBeOptimized;

x0 = [0 0];
lb = [-4, -4];
ub = [4, 4];
z  = simulannealbnd(fun, x0, lb, ub);

z = tutorialFunToBeOptimized(0, 'plot');
plotPointCloud(internalSearchValues(1:200,:), 15, 'dark', 'fill', 'col', [0 0 1]);


% Plotter forløp
fig2; plott(1:200, internalSearchValues(1:200,3), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:200, cummin(internalSearchValues(1:200,3)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'Simulated Annealing Random Restart');

%%%%%%%%%%%%%% SURROGATE OPTIM

clear all;
global internalSearchValues;

fun = @tutorialFunToBeOptimized;
options = optimoptions('surrogateopt','Display','off','PlotFcn',[],'MaxFunctionEvaluations',200);

lb = [-4, -4];
ub = [4, 4];

z  = surrogateopt(fun, lb, ub, options);

z = tutorialFunToBeOptimized(0, 'plot');
plotPointCloud(internalSearchValues(1:200,:), 15, 'dark', 'fill', 'col', [0 0 1]);

% Plotter forløp
fig2; plott(1:200, internalSearchValues(1:200,3), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:200, cummin(internalSearchValues(1:200,3)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'Surrogate Search');

%%%%%%%%%%%%%% SURROGATE OPTIM - limited range

clear all;
global internalSearchValues;

fun = @tutorialFunToBeOptimized;
options = optimoptions('surrogateopt','Display','off','PlotFcn',[],'MaxFunctionEvaluations',200);

lb = [-3 -1];
ub = [3 2.5];

z  = surrogateopt(fun, lb, ub, options);

z = tutorialFunToBeOptimized(0, 'plot');
plotPointCloud(internalSearchValues(1:200,:), 15, 'dark', 'fill', 'col', [0 0 1]);

% Plotter forløp
fig2; plott(1:200, internalSearchValues(1:200,3), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:200, cummin(internalSearchValues(1:200,3)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'Surrogate Search - bound');

end
