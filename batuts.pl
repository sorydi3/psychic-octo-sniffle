establiment(
    best_batuts, [alan,john,mary],
    [
        batut(berry, [orange, blueberry, strawberry], 2),
        batut(tropical, [orange, banana, mango, guava], 3),
        batut(blue, [banana, blueberry], 3) 
    ]
).

establiment(
    all_batuts, [keith,mary],
    [ 
        batut(pinacolada, [orange, pineapple, coconut], 2),
        batut(green, [orange, banana, kiwi], 5),
        batut(purple, [orange, blueberry, strawberry], 2),
        batut(smooth, [orange, banana, mango],1) 
    ]
).

establiment(
    batuts_galore, [heath,john,michelle],
    [ 
        batut(combo1, [strawberry, orange, banana], 2),
        batut(combo2, [banana, orange], 5),
        batut(combo3, [orange, peach, banana], 2),
        batut(combo4, [guava, mango, papaya, orange],1),
        batut(combo5, [grapefruit, banana, pear],1) 
    ]
).


/**
 * @parameters N -> Nom de l'establiment
 * @parametere E -> Nombre de batuts
 * es satisfa si l’establiment E te m´es de N batuts.
 **/
mesDe(N,E):- establiment(N,_,L),length(L, Len),Len>E.

/**
 * N -> Nom de l'establiment
 * B -> Nom del batut
 * Es satisfa si l'establiment B fa el batut E
 **/

member_(X,[X|XS]).
member_(X,[Y|YS]):-member_(X,YS).

elFa(B,E):-establiment(B,_,L),member_(batut(E,_,_),L).

/**
 * 
 **/
ratio(E,R):-true.

/**
 * 
 **/
promig(E,P):-true.

/**
 * 
 **/
mesbarat(E):-true.

/**
 * 
 **/
trobaBatuts(L,D,I):-true. 


try :- member(batuts(combo2,_,_),[ 
    batut(combo1, [strawberry, orange, banana], 2),
    batut(combo2, [banana, orange], 5),
    batut(combo3, [orange, peach, banana], 2),
    batut(combo4, [guava, mango, papaya, orange],1),
    batut(combo5, [grapefruit, banana, pear],1) 
]).