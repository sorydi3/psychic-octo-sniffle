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

establiment( % -> Promig 3.0
    batuts_barats, [pep,laia,rosana],
    [ 
        batut(fresc1, [peach, lemon, milk], 2),
        batut(fresc2, [cherry], 1),
        batut(fresc3, [strawberry, orange, milk], 1.2),
        batut(fresc4, [chocolate, milk, strawberry], 1.5),
        batut(fresc5, [watermelon, pear, yogurt, peach], 4) 
    ]
).


%=============================================================
%                       mesDe(N,E).
%=============================================================

/**
 * N -> Nombre de batuts
 * E -> Nom de l'establiment
 * Es satisfà si l’establiment E te més de N batuts.
 **/
mesDe(N,E):- establiment(E,_,L), length(L,Len), Len > N.

%=============================================================
%                        elFa(B,E).
%=============================================================

/**
 * B -> Nom del batut
 * E -> Nom de l'establiment
 * Es satisfa si l'establiment E fa el batut B
 **/

elFa(B,E):- establiment(E,_,L), member(batut(B,_,_),L). % S'hauria de fer un tall a algun lloc perque sino al fer p.e. elFa(combo1, batuts_galore) dona true i despres false


%=============================================================
%                       ratio().
%=============================================================

/**
 * Es satisfa si l'establiment E te un ratio d'empleat per batut R
 **/
ratio(E,R):- true.
 %  I don't understand th question

 %=============================================================
%                        promig(E,N).
%=============================================================

/**
 * E -> Nom de l'establiment
 * P -> Preu promig dels batuts
 * Es satisfà si el preu promig dels batuts de E és P
 **/
suma([],0).
suma([batut(_,_,L)|LS],M):- suma(LS, Z), M is Z + L.
promig(E,P):- establiment(E,_,L), length(L,Len), suma(L,M), Z is M/Len, Z = P.


%=============================================================
%                        mesBarat(E)
%=============================================================


/**
 * E -> Nom de l'establiment
 * Es satisfa si l'establiment E te els batuts mes barats en promitge.
 **/
mesBarat(E):- establiment(E, _, _), promig(E, Pe), establiment(X, _, _), X \= E, promig(X, Px), Pe > Px, !, fail. % A la mínima que n'hi hagi un de mes barat fallar
mesBarat(E). % Si provant tots els altres establiment no s'ha complert l'anterior, aquesta retornarà true, NO ES POT CANVIAR D'ORDRE



%=============================================================
%                        trobaBatut(L,D,I).
%=============================================================

/**
 * LX -> Llista la quaal volem comprovar si alguns dels seu elements pertanyen a la llista D.
 * D  -> Llista en la qual volem comprovar
 * Comprova si alguns dels ingredients de LX pertanyant a la llista D.
 **/
memList([],D).
memList([L|LX],D):-memList(LX,D),not(member(L,D)). 
/**
 * LX -> Llista la qual volem comprovar si TOTS els seus elements pertanyen a la llista D.
 * D Llista en la qual volem fer la comprovacio
 * Comprova si tots els elements de LX pertanyent  a la llista D
 * **/
allmemList([],D).
allmemList([L|LX],D):-allmemList(LX,D),member(L,D).

/**
 * E -> establiment
 * Lb -> Llista de batuts de l'establiment
 * D -> Ingredients que han d'estar a la llista d'ingredients del batut
 * I -> Ingredients que no han d'estat a la llista d'ingredients del batut
 * L -> Llista on guardem el resultat
 * Fa un recorregut de tots els batuts de l'establiment i comprovant si el batut compleix els requisits D i I.
 * **/
fillList(_,[],_,_,[]).
fillList(E,[batut(M,List,_)|Lb],D,I,[E,M|L]):-fillList(E,Lb,D,I,L),memList(List,I),allmemList(D,List),!.
fillList(E,[batut(M,List,_)|Lb],D,I,L):-fillList(E,Lb,D,I,L).

/**
 * Establiments -> Llista amb noms d'establiments
 * L -> Llista de sortida
 * D -> Ingredients que han d'estar a la llista d'ingredients del batut
 * I -> Ingredients que no han d'estat a la llista d'ingredients del batut
 * Fa un recorregut de tots els establiments de la base de dades.
 * **/
recurse([],[],_,_).
recurse([X|Establiments],[Z|L],D,I) :- recurse(Establiments,L,D,I),establiment(X,In,Lb),fillList(X,Lb,D,I,Z).

/**
 * D -> Ingredients que han d'estar a la llista d'ingredients del batut
 * I -> Ingredients que no han d'estar a la llista d'ingredients del batut
 *  Es satisfa si L es una llista formada pels parells <Establiment NomBatuts> de tots els establiments-batuts que 
 *  Contenent els ingredients que es demanent a la llista D i cap dels que es diuen en la llista I.
 * **/
trobaBatuts(L,D,I):-  
                    findall(Establiment, establiment(Establiment,_,_), List), % troba tots els establiments dintre de la base de dades i en els guarda en List
                    recurse(List,Z,D,I), %recorre tots els establiment , construin en els mateix temps una llista per cada establiment.
                    flatten(Z,L). % converteix llista de llistes en una unica llista


