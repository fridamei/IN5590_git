function z = tutorialFunToBeOptimized(xIn, varargin)
    % Objective function to be minimized, used in examples
    % Must have all parameteres to be optimized specified
    % as the vector xIn

    global internalSearchValues;

    if isempty(varargin) % Beregner bare, plotter ikke

        x = xIn(1);
        y = xIn(2);

        % Matlab peak logo function
        z =  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ...
        - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ...
        - 1/3*exp(-(x+1).^2 - y.^2);

        z = z/3;

        internalSearchValues = [internalSearchValues ; xIn z];

    else % Beregner ikke fra xIn, plotter for alle mulige xy-verdier -4:4

        [x, y] = meshgrid(linspace(-4, 4, 300));

        z =  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ...
        - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ...
        - 1/3*exp(-(x+1).^2 - y.^2);
        z = z/3;

        [F, V, ~] = surf2patch(z);

        V = [4 4 1].*(V - mean(V).*[1 1 0])./[150 150 1];
        fig1; plotPoly(F, V, 'dark', 'edgeOff', 'alphaVal', 0.7);

        % Legger på firkant som viser lovlig søkeområde
        N = [-3 -1 0 ; 3 -1 0 ; 3 2.5 0 ; -3 2.5 0];
        E = [1 2 ; 2 3 ; 3 4 ; 4 1];
        plotMesh(E, N, 'dark'); view(-57, 16); sun4;

        minXY1 = [0.2283 -1.6255];
        minXY2 = [-1.3474 0.2045];
        minXY3 = [0.2964 0.3202];
        N = [minXY1(1) minXY1(2) (1/3)*peaks(minXY1(1), minXY1(2)) ; minXY1(1) minXY1(2) (1/3)*peaks(minXY1(1), minXY1(2)) + 3
        minXY2(1) minXY2(2) (1/3)*peaks(minXY2(1), minXY2(2)) ; minXY2(1) minXY2(2) (1/3)*peaks(minXY2(1), minXY2(2)) + 3
        minXY3(1) minXY3(2) (1/3)*peaks(minXY3(1), minXY3(2)) ; minXY3(1) minXY3(2) (1/3)*peaks(minXY3(1), minXY3(2)) + 3];
        E = [1 2 ; 3 4 ; 5 6];
        plotMesh(E, N, 'dark', 'col', [1 0.2 .2]); view(-57, 16); sun4;
        % text(N(2, 1), N(2, 2), N(2, 3),  ['(' num2str(N(1, 1)) ', '  num2str(N(1, 2)) ', ' num2str(N(1, 3)) ')']);
        % text(N(4, 1), N(4, 2), N(4, 3),  ['(' num2str(N(3, 1)) ', '  num2str(N(3, 2)) ', ' num2str(N(3, 3)) ')']);
        % text(N(6, 1), N(6, 2), N(6, 3),  ['(' num2str(N(5, 1)) ', '  num2str(N(5, 2)) ', ' num2str(N(5, 3)) ')']);

    end
end

