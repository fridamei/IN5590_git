function [ ] = TUT_in55900_prosjekt2( )
%{
Hva skal gjøres:
    Patternsearch tar inn en funksjon og en startvariabel (og eventuelle
    andre parametere, men drit i de nå)
    
    startvariablene settes inn i funksjon og verdien som funksjonen
    returnerer er det som optimaliseres for! Det som returneres i
    funksjonen vi skal bruke er total straff tror jeg. Dersom man ikke
    sender inn varargin, returnerer den en skalar og det er denne versjonen
    som brukes i selve optimaliseringen (husk at patternsearch ikke bryr
    seg om hva som skjer inne i funksjonen, bare at den returnerer en
    skalar som kan optimaliseres for (finne laveste/høyeste verdi gitt
    inputene som endres under optimaliseringen), og det er derfor man kan
    ha varargin i funksjonen også. Husk dessuten at funksjonene defineres
    med outputvariabelen i første linje, så optimaliseringsalgoritmen vet
    hvilken variabel den skal bruke)

    Man trenger ikke endre kantene da disse jo er gjeldende uansett hvor
    nodene står (de beskriver bare at det går en kant fra  en node til en
    annen, lengden og egenskapene bestemmes jo da av koordinatene til
    nodene)

    
    Optimaliseringen skjer i optimoptions-linjen

%}
% IN5590 prosjekt nr.2 - mal og parametre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
global OBJoverRuns; % Denne kan brukes hvis dere vil ta vare på alle temporære obj-verdier (for debuggign, trenger den ikke)
                    % [objTot obj1 obj2 obj3 obj4 obj6 ; ......] for å kunne plotte utvikningen under søk
OBJoverRuns = [];   % Her optimaliserer vi ikke, bare for å se hvordan starten ser ut

% Plotter og beregner først uten optimalisering

% Funksjonen objFunction() er nesten ferdig, dere må fylle inn noe




% Setter inn orginale mesh xyz-verdier for node nr 6 og 7 (hentet fra objFunction, altså bare kopiert direkte fra fila),
% beregner objVerdi og plotter mesh med nedbøyning (nedbøyning er ikke noe vi optimaliserer
% for, men ok å se for å sjekke at alt fungerer)
% Format på xyz-verdier er: [node6x node6y node6z   node7x node7y node7z]

%objTot = objFunction([0 -1.3000 1.5000  0 -2.8527 1.0000]*58, 'plotNed');

% Gjør det samme, men plotter nå alle del objVerdier, samt info om straffeverdier
%objTot = objFunction([0 -1.3000 1.5000  0 -2.8527 1.0000]*58, 'printObj');

% Gjør det samme men plotter mesh med fargekodet edgestress
%objTot = objFunction([0 -1.3000 1.5000  0 -2.8527 1.0000]*58, 'plotStress');

% Dere må gjøre det samme som vi har gjort over, men med 3 eller flere noder

% INNSATT MED TRE NODER 6X 6Y 6Z 7 ... 8XYZ 9XYZ 
x6 = 0;
y6 = -0.40; %-1.3000; -55
z6 =  0.12; %1.5000; 35

x7 = 0;
y7 = -1.9;%-2.8527;
z7 = 0.8; %1.20000;

x8 = 0; 
y8 = -3.5;
z8 = -2.5;%-2.3279;

x9= 0;
y9 = -1.1;%-1.3000;
z9 = -2.5; %-2.8279;

objTot = objFunction([x6 y6 z6  x7 y7 z7 x8 y8 z8 x9 y9 z9]*58, 'plotNed');

objTot = objFunction([x6 y6 z6  x7 y7 z7 x8 y8 z8 x9 y9 z9]*58, 'printObj');

objTot = objFunction([x6 y6 z6  x7 y7 z7 x8 y8 z8 x9 y9 z9]*58, 'plotStress');




% Optimaliserer mesh

fun = @objFunction;  % Håndtak for å kunne bruke funksjoenen i surrogateopt søk

% Et eksempel der kun 2 noder (node nr.6 og 7) optimaliseres i xyz-retn
% Velger å avgrense søket til en boks som omslutter orginal nodeposissjon med +/-20 i alle retninger
% Disse grensene kan utvides

%lowerBound = [0 -1.3000 1.5000  0 -2.8527 1.0000]*58 - 20;
%upperBound = [0 -1.3000 1.5000  0 -2.8527 1.0000]*58 + 20;

lowerBound = [x6 y6 z6  x7 y7 z7 x8 y8 z8 x9 y9 z9]*58 - 20;
upperBound = [x6 y6 z6  x7 y7 z7 x8 y8 z8 x9 y9 z9]*58 + 20;


% Velger her optimaliseringsfunksjonen "surrogateopt"
% bestParamFound vil nå inneholde parametre som gir det cumulativt minste objTot resultatet

%options = optimoptions('surrogateopt','Display','off','PlotFcn',[],'MaxFunctionEvaluations',100);
options = optimoptions('surrogateopt','Display','off','PlotFcn',[],'MaxFunctionEvaluations',7000);
bestParamFound  = surrogateopt(fun, lowerBound, upperBound, options);

% Plotter nedbøyning og resultater for beste node nr.6 og 7 koordinater som ble funnet
objTot = objFunction(bestParamFound, 'plotNed');

objTot = objFunction(bestParamFound, 'printObj');


% Plotter hele søkeforløpet for objTot

fig2; plott(1:length(OBJoverRuns(:,1)), OBJoverRuns(:,1), 'fSize', 14, 'xOff', 'lWidth', 1);
plott(1:length(OBJoverRuns(:,1)), cummin(OBJoverRuns(:,1)), 'hold', 'lCol', [1 0 0], ...
     'lWidth', 2, 'fSize', 14, 'title', 'surrogateopt');set(gca,'YLim',[10000 16000]);

 

% Plotter hele søkeforløpet for enkelt komponenter: obj1 - obj6
% fig3; plott(1:length(OBJoverRuns(:,2)), OBJoverRuns(:,2), 'fSize', 14, 'xOff', 'lWidth', 1);
% fig3; plott(1:length(OBJoverRuns(:,3)), OBJoverRuns(:,3), 'fSize', 14, 'xOff', 'lWidth', 1);
% fig3; plott(1:length(OBJoverRuns(:,4)), OBJoverRuns(:,4), 'fSize', 14, 'xOff', 'lWidth', 1);
% fig3; plott(1:length(OBJoverRuns(:,5)), OBJoverRuns(:,5), 'fSize', 14, 'xOff', 'lWidth', 1);
fig5; plott(1:length(OBJoverRuns(:,6)), OBJoverRuns(:,6), 'fSize', 14, 'xOff', 'lWidth', 1);
% fig3; plott(1:length(OBJoverRuns(:,7)), OBJoverRuns(:,7), 'fSize', 14, 'xOff', 'lWidth', 1);




end
