
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% INICIALITSACIO DEL TAULER  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%predicats que es satifan automaticament quan s'inicia el programa.
:-dynamic board/1. % iniciem un tauler dynamic, que anirem modifican durant el joc. 
:-retractall(board(_)). % eliminem el tauler si ja existia.
:-dynamic moves/1. % predicat que anira guardant les possibles jugades del tauler en tot moment.
:-retractall(moves(_)).
:-assertz(moves([])). 


/**
 * @Parametres
 * Es satisfa el predicat initBoard() si s'ha creat dinanmicament el tauler mitjançant els methodes
 * retract() per eliminar el tauler ja exitent, i despres amb el predicat < assertz()> crear un de nou buit.
 * **/
initBoard():-retract(board(_)),assertz(board([
/*A*/ ['_','_','_','_','_','_'],  %A
/*B*/ ['_','_','_','_','_','_'],  %B
/*C*/ ['_','_','_','_','_','_'],  %C 
/*D*/ ['_','_','_','_','_','_'],  %D
/*E*/ ['_','_','_','_','_','_'],  %E
/*F*/ ['_','_','_','_','_','_'],  %F
/*G*/ ['_','_','_','_','_','_']])).%G




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% PREDICATS QUE NOSTREN PER PANATALLA EL TAULER DEL TAULER  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
*@Parametres
*Es satisfa el predicat display_game() si es mostra correctament el tauler per 
*pantalla amb el format requerit.
*/
display_game():-board(Board),write("   A  B  C  D  E  F  G  "),nl,display(Board,6).

display_game.

/**
 * Grid -> El tauler
 * N -> Nombre de columnes
 * Es satisfa si es mostra totes les columnes del tauler comencent per l'element en la posicio N
 * de cada fila. 
 * **/
display(Grid,N) :-
    maplist(nth1(N),Grid, Column), %per cada fila del tauler guarda l'element N en la llista Columna.         
    write(N),disp(Column),nl,fail.

display(Grid,N) :-
    N > 0,
    N1 is N-1,
    display(Grid,N1).

/**
 * @Parameters
 * L -> Llista d'elements.
 * Es satisfa si es mostra tots els elements de la llista L.
 * **/
disp([]).
disp([X|L]):-write("  "),write(X),disp(L),nl,fail.

/**
 * 
 * 
 * **/
announceResult(opponent):- write("YOU WON THE GAME!"),nl.
announceResult(computer):- write("THE COMPUTER WON THE GAME!"),nl.

/**
 * 
 * 
 * **/
dispMove(Move,opponent):- nth1(1,Move,I),nth1(I,['A','B','C','D','E','F','G'],E),write("tria: "),write(E),nl.
dispMove(Move,computer):- nth1(1,Move,I),nth1(I,['A','B','C','D','E','F','G'],E),write("robot: "),write(E),nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%&&&&&&& PREDICATS PER COMPROBAR SI HA ACABAT EL JOC  %%%%%%%%&&&&&&
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Board -> Tauler
 * opponent/computer -> Jugador Huma / Ordinador
 * Es satisfa si el jugador huma o l'ordinador aconsegueix alinear 4 peces horizontalment;verticalment;
 * o diagonalment en el tauler.  
 * **/
game_over(Board,opponent,_):-checkHori(Board,'X',7);checkVert(Board,'X',6);checkdiagonals('X',Board),!.
game_over(Board,computer,_):-checkHori(Board,'O',7);checkVert(Board,'O',6);checkdiagonals('O',Board),!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% PREDICATS PER ESCOLLIR ELS MOVIMENTS  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/**
 * Board -> El tauler
 * E -> '_' codifica el una posicio buida en el tauler
 * X -> fila
 * Y -> columna
 * Es satisfa si en la posicio x,y del tauler es una posicio buida. 
 * **/
legal(Board,E,X,Y):-member(E,['A','B','C','D','E','F','G']),
            indexOf(['A','B','C','D','E','F','G'],E,T), X is T+1, %troba l'index de l'element E i guarda el resultat en T
            nth1(X, Board, Row),
            findFirstEmpty(Row,'_',1,Y),!. %Troba la prima posicio buida de la fila.


/**
 * Es satisfa el predicat possibles_moves , si en encara es poden
 * fer moviments en el tauler, i posteriorment guardar els moviments en la 
 * llista dynamica <moves/1>
 * 
 * **/
possibles_moves(_):- assertz(moves([])),
                        board(Board),between(1,7,I), nth1(I,Board,Row),
                        findFirstEmpty(Row,'_',1,Index), % troba la primera posicio buida de la fila
                        moves(Moves), % agafa el moviments els moviments valids en el tauler
                        retract(moves(_)),
                        append([[I,Index]],Moves,List), % afageix el nou moviment trobat en la llista dynamica de moviments
                        assertz(moves(List)),fail. %guarda la llista modificada amb el nou moviment.

possibles_moves(L):- moves(L).

/**
* opponent -> Jugador huma
* Move -> Jugada que fara el judador huma amb posicio [x,y]
* Es satisfa si el jugador huma ha escollit una jugada valida.
 * **/
choose_move(opponent,Move):-board(Board),write("tria :"),repeat,
                            get_char(E), %demanem el jugador la posicio on vol tirar i guardem el resultat en E
                            legal(Board,E,X,Y),Move=[X,Y|[]],!. %comprovem si la jugada es valida i posteriorment unificar la jugada a Move




/**
 * computer -> Ordinador
 * Move -> Parametre on unificarem la jugada escollida per l'ordinador
 * Es satisfa si l'ordinador acconsegueix fer una jugada correctament
 * **/
choose_move(computer,Move):- possibles_moves(Moves),winingMove(Moves,Move,computer),!,dispMove(Move,computer).
choose_move(computer,Move):- possibles_moves(Moves),winingMove(Moves,Move,opponent),!,dispMove(Move,computer). % FOR BLOCK OPPONENT TO WIN
choose_move(computer,Move):- possibles_moves(Moves),length(Moves,N),random_between(1,N,I),nth1(I,Moves,Move),!,dispMove(Move,computer),nl.

/**
 * Moves -> Llista de possibles moviments en el tauler
 * Move -> Variable on unificarem la jugada ganadora per l'ordinador o que bloqueja l'opponent en guanyar.
 * Player -> Jugador
 * Es satisfa si s'aconseguix si es troba jugada que fagi guanyar l'ordinador altrament un eviti l'opponent guanyar 
 * i si no es compleixent tots els objectius anteriors es s'escollira una jugada random d'intre dels possibles moviments.
 * **/
winingMove([],_,_):-!,fail.
% simulem una jugada amb un dels moviments de la llista de moviments i seguidament comprobar si es una jugada guanyador 
% i en cas que ho sigui acabem la cerca i unifiquem la jugada a  Move
winingMove([WiningMove|Moves],Move,Player):- fakeMove(WiningMove,Player,Result),game_over(Result,Player,_),Move=WiningMove,!.
winingMove([WiningMove|Moves],Move,Player):- winingMove(Moves,Move,Player),!.

/**
 * Move -> Juga que volem simular
 * computer/opponent -> Judador amb qui volem fer la simulacio
 * Result -> Esta del tauler despres de fer la simulacio amb el jugador computer/opponent
 * Es satisfa si s'ha pogut dur a terme la judada 
 * **/
fakeMove([X,Y|_],computer,Result):-board(Board),replace_row_col(Board,X,Y,'O',Result),!.
fakeMove([X,Y|_],opponent,Result):-board(Board),replace_row_col(Board,X,Y,'X',Result),!.

/**
 * Move -> Move que volem dur a terme en el tauler
 * opponent -> Jugador huma 
 * Es satisfa si s'ha pogut dur a terme el moviment correctament en el tauler
 * **/
move([X,Y|_],opponent):-board(Board),
                replace_row_col(Board,X,Y,'X',Result), % posa la peça del jugador huma en la posicio x,y
                assertz(board(Result)),
                retract(board(Board)).

/**
* Move -> Move que volem dur a terme en el tauler
* compuer -> Ordinador 
* Es satisfa si s'ha pogut dur a terme el moviment correctament en el tauler
* **/
move([X,Y|_],computer):-board(Board),
    replace_row_col(Board,X,Y,'O',Result),
    assertz(board(Result)),
    retract(board(Board)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% ESCOLLIM EL SEGUENT JUGADOR  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


next_player(opponent,computer). %computer turn
next_player(computer,opponent). %player turn




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

init_game(Result):-initBoard,display_game,nl,nl,play(opponent),board(Result).

play(Player):- board(Board),
                next_player(Player,AntPlayer),
                game_over(Board,AntPlayer,Result),!,
                announceResult(AntPlayer),!.
play(Player):-possibles_moves(Moves),!,length(Moves,Len),!,Len=0,write("TIE!"),!.
play(Player) :-choose_move(Player,Move),
                                move(Move,Player),
                                display_game,nl,nl,
                                next_player(Player,Player1),!,
                                play(Player1).
                                



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%     HELPER METHODS    %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.

sublist(SubList, List) :-
    append(Prefix, _, List),
    append(_, SubList, Prefix).

replace_nth(N,I,V,O) :-
    nth1(N,I,_,T),
    nth1(N,O,V,T).

replace_row_col(M,Row,Col,Cell,N) :-
    nth1(Row,M,Old),
    replace_nth(Col,Old,Cell,Upd),
    replace_nth(Row,M,Upd,N).


checkHori(Grid, J, N) :-
            maplist(nth1(N),Grid, Column),        
            sublist([J,J,J,J],Column),!.   


checkHori(Grid, J, N) :-
                        N > 0,
                        N1 is N-1,
                        checkHori(Grid, J, N1),!.


checkVert(Grid, J, N) :-
            nth1(N,Grid,L),          
            sublist([J,J,J,J], L),
            !.


checkVert(Grid, J, N) :-
            N > 0,
            N1 is N-1,
            checkVert(Grid, J, N1),!.


checkdiagonals(X,T):- append(_,[C1,C2,C3,C4|_],T), % check if 4 connected columns exists in board...
       append(I1,[X|_],C1), %...such that all of them contain a piece of player X...
       append(I2,[X|_],C2),
       append(I3,[X|_],C3),
       append(I4,[X|_],C4),
       length(I1,M1), length(I2,M2), length(I3,M3), length(I4,M4),
       M2 is M1-1, M3 is M2-1, M4 is M3-1,!.






findFirstEmpty([E|_],E,Index,Index):-!.
findFirstEmpty([X|List],Ele,Index,Z):- K is Index+1 ,findFirstEmpty(List,Ele,K,N),Z=N,!.