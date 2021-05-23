%---------------FACTORY---------------
save_facts :- tell('facts.pl'),
            listing(fact),
            told.

memorize_fact(fact(Node,Prod)) :- assertz(fact(Node,Prod)),
                    save_facts.
memorize_fact(_) :- write('=> Invalid Data').

:- dynamic fact/2.
:- consult('facts.pl').
:- write('Loaded:'), listing(fact).
%----------------PRODUCT----------------

save_prod :- tell('prods.pl'),
            listing(prod),
            told.

memorize_prod(prod(Prod_name,Factory_name,Stock_units,Material_list)) :- assertz(prod(Prod_name,Factory_name,Stock_units,Material_list)),
                    save_prod.
memorize_prod(_) :- write('=> Invalid Data').

:- dynamic prod/4.
:- consult('prods.pl').
:- write('Loaded:'), listing(prod).

%---------------TRANSPORT---------------
save_transps :- tell('transps.pl'),
            listing(transp),
            told.


memorize_transp(transp(Name,Transp_desc)) :- assertz(transp(Name,Transp_desc)),
                    save_transps.
memorize_transp(_) :- write('=> Invalid Data').

:- dynamic transp/2.
:- consult('transps.pl').
:- write('Loaded:'), listing(transp).

%---------------TRANSPORT---------------
save_transps :- tell('transps.pl'),
            listing(transp),
            told.


memorize_transp(transp(Name,Fact1,Fact2,Dist,Speed,Emitions)) :- assertz(transp(Name,Fact1,Fact2,Dist,Speed,Emitions)),
                    save_transps.
memorize_transp(_) :- write('=> Invalid Data').

:- dynamic transp/6.
:- consult('transps.pl').
:- write('Loaded:'), listing(transp).

%---------------ADD FACTORY---------------
%new_fact :- read(S),memorize_fact(S).

conc([], L, L).
conc([C|R], L, [C|T]) :- conc(R, L, T).

exists_factory_AF(Fact_name):-
    fact(Fact_name,_),
    write('=> Factory Name Taken'),nl,
    new_fact.
exists_factory_AF(_).

single_read_string(Atom):-
    read_string(user_input,"\n","\r",_,Str),
    string_to_atom(Str,Atom).

read_fact_prods_finish(Node,Prod_list):-
    write('Enter product (Enter stop to finish): '),
    single_read_string(Prod),
    process_fact_prods(Node,Prod_list,Prod).

process_fact_prods(Node,Prod_list,stop):-
    memorize_fact(fact(Node,Prod_list)).
process_fact_prods(Node,Prod_list,Prod):-
    dif(Prod, stop),
    conc(Prod_list,[Prod],Prod_list1),
    read_fact_prods_finish(Node,Prod_list1).

new_fact:-
    write('Enter factory name: '),
    single_read_string(Node),
    exists_factory_AF(Node),
    read_fact_prods_finish(Node,[]).

%-------------ADD PROD DESC--------------

single_read_numb(Number):-
    read_string(user_input,"\n","\r",_,Str),
    string_to_atom(Str,Atom),
    atom_number(Atom,Number).

valid_fact_name_APD(Fact_name):-
    fact(Fact_name,_).
valid_fact_name_APD(_):-
    write('=> Invalid Factory Name'),nl,
    add_desc.

valid_prod_name_APD(Fact_name,Prod_name):-
    fact(Fact_name,Prod_list),
    is_member(Prod_name,Prod_list).
valid_prod_name_APD(_,_):-
    write('=> Invalid Product Name Or Product not in factory'),nl,
    add_desc.

is_member(E, [E|_]).
is_member(E, [_|R]) :- is_member(E,R).

read_prods_mat_finish(Fact_name,Prod_name,Stock,Mat_list):-
    write('Enter material (Enter stop to finish): '),
    single_read_string(Mat),
    process_prod_mat(Fact_name,Prod_name,Stock,Mat_list,Mat).

process_prod_mat(Fact_name,Prod_name,Stock,Mat_list,stop):-
    memorize_prod(prod(Prod_name,Fact_name,Stock,Mat_list)).
process_prod_mat(Fact_name,Prod_name,Stock,Mat_list,Mat):-
    dif(Mat, stop),
    conc(Mat_list,[Mat],Mat_list1),
    read_prods_mat_finish(Fact_name,Prod_name,Stock,Mat_list1).

add_desc:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name_APD(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name_APD(Fact_name,Prod_name),
    write('Enter stock amount: '),
    single_read_numb(Stock),
    read_prods_mat_finish(Fact_name,Prod_name,Stock,[]).

%-------------ADD PROD STOCK-------------

add_stock(prod(Prod_name,Fact_name,Initial_stock,Mat_list),Stock):-
    New_stock is Initial_stock + Stock,
    retract(prod(Prod_name,Fact_name,Initial_stock,Mat_list)),
    memorize_prod(prod(Prod_name,Fact_name,New_stock,Mat_list)).

valid_fact_name_APS(Fact_name):-
    fact(Fact_name,_).
valid_fact_name_APS(Fact_name):-
    not(fact(Fact_name,_)),
    write('=> Invalid Factory Name'),nl,
    fail.

valid_prod_name_APS(Fact_name,Prod_name):-
    fact(Fact_name,Prod_list),
    is_member(Prod_name,Prod_list).
valid_prod_name_APS(Fact_name,Prod_name):-
    fact(Fact_name,Prod_list),
    not(is_member(Prod_name,Prod_list)),
    write('=> Invalid Product Name Or Product not in factory'),nl,
    fail.

add_stock_menu:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name_APS(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name_APS(Fact_name,Prod_name),
    write('Enter aditional stock amount: '),
    single_read_numb(Stock),
    prod(Prod_name,Fact_name,Initial_stock,Mat_list),
    add_stock(prod(Prod_name,Fact_name,Initial_stock,Mat_list),Stock).
add_stock_menu:-
    add_stock_menu.

%---------------ADD TRANSP---------------

exists_travel(Transp_name,Fact_name_i,Fact_name_f):-
    transp(Transp_name,Fact_name_i,Fact_name_f,_,_,_),
    write('=> Cant have same route from same transporter'),nl,
    add_transp.
exists_travel(_,_,_).

valid_fact_name_AT(Fact_name):-
    fact(Fact_name,_).
valid_fact_name_AT(_):-
    write('=> Invalid Factory Name'),nl,
    add_transp.

add_transp:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    write('Enter shipper factory name: '),
    single_read_string(Fact_name_i),
    valid_fact_name_AT(Fact_name_i),
    write('Enter receiver factory name: '),
    single_read_string(Fact_name_f),
    valid_fact_name_AT(Fact_name_f),
    exists_travel(Transp_name,Fact_name_i,Fact_name_f),
    write('Enter travel distance: '),
    single_read_numb(Distance),
    write('Enter price per ton: '),
    single_read_numb(Price),
    memorize_transp(transp(Transp_name,Fact_name_i,Fact_name_f,Distance,Price)).

%---------------RMV FACTORY---------------

valid_fact_name_RF(Fact_name):-
    fact(Fact_name,_).
valid_fact_name_RF(_):-
    write('=> Invalid Factory Name'),nl,
    rmv_fact.

rmv_fact:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name_RF(Fact_name),
    fact(Fact_name,Prod_list),
    retract(fact(Fact_name,Prod_list)).

%-------------RMV PROD DESC--------------



%-------------RMV PROD STOCK-------------



%---------------RMV TRANSP---------------

valid_travel(Transp_name,Fact_name_i,Fact_name_f):-
    transp(Transp_name,Fact_name_i,Fact_name_f,_,_).
valid_travel(_,_,_):-
    write('=> Invalid Travel Data'),nl,
    rmv_transp.

valid_transp_name_RT(Transp_name):-
    transp(Transp_name,_,_,_,_).
valid_transp_name_RT(_):-
    write('=> Transporter does not exist'),nl,
    rmv_transp.

rmv_transp:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    valid_transp_name_RT(Transp_name),
    write('Enter shipper factory name: '),
    single_read_string(Fact_name_i),
    write('Enter receiver factory name: '),
    single_read_string(Fact_name_f),
    valid_travel(Transp_name,Fact_name_i,Fact_name_f),
    transp(Transp_name,Fact_name_i,Fact_name_f,Distance,Price),
    retract(transp(Transp_name,Fact_name_i,Fact_name_f,Distance,Price)).

%------------------LIST REQUIRED PIECES------------------
%RF5
get_prod_reqs:-
    single_read_string(Product),
    prod(Product,_,_,Materials),
    write(Materials).

%------------------LIST FACTORIES WITH A PRODUCT------------------
%RF6
get_prod_from_fact:-
    single_read_string(Product),
    fact(Factory, Products),
    is_member(Product,Products),
    write(Factory),
    nl,
    fail;
    true.

%------------------LIST TRANSPORTS BETWEEN FACTORIES------------------

get_transp_fact:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    transp(Transport,Fab1,Fab2,_,_),
    write(Transport),
    fail;
    true.

%------------------MENU------------------

readoption(O):-
    get_single_char(C),
    put_code(C),
    number_codes(O,[C]), 
    valid(O),
    nl.
readoption(O):-
    readoption(O).

valid(O):- O >=1, O=<6.

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
    write('1 -> Adicionar fabrica a cadeia/rede'),nl,
    write('2 -> Adicionar stock a uma fabrica'),nl,
    write('3 -> Adicionar transportador'),nl,
    write('4 -> Adicionar rota a transportador'),nl,
    write('5 -> Adicionar descricao a um produto'),nl,
    write('6 -> Exit'), nl,
    readoption(Op1),
    Op is Op1 + 10.

menu_alter :- 
    nl,
    write('Menu para alterar cenas'), 
    nl,
    alter_menu(Op),
    execute(Op).

alter_menu(Op):-
    write('1 -> Alterar fabrica da cadeia/rede'),nl,
    write('2 -> Alterar stock numa fabrica'),nl,
    write('3 -> Alterar informacao de transportador'),nl,
    write('4 -> Alterar informacao de rota'),nl,
    write('5 -> Alterar descricao a um produto'),nl,
    write('6 -> Exit'), nl,
    readoption(Op1),
    Op is Op1 + 20.

menu_rmv :- 
    nl,
    write('Menu para remover cenas'), 
    nl,
    rmv_menu(Op),
    execute(Op).

rmv_menu(Op):-
    write('1 -> Remover fabrica da cadeia/rede'),nl,
    write('2 -> Remover stock numa fabrica'),nl,
    write('3 -> Remover transportador'),nl,
    write('4 -> Remover rota de um transportador'),nl,
    write('5 -> Remover descricao de produto'),nl,
    write('6 -> Exit'), nl,
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

exec(11) :- 
    new_fact,
    menu_add.
exec(12) :- 
    add_stock_menu,
    menu_add.
exec(13) :- 
    add_transp,
    menu_add.
%exec(14) :- 
%    add_route,
%    menu_add.
exec(15) :- 
    add_desc,
    menu_add.
exec(16) :- menu_1.

%exec(21) :- add_menu(Op).
%exec(22) :- .
%exec(23) :- .
%exec(24) :- 
%    alter_route,
%    menu_add.
%exec(25) :- .
exec(26) :- menu_1.

exec(31) :- 
    rmv_fact,
    menu_rmv.
%exec(32) :- .
exec(33) :- 
    rmv_transp,
    menu_rmv.
%exec(34) :- 
%    rmv_route,
%    menu_add.
%exec(35) :- .
exec(36) :- menu_1.

