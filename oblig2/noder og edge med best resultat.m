%{

sumEdgeLng = 	2608 	 obj =  674                 
minDistN = 	  46 	 obj =    3                      
minDistE = 	  36 	 obj =    0                      
minAng = 	  13 	 obj =    0                     
maxTrykkNr = 	  13 	 obj = 2583 	 sVal = 7021400  lng = 115.08           
maxStrekkNr = 	  19 	 obj =   63 	 sVal = -4317294          
Total Obj = 	3323   
Max nedb xyz = 	0.009 0.250 4.071 

%}


N = [0.5197    1.0000   -1.0000
    0.5197   -1.0000   -1.0000
   -0.5197    1.0000   -1.0000
   -0.5197   -1.0000   -1.0000
         0   -5.4111   -1.0848
   -0.0667   -0.1764   -0.3900
   -0.0463   -0.8659   -0.0130
   -0.0290   -3.1149   -2.1905
   -0.0329   -1.1309   -2.2049];


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