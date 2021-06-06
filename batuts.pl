% ESTABLIMENTS
establiment( % -> Promig 2.66666
    best_batuts, [alan,john,mary],
    [
        batut(berry,    [orange, blueberry, strawberry], 2),
        batut(tropical, [orange, banana, mango, guava], 3),
        batut(blue,     [banana, blueberry], 3) 
    ]
).

establiment( % -> Promig 2.5
    all_batuts, [keith,mary],
    [ 
        batut(pinacolada,   [orange, pineapple, coconut], 2),
        batut(green,        [orange, banana, kiwi], 5),
        batut(purple,       [orange, blueberry, strawberry], 2),
        batut(smooth,       [orange, banana, mango], 1) 
    ]
).

establiment( % -> Promig 2.2
    batuts_galore, [heath,john,michelle],
    [ 
        batut(combo1, [strawberry, orange, banana], 2),
        batut(combo2, [banana, orange], 5),
        batut(combo3, [orange, peach, banana], 2),
        batut(combo4, [guava, mango, papaya, orange], 1),
        batut(combo5, [grapefruit, banana, pear], 1) 
    ]
).

establiment( % -> Promig 3.0
    roses_batuts, [marc,roger,carmen],
    [ 
        batut(fresc1, [peach, lemon, milk], 2.5),
        batut(fresc2, [cherry, orange], 3),
        batut(fresc3, [apple, strawberry, orange, milk], 4),
        batut(fresc4, [chocolate, banana, milk], 2),
        batut(fresc5, [watermelon, pear, yogurt, peach], 3.5) 
    ]
).

establiment( % -> Promig 1.94
    batuts_barats, [pep,laia,rosana],
    [ 
        batut(fresc1, [peach, lemon, milk], 2),
        batut(fresc2, [cherry], 1),
        batut(fresc3, [strawberry, orange, milk], 1.2),
        batut(fresc4, [chocolate, milk, strawberry], 1.5),
        batut(fresc5, [watermelon, pear, yogurt, peach], 4) 
    ]
).

establiment( % -> Promig 3.54
    weird_batuts, [josep,alex,sergi,cristina],
    [ 
        batut(weird1, [peach, lemon, milk, cherry], 3),
        batut(weird2, [cherry, watermelon, chocolate, yogurt], 2.7),
        batut(weird3, [strawberry, orange, milk, peach], 2.5),
        batut(weird4, [chocolate, milk, strawberry, apple], 3.6),
        batut(weird5, [watermelon, pear, yogurt, peach, lemon, milk], 6.2),
        batut(weird6, [orange, pear, peach, lemon, yogurt], 3.6),
        batut(weird7, [cherry, orange, milk, strawberry, lemon], 3.2)
    ]
).


% mesDe(+N, E). Es satisfà si l’establiment E te més de N batuts
mesDe(N,E):- establiment(E,_,L), length(L,Len), Len > N.


% elFa(B, E). Es satisfà si l’establiment E fa el batut B
elFa(B,E):- establiment(E,_,L), member(batut(B,_,_),L).


% ratio(E, R). Es satisfà si l’establiment E te un ratio d’empleats per batuts d’R
ratio(E,R):- establiment(E, Empleats, Batuts), length(Empleats, LEmp), length(Batuts, LBat), R is LEmp/LBat.


% suma(LL, M). Es satisfà quan M és la suma dels preus de la llista de batuts LL.
suma([],0).
suma([batut(_,_,P)|LS], M):- suma(LS, Z), M is Z + P.

% promig(E, P). Es satisfà si el promig del preu dels batuts a l’establiment E és P
promig(E,P):- establiment(E,_,L), length(L,Len), suma(L,M), Z is M/Len, Z = P.


% mesBarat(E). Es satisfà si l’establiment E te els batuts més barats en promig
mesBarat(E):- establiment(E, _, _), promig(E, Pe), establiment(X, _, _), X \= E, promig(X, Px), Pe > Px, !, fail. % A la mínima que n'hi hagi un de mes barat fallar
mesBarat(E):- establiment(E, _, _). % Si provant tots els altres establiment no s'ha complert l'anterior, aquesta retornarà true, NO ES POT CANVIAR D'ORDRE


% notInList(LX, D). Es satisfà quan algun dels elements de la llista LX està a la llista D
notInList([],_).
notInList([L|LX],D):- notInList(LX,D), not(member(L,D)). 

% inList(LX, D). Es satisfà quan tots els elemnts de la llista LX estan a la llista D
inList([],_).
inList([L|LX],D):- inList(LX,D), member(L,D).

% fillList(E, Lb, D, I, L). Es satisfà quan L és una llista formada per parelles (E, NomBatut) que contenen
% els ingredients de la llista D i cap de la llista I. Lb és la llista de batuts de l'establiment E.
% Fa un recorregut de tots els batuts de l'establiment i comprovant si el batut compleix els requisits D i I.
fillList(_,[],_,_,[]).
fillList(E,[batut(M,List,_)|Lb],D,I,[E,M|L]):- fillList(E,Lb,D,I,L), notInList(List,I), inList(D,List), !.
fillList(E,[batut(_,_,_)|Lb],D,I,L):- fillList(E,Lb,D,I,L).

% recurse(Establiments,L,D,I). Es satisfà quan L és una llista formada per llistes de parells (Establiment, NomBatut)
% de la llista d'establiments Establiments que contenen els ingredients que es demanan a la llista D
% i cap dels que es demanen a la llista I
recurse([],[],_,_).
recurse([X|Establiments],[Z|L],D,I):- recurse(Establiments,L,D,I), establiment(X,_,Lb), fillList(X,Lb,D,I,Z).

% trobaBatuts(L,D,I). Es satisfà si L és una llista formada pels parells (Establiment,NomBatut) 
% de tots els establiments-batuts que contenen els ingredients que es demanen a la llista D 
% i cap dels que es diuen a la llista I.
trobaBatuts(L,D,I):- findall(Establiment, establiment(Establiment,_,_), List), % Troba tots els establiments dintre de la base de dades i en els guarda en List
                     recurse(List,Z,D,I), % Recorre tots els establiment , construin en els mateix temps una llista per cada establiment.
                     flatten(Z,L). % Converteix llista de llistes en una unica llista


