% Funksjon som optimaliseres for. Inneholder alle nodene og edgene, samt
% finner straffeverdiene som gis gitt nodene i meshen

function objTot = objFunction(paramVector, varargin)

    global OBJoverRuns; % For å ta vare på obj-verdier under søk (de midlertidige verdiene man finner sånn at man kan plotte dem og se utviklingen mot siste runde)

    plotNed = 0;
    plotStress = 0;
    printObj = 0;
    readVgrarginInput(); % se nederst

    % Mesh-strukturen under kan stå som den er hvis man ikke vil vinne konkurransen,
    % men man må klare å optimalisere xyz-posisjoner på >3 av nodene nr.6-9

    % Nodemesh der kolonnene er koordinatene til hver av nodene
    N = [0.5197    1.0000   -1.0000 % Låst node, kan ikke velge andre verdier her
        0.5197    -1.0000   -1.0000 % Låst node, kan ikke velge andre verdier her
        -0.5197    1.0000   -1.0000 % Låst node, kan ikke velge andre verdier her
        -0.5197   -1.0000   -1.0000 % Låst node, kan ikke velge andre verdier her

        0         -5.4111   -1.0848 % Kan ikke velge andre verdier her, her skal kraft på

        0   -1.3000    1.5000       % Disse kan optimaliseres, evt fjernes eller erstattes
        0   -2.8527    1.0000       % Disse kan optimaliseres, evt fjernes eller erstattes
        0   -2.8562    -2.3279       % Disse kan optimaliseres, evt fjernes eller erstattes
        0   -1.3000   -2.8279]*58;  % Disse kan optimaliseres, evt fjernes eller erstattes

    E = [3 4 % Låst edge, kan ikke fjernes
        4 2  % Låst edge, kan ikke fjernes
        1 3  % Låst edge, kan ikke fjernes
        2 1  % Låst edge, kan ikke fjernes

        % Følgende kan evt fjernes eller erstattes, men man må ha flere edger til node 5
        % Fjerner man for mange kan man få problem med singularitet, tenk på hver node som et
        % kuleledd (http://www.robotikk.com/in5590-2021/lec/0.php?s=15&l=4&i=0&p=0)
        % Man kan sette inn nye edger, men ikke doble (2 mellom samme node)
        7 4
        2 7
        3 9
        6 2
        4 6
        5 4
        2 5
        6 7
        9 8
        9 4
        1 9
        1 6
        2 9
        6 3
        7 5
        8 5
        8 2
        8 4];
    
    

    % Her må dere legge inn verdiene fra paramVector, inn i N

    % For å indekse: N(1, 2) gir y-verdien til node 1
    
    % Kjører like mange ganger som det er noder som skal endres
    % i korresponderer til indeksen til z-verdiene i paramVector (3, 6, 9
    % osv). Inkrementerer derfor med 3 for hver løkkekjøring. 
   
    for i = 3 :3 :length(paramVector)
        node = i/3 + 5; % starter på sjette node, og inkrementerer med 1 for hver løkke
        N(node, 1:3) = paramVector(i-2:i); % Setter inn verdiene fra paramVector på korresponderende plass i nodemesh N
    end

   

    % Ting som skal straffe seg, og tilhørende parametre
    maxTotEdgeLengde = 2400; % mm
    minNodeDistanse = 50; % mm
    minEdgeDistanse = 10; % mm
    minVinkelEdges = 15; % grader
    strekkStressGrense = 4e6; % Pascal

    % STRAFF: Max total edge lengde straffes ved >maxTotEdgeLengde (pris/miljø)
    sumE = sumEdgeLng(E, N);
    obj1 = pen1(sumE, 0, maxTotEdgeLengde, 900);

    % STRAFF: Avstand mellom noder straffes ved lengder <minNodeDistanse (plundrete å montere)
    [distN, ~, ~] = minNodeDist(N);
    obj2 = pen1(distN, minNodeDistanse, 300, 100);

    % STRAFF: Avstand mellom edger som ikke deler samme node straffes ved lengder <minEdgeDistanse (kollisjon)
    [distE, ~, ~] = minDistBetweenEdges(E, N);
    obj3 = pen1(distE, minEdgeDistanse, 300, 100);

    % STRAFF: Vinkel mellom edger som deler samme node straffes ved <minVinkelEdges grader (vanskelig å montere)
    [angMin, ~, ~, ~] = minAngleConnectedEdges(E, N);
    obj4 = pen1(angMin, minVinkelEdges, 300, 100);


    % FEM
    % Tykkelse på edger
    radius = 0.0015;        % Meter
    E(:, 3) = pi*radius^2;  % Arealer

    % Boundary conditions
    Nlock = zeros(size(N));
    Nforce = zeros(size(N));
    %{
    for ni = 1 : size(N, 1)
        % Her må dere fylle i rette verdier Nlock/Nforce
        % (http://genlib.no/kodeOgHtml/html/fem/TUT_trussFEMsimIntro.php)
        
        if ni == 5
            Nforce(ni, 3) = 20; % 20 N i z-retning på node 5
        elseif ni >= 5
            Nlock(ni, 1:3) = 1 % Lar nodene 5 - 9(?) være bevegelige i alle retninger
        
        end
            
    end 
    %}

    % alternativ til for loop: 
    
    Nforce(5, 3) = 20;
    Nlock(5:end, 1:3) = 1;
    
    % Simulerer Estress
    [Estress, Ndispl] = FEM_truss(E, N, Nlock, Nforce);

    % STRAFF: Trykkstress, obj gitt av k*lengde^2 * max positivt stress
    lengdeAlleEkvadrert = (edgeLength(E, N)./6000).^2;
    [obj5, iP] = max(lengdeAlleEkvadrert .* Estress);

    % STRAFF: Strekkstress i edger straffes ved >strekkStressGrense (lim kan ryke)
    % Kun den mest belastede edgen regnes med
    [EstressNegMax, iN] = min(Estress);
    obj6 = pen1(-EstressNegMax, 10, strekkStressGrense, 100); % 100

    objTot = obj1 + obj2 + obj3 + obj4 + obj5 + obj6;

    OBJoverRuns = [OBJoverRuns ; [objTot, obj1, obj2, obj3, obj4, obj5, obj6]]; % Adderer på ny rad

    % Plotting

    if plotNed == 1
        fig3; plotMesh(E, N, 'dark', 'lThick', 2, 'col', [1 0 0], 'txt');
        view(90,0);orto; % Opprinnelig mesh i blå farge, tynne linjer
        visuellScale = 10; % Vi vil visuelt skalere opp forflytningene for de er små
        hold on;
        plotMesh(E, N - visuellScale*Ndispl, 'dark', 'col', [0 0 1], 'lThick', 2);
        view(90,0);orto;set(gca,'YLim',[-300 60]);
    end

    if plotStress == 1
        rgb = rgbFromEs(Estress, 'dark');
        fig4; plotMeshColor(N, E, 'eCol', rgb, 'lTykk', 4, 'txt'); view(60, 10);
    end

    if printObj == 1
       fprintf('------------------------------------------------------------------- \n');
       fprintf('sumEdgeLng = \t%4.0f \t obj = %4.0f                 \n', sumE, obj1);
       fprintf('minDistN = \t%4.0f \t obj = %4.0f                      \n', distN, obj2);
       fprintf('minDistE = \t%4.0f \t obj = %4.0f                      \n', distE, obj3);
       fprintf('minAng = \t%4.0f \t obj = %4.0f                     \n', angMin, obj4);

       fprintf('maxTrykkNr = \t%4.0f \t obj = %4.0f \t sVal = %4.0f  lng = %4.2f           \n', iP, obj5, Estress(iP), norm(N(E(iP,1),:)-N(E(iP,2),:))  );
       fprintf('maxStrekkNr = \t%4.0f \t obj = %4.0f \t sVal = %7.0f          \n', iN, obj6, EstressNegMax);
       fprintf('Total Obj = \t%4.0f   \n', objTot);
       md = max(Ndispl);
       fprintf('Max nedb xyz = \t%4.3f %4.3f %4.3f  \n', md(1), md(2), md(3) ) ;
       fprintf('------------------------------------------------------------------- \n');
    

    save('test.mat','N','E')
    N/58
    E
    end

    function readVgrarginInput()
        while ~isempty(varargin)
            switch varargin{1}
                case 'plotNed'
                    plotNed = 1; varargin(1:1) = [];
                case 'plotStress'
                    plotStress = 1; varargin(1:1) = [];
                case 'printObj'
                    printObj = 1; varargin(1:1) = [];
                otherwise
                    error(['Unexpected option: ' varargin{1}]);
            end
        end
    end

end
