%fact(factname, product_list).

fact(a,[pneus,pastilhas]).
fact(b,[parabrisas,janelas]).
fact(c,[jantesvw,portasvw,capovw,custombodywork]).
fact(d,[motores1300diesel,motores2000gasolina]).

%prod(prod_name,factory_name,stock_units,material_list).

%route(transpname, transp_type, fact1, fact2, dist(Km))

route(transp1, ship1, a, b, 500).
route(transp2, ship2, a, b, 500).
route(transp2, plane1, b, c, 600).

%transp(transpname, [transp_type, (Km/h)med, Emitions/Km, price/Km]).

transp(transp1, [[ship1, 90, 80, 50]]).
transp(transp2, [[ship2, 70, 40, 60],[plane1, 250, 60, 110]]).

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------

conc([], L, L).
conc([C|R], L, [C|T]) :- conc(R, L, T). 

readoption(O):-
    get_single_char(C),
    put_code(C),
    number_codes(O,[C]), 
    valid(O),
    nl.
readoption(O):-
    readoption(O).

valid(O):- O >=1, O=<5.

menu_1 :- 
    nl,
    write('Gestao da base de conhecimento'), 
    nl,
    menu(Op),
    execute(Op).

menu(Op) :- 
    write('1 -> Adicionar'),nl,
    write('2 -> Alterar'),nl,
    write('3 -> Remover'),nl,
    write('4 -> Exit'), nl,
    readoption(Op).

menu_add :- 
    nl,
    write('Menu para adicionar cenas'), 
    nl,
    add_menu(Op),
    execute(Op).

add_menu(Op):-
    write('1 -> Adicionar fabricas a cadeia/rede'),nl,
    write('2 -> Adicionar stock a uma fabrica'),nl,
    write('3 -> Adicionar transportadores'),nl,
    write('4 -> Adicionar descricao de produto'),nl,
    write('5 -> Exit'), nl,
    readoption(Op1),
    Op is Op1 + 10.

menu_alter :- 
    nl,
    write('Menu para alterar cenas'), 
    nl,
    alter_menu(Op),
    execute(Op).

alter_menu(Op):-
    write('1 -> Alterar fabricas da cadeia/rede'),nl,
    write('2 -> Alterar stock numa fabrica'),nl,
    write('3 -> Alterar transportadores'),nl,
    write('4 -> Alterar descricao de produto'),nl,
    write('5 -> Exit'), nl,
    readoption(Op1),
    Op is Op1 + 20.

menu_rmv :- 
    nl,
    write('Menu para remover cenas'), 
    nl,
    rmv_menu(Op),
    execute(Op).

rmv_menu(Op):-
    write('1 -> Remover fabricas da cadeia/rede'),nl,
    write('2 -> Remover stock numa fabrica'),nl,
    write('3 -> Remover transportadores'),nl,
    write('4 -> Remover descricao de produto'),nl,
    write('5 -> Exit'), nl,
    readoption(Op1),
    Op is Op1 + 30.

execute(Op):- 
    Op =< 4,
    exec(Op), 
    nl, 
    menu(NOp), 
    execute(NOp).

execute(Op):- 
    Op > 10,
    Op =< 15,
    exec(Op), 
    nl, 
    add_menu(NOp), 
    execute(NOp).

execute(Op):- 
    Op > 20,
    Op =< 25,
    exec(Op), 
    nl, 
    alter_menu(NOp), 
    execute(NOp).

execute(Op):- 
    Op > 30,
    Op =< 35,
    exec(Op), 
    nl, 
    rmv_menu(NOp), 
    execute(NOp).

exec(1) :- menu_add.
exec(2) :- menu_alter.
exec(3) :- menu_rmv.
exec(4) :- abort.

%exec(1) :- add_menu(Op).
%exec(2) :- addFact.
%exec(3) :- removeFact.
%exec(4) :- removeFact.
exec(15) :- menu_1.

%exec(1) :- add_menu(Op).
%exec(2) :- addFact.
%exec(3) :- removeFact.
%exec(4) :- removeFact.
exec(25) :- menu_1.

%exec(1) :- add_menu(Op).
%exec(2) :- addFact.
%exec(3) :- removeFact.
%exec(4) :- removeFact.
exec(35) :- menu_1.


