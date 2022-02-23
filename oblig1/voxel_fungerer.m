cube();

function cube()
% Kan eventuelt lage høyde, lengde, bredde som argumenter etter hvert, men
% dette haster for så vidt ikke. Bør i så fall gjøre argumentene frivillige

% Create file and write the given header to it
fid = fopen('cube.gcode', 'w', 'n','UTF-8');
fwrite(fid, fileread('header.gcode'));

% Box dimensions
boxHeight = 10; % mm
boxBreadth = 15; % mm, defined by number of lines (y-direction)
boxLength = 15; % mm, equals the length of every printed line (x-direction)
% dimension of box is then boxBreadth x boxLength x boxHeigth

% Print dimensions (find optimal values by testing)
layerHeight = 0.3; % mm Defines the size to increment z-axis with https://the3dprinterbee.com/3d-printing-layer-height-vs-nozzle-size/ 
lineWidth = 0.3; % mm. The distance between two lines in the same layer
eRate = 0.033; % extrusion per mm 

% Start coordinates(center of plate is center of cube)
startX = 117.5 - (boxLength/2);
startY = 117.5 - (boxBreadth/2);
startZ = layerHeight;

x = startX;
y = startY;
z = startZ;

% Extrusion Values
eLine = eRate * boxLength; % Amount to extrude per line
eBreadth = eRate * boxBreadth;
eTotal = 0; % Cumulated extruted filament

% Number of lines and layers
nLayers = round(boxHeight/layerHeight); % Number of layers given the set box height and layer height
% nLines = round(boxBreadth/lineWidth);

% Defines direction of single line along x-/y-axis
lineDirection = 1; % Defines if the line is printed from left to right or vice versa


%g0_start = ['G0 F6000 X' num2str(startX) ' Y' num2str(startY) ' Z' num2str(startZ)];
%fprintf(fid, '%s\n', g0_start);

% For every layer
for i = 1:nLayers
    % Change layer direction
    horizontalLayer = mod(i, 2); % 1 gives a horizontal layer
    verticalLayer = 1 - horizontalLayer; % 1 gives a vertical layer
    
    % Reset x and y for every layer
    y = startY;
    x = startX;
   
    % Move nozzle to start y and new z for every new layer
    g0_layer = [';LAYER:' num2str(i) newline ';TYPE:SKIN' newline 'G0 F6000 X' num2str(x) ' Y' num2str(y) ' Z' num2str(z)];
    fprintf(fid, '%s\n', g0_layer);    
  
    % When the number of lines are different for horizontal and vertical
    % layers (ie when the box is not a cube but a prism)
    nLines = round(boxBreadth/lineWidth)*horizontalLayer + round(boxLength/lineWidth)*verticalLayer;
   
    % For every line
    for j = 1:nLines
       
        %{
        G1 command
        When horizonalLayer = 1, the y value does not change (because
        then verticalLayer = 0) and vice versa
        %}
        x = x + (boxLength * lineDirection * horizontalLayer);
        y = y + (boxBreadth * lineDirection * verticalLayer); 
        
       
        %{
        Find correct E value
        Gives the correct extrusion length based on if the line is in a
        horizontal or vertical layer. 
        %}
        eTotal = eTotal + (eLine *horizontalLayer) + (eBreadth * verticalLayer);
        
        % G1 command string
        g1_out = ['G1 F600 X' num2str(x) ' Y' num2str(y) ' E' num2str(eTotal)];
        
        
        %{
        G0 command. x should only increase when the vertical layers are
        printed and vice versa for y (opposite to the G1 command)
        %}
        x = x + lineWidth * verticalLayer;
        y = y + lineWidth * horizontalLayer;
        
        % G0 command string
        g0_out = ['G0 F6000 X' num2str(x) ' Y' num2str(y)];
        
        % Add commands to file
        fprintf(fid, '%s\n', g1_out, g0_out);
        
        
        %{
        Invert print direction along x-axis for the horizontal layers and
        y-axis for the vertical layers
        %}
        lineDirection = lineDirection*-1; 
   
    end
    
    % Increment z to make next layer
    z = z + layerHeight;
    
end % End for layer

% Update footer script with correct E-value
changeFooter(eTotal);

% Add the footer to the current file and close it 
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
lines{5} = regexprep(lines{5}, 'E\d+\.\d+', eStr); % Change current E-value from footer to new E-value

% Open new file
[fid, msg] = fopen('footer.gcode', 'w');

if fid < 1; 
    error('could not write output file because "%s"', msg);
end

fwrite(fid, strjoin(lines, '\n'));

fclose(fid);
end