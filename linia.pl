:-dynamic board/1.
:-retractall(board(_)).
:-assertz(board([[A1,B1,C1,D1,E1,F1,G1],
                 [A2,B2,C2,D2,E2,F2,G2],
                 [A3,B3,C3,D3,E3,F3,G3],
                 [A4,B4,C4,D4,E4,F4,G4],
                 [A5,B5,C5,D5,E5,F5,G5],
                 [A6,B6,C6,D6,E6,F6,G6]
                ])).




%----------------------------------------------------------------------------------

mark(Player,[X,Y|Position],Result):-board(Board),nth1(X, Board, MatRow),nth1(Y, MatRow, Z),Z=Player,write(Board).


initialize(Game,Position,Player):-true.


display_game(Position,Player):-true.


game_over(Position,Player,Result):-true.


announce(Result):-true.

/** CHECK WETHER A MOVE IS LEGAL OR NOT **/
legal(Z):-member(Z,['A','B','C','D','E','F','G']).
choose_move(Position,opponent,Move):- nl,repeat,
                                    writeln("Please make a move! A To G"),
                                    read(Move),
                                    legal(Move).

choose_move(Position,computer,Move):- true. %ordinador


move(Move,Position,Result):-true.


next_player(ActPlayer,NextPly):-true.

play(Game):-initialize(Game,Position,Player),display_game(Position,Player),play(Position,Player,Result).

play(Position,Player,Result):-game_over(Position,Player,Result),!,announce(Result).

play(Position,Player,Result):- choose_move(Posicion,Player,Move),
                                move(Move,Posicion,Posicion1),
                                display_game(Posicion1,Player),
                                next_player(Player,Player1),!,
                                play(Posicion1,Player1,Result).
                                