:-dynamic board/1.
:-retractall(board(_)).
:-assertz(board([
                %   6   5   4   3   2   1 
            /*A*/ ['_','_','_','_','_','_'],  %A
            /*B*/ ['_','_','_','_','_','_'],  %B
            /*C*/ ['_','_','_','_','_','_'],  %C 
            /*D*/ ['_','_','_','_','_','_'],  %D
            /*E*/ ['_','_','_','_','_','_'],  %E
            /*F*/ ['_','_','_','_','_','_'],  %F
            /*G*/ ['_','_','_','_','_','_']   %G

                ])).




%----------------------------------------------------------------------------------

display_game(Position,Player):-true.


game_over(Position,Player,Result):-true.


announce(Result):-true.
%findFirstEmpty([],_,_,-1). 
findFirstEmpty([E|_],E,Index,Index).
findFirstEmpty([X|List],Ele,Index,Z):- K is Index+1 ,findFirstEmpty(List,Ele,K,N),Z=N,!.
 
/** CHECK WETHER A MOVE MADE BY THE PLAYER IS LEGAL OR NOT **/
legal(Board,Y,X):- member(Y,['A','B','C','D','E','F','G']),
            indexOf(['A','B','C','D','E','F','G'],Y,Z),
            nth1(X, Board, Row),
            findFirstEmpty(Row,'_',0,Z).


%===========================================================================
choose_move(Board,opponent,Move):- nl,repeat,
                                    writeln("Please make a move! A To G"),
                                    read(Y),
                                    legal(Board,Y,X),Move=[X,Y|[]].

choose_move(Position,computer,Move):- true. %ORDINADOR

%==========================================================================

move([X,Y|_],Board,Result,opponent):-
                replace_row_col(Board,X,Y,'X',Result),
                assertz(board(Result)),
                retract(board(Board)).

/* CHOOSE THE NEXT PLAYER */    
next_player(opponent,computer).
next_player(computer,opponent).

play(Game):-display_game(Position,Player),play(Board,opponent,Result).

play(Board,Player,Result):- game_over(Board,Player,Result),!,announce(Result).

play(Position,Player,Result) :- choose_move(Posicion,Player,Move),
                                move(Move,Posicion,Posicion1),
                                display_game(Posicion1,Player),
                                next_player(Player,Player1),!,
                                play(Posicion1,Player1,Result).
                                


%---------------------------------------------HELPERS METHODS---------------------------------

indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.


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


display([]).
display([X|L]):- displist([X]),nl,display(L).


displist([]).
dispList([X|L]):-write(X),write(" "),dispList(L).