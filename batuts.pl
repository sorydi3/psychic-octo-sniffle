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
 * Es satisfa si l'establiment E te un ratio d'empleat per batut R
 **/
ratio(E,R):- true.

/**
 * 
 **/
suma([],0).
suma([batut(_,_,L)|LS],M):-suma(LS,Z),M is Z+L.
promig(E,P):-establiment(E,_,L),length(L,Len),suma(L,M),Z is M/Len,Z=P.


/**
 * Es satisfa si l'establiment  E Te els batuts mes barats en promitge.
 **/
pro(E,X):- establiment(E,_,L),length(L,Len),suma(L,M),X is M/Len.
mesbarat(E):-establiment(E,_,L),
            suma(L,Sum),length(L,Len),Pro is Sum/Len,
            establiment(X,_,LX),X \= E,
            suma(LX,SumX),length(LX,LenX),ProX is SumX/LenX,
            ProX<Pro,!,write("found one that is lesser: "),write(ProX),nl,write("than: "),write(Pro),fail.
mesbarat(E).

/**
 * 
 **/
trobaBatuts(L,D,I):-true. 


try(X):-suma([ 
    batut(combo1, [strawberry, orange, banana], 2),
    batut(combo2, [banana, orange], 5),
    batut(combo3, [orange, peach, banana], 2),
    batut(combo4, [guava, mango, papaya, orange],1),
    batut(combo5, [grapefruit, banana, pear],1) 
],X).