:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:-dynamic board/1.
:-retractall(board(_)).
:-dynamic moves/1.
:-retractall(moves(_)).
:-assertz(moves([])). 
:-dynamic move/1.
:-retractall(move(_)).
:-assertz(move([])). 
:-assertz(board([
                %   6   5   4   3   2   1 
            /*A*/ ['X','X','_','_','_','_'],  %A
            /*B*/ ['X','X','_','_','_','_'],  %B
            /*C*/ ['O','X','O','_','_','_'],  %C 
            /*D*/ ['X','O','_','_','_','_'],  %D
            /*E*/ ['X','_','_','_','_','_'],  %E
            /*F*/ ['_','_','_','_','_','_'],  %F
            /*G*/ ['X','_','_','_','_','_']   %G

                ])).
:- dynamic announce/1.



initBoard():-retract(board(_)),assertz(board([
/*A*/ ['_','_','_','_','_','_'],  %A
/*B*/ ['_','_','_','_','_','_'],  %B
/*C*/ ['_','_','_','_','_','_'],  %C 
/*D*/ ['_','_','_','_','_','_'],  %D
/*E*/ ['_','_','_','_','_','_'],  %E
/*F*/ ['_','_','_','_','_','_'],  %F
/*G*/ ['_','_','_','_','_','_']])).%G


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DISPLAY THE BOARD %%%%%%%%%%%%%%%%%%%%%%%%%%

display_game():-board(Board),write("   A  B  C  D  E  F  G"),nl,display(Board,6).
display_game.

display(Grid,N) :-
    maplist(nth1(N),Grid, Column),          
    write(N),disp(Column),nl,fail.

display(Grid,N) :-
    N > 0,
    N1 is N-1,
    display(Grid,N1).

disp([]).
disp([X|L]):-write("  "),write(X),disp(L),nl,fail.

%%%%%%%%%%%%%%%%%%%%%%%%%% CHECK IF THE GAME IS OVER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

game_over(Board,opponent,Result):-checkHori(Board,'X',7);checkVert(Board,'X',6);checkdiagonals('X',Board),!.
game_over(Board,computer,Result):-checkHori(Board,'O',7);checkVert(Board,'O',6);checkdiagonals('O',Board),!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHOOSE MOVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

findFirstEmpty([E|_],E,Index,Index):-!.
findFirstEmpty([X|List],Ele,Index,Z):- K is Index+1 ,findFirstEmpty(List,Ele,K,N),Z=N,!.

legal(Board,E,X,Y):-member(E,['A','B','C','D','E','F','G']),
            indexOf(['A','B','C','D','E','F','G'],E,T), X is T+1,
            nth1(X, Board, Row),
            findFirstEmpty(Row,'_',1,Y),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOVES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

possibles_moves(_):- assertz(moves([])),
                        board(Board),between(1,7,I), nth1(I,Board,Row),
                        findFirstEmpty(Row,'_',1,Index), 
                        moves(Moves), retract(moves(_)),
                        append([[I,Index]],Moves,List), 
                        assertz(moves(List)),fail.

possibles_moves(L):- moves(L).

choose_move(opponent,Move):-board(Board),write("tria :"),repeat,
                            get_char(E),
                            legal(Board,E,X,Y),Move=[X,Y|[]],!.





choose_move(computer,Move):- possibles_moves(Moves),winingMove(Moves,Move,computer),!,dispMove(Move,computer).
choose_move(computer,Move):- possibles_moves(Moves),winingMove(Moves,Move,opponent),!,dispMove(Move,computer). % FOR BLOCK OPPONENT TO WIN
choose_move(computer,Move):- possibles_moves(Moves),length(Moves,N),random_between(1,N,I),nth1(I,Moves,Move),!,dispMove(Move,computer),nl.

winingMove([],_,_):-!,fail.
winingMove([WiningMove|Moves],Move,Player):- fakeMove(WiningMove,Player,Result),game_over(Result,Player,_),Move=WiningMove,!.
winingMove([WiningMove|Moves],Move,Player):- winingMove(Moves,Move,Player),!.
/**
 * ((game_over(Result,Player,_),Move=WiningMove); write("heheh"),winingMove(Moves,WiningMove,Player)),!.
 * winingMove(Moves,WiningMove,Player), 
board(Board),
fakeMove(WiningMove,Player,Result),
not(game_over(Result,Player,_)),!,write("game is over!").

 * **/

fakeMove([X,Y|_],computer,Result):-board(Board),replace_row_col(Board,X,Y,'O',Result),!.
fakeMove([X,Y|_],opponent,Result):-board(Board),replace_row_col(Board,X,Y,'X',Result),!.

%==========================================================================

move([X,Y|_],opponent):-board(Board),
                replace_row_col(Board,X,Y,'X',Result),
                assertz(board(Result)),
                retract(board(Board)).

move([X,Y|_],computer):-board(Board),
    replace_row_col(Board,X,Y,'O',Result),
    assertz(board(Result)),
    retract(board(Board)).



%%%%%%%%%%%%%%%%%%%%%%%% CHOOSE THE NEXT PLAYER %%%%%%%%%%%%%%%%%%%%%%%%%%%%

next_player(opponent,computer). %computer turn
next_player(computer,opponent). %player turn


announceResult(opponent):- write("YOU WON THE GAME!"),nl.
announceResult(computer):- write("THE COMPUTER WON THE GAME!"),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

init(Result):-initBoard,display_game,nl,nl,play(opponent),board(Result).

play(Player):- board(Board),
                next_player(Player,AntPlayer),
                game_over(Board,AntPlayer,Result),!,
                announceResult(AntPlayer),!.
player(Player):-possibles_moves(Moves),!,length(Moves,Len),!,Len=0,write("TIE!"),!.
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

%
% replace a single cell in a list-of-lists
% - the source list-of-lists is L
% - The cell to be replaced is indicated with a row offset (X)
%   and a column offset within the row (Y)
% - The replacement value is Z
% - the transformed list-of-lists (result) is R
%

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




dispMove(Move,opponent):- nth1(1,Move,I),nth1(I,['A','B','C','D','E','F','G'],E),write("tria: "),write(E),nl.
dispMove(Move,computer):- nth1(1,Move,I),nth1(I,['A','B','C','D','E','F','G'],E),write("robot: "),write(E),nl.

