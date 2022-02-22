cube();

function cube()
% Kan eventuelt lage høyde, lengde, bredde som argumenter etter hvert, men
% dette haster for så vidt ikke. Bør i så fall gjøre argumentene frivillige


fid = fopen('cube.gcode', 'w', 'n','UTF-8');
fwrite(fid, fileread('header.gcode'));

startPoint = "G0 F6000 X107.5 Y107.5 Z0.2";

% Box dimensions
boxHeight = 10; % mm
boxBreadth = 20; % mm, defined by number of lines
boxLength = 20; % mm, equals the length of every printed line
% dimension of box is then boxBreadth x boxLength x boxHeigth

% Print dimensions (find optimal values by testing)
layerHeight = 0.3; % mm Defines the size to increment z-axis with https://the3dprinterbee.com/3d-printing-layer-height-vs-nozzle-size/ 
lineWidth = 0.2; % mm. The distance between two lines in the same layer
eRate = 0.033; % extrusion per mm 


% Start coordinates
startX = 107.5;
startY = 107.5;
startZ = layerHeight;

x = startX;
y = startY;
z = startZ;


% Extrusion Values
eLine = eRate*boxLength; % Amount to extrude per line
eTotal = 0; % Cumulated extruted filament

% Number of lines and layers
nLayers = round(boxHeight/layerHeight); % Number of layers given the set box height and layer height
nLines = round(boxBreadth/lineWidth); % The 

% Defines direction on x-axis 
toRight = 1; % Defines if the line is printed from left to right or vice versa

g0_start = ['G0 F6000 X' num2str(startX) ' Y' num2str(startY) ' Z' num2str(startZ)];

fprintf(fid, '%s\n', g0_start);

% For every layer
for i = 1:nLayers
    
    %tkst = [';LAYER:' num2str(i) '\n;TYPE:SKIN']
    %g0_layer = ['G0 F6000 Z' num2str(z)];
    
    y = startY;
    
    g0_layer = [';LAYER:' num2str(i) newline ';TYPE:SKIN' newline 'G0 F6000 Y' num2str(y) ' Z' num2str(z)];
    fprintf(fid, '%s\n', g0_layer);    
    
    %toRight = 1; Hvis x-verdien skal resettes, må denne det også
    %x = startX;
    %y = startY;
    
 
   % For every line
    for j = 1:nLines
        
        % G1-kommando (ekstruderer bare når dysen beveger seg i x-retning):
        x = x + boxLength * toRight;
        
        eTotal = eTotal + eLine;
        
        g1_out = ['G1 F600 X' num2str(x) ' E' num2str(eTotal)];
        
        % G0-kommando:
        y = y + lineWidth;
        
        g0_out = ['G0 F6000 Y' num2str(y)];
        
        
        fprintf(fid, '%s\n', g1_out, g0_out);
        
        toRight = toRight*-1; % Invert direction of x-axis movement
    
    end
    
 
    % Increment z to make next layer
    z = z + layerHeight;
end

changeFooter(eTotal);
fwrite(fid, fileread('footer.gcode'));

fclose(fid);
end

function changeFooter(last_e)
%{
Change the footer file to include correct pull back length of filament
%}

pullBackLength = 5; % in mm, the given template uses 5
e = last_e - pullBackLength;

if e < 0
    e = 0;
end

eStr = ['E' num2str(e)];

% https://se.mathworks.com/matlabcentral/answers/62986-how-to-change-a-specific-line-in-a-text-file

% Regex to change the original value to new value. 
lines = readlines('footer.gcode');
lines{5} = regexprep(lines{5}, 'E\d+\.\d+', eStr); % Change 'E40.67428' from original footer to new E-value

% Open new file
[fid, msg] = fopen('footer.gcode', 'w');

if fid < 1; 
    error('could not write output file because "%s"', msg);
end

fwrite(fid, strjoin(lines, '\n'));

fclose(fid);
end