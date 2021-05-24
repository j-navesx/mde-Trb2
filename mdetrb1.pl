%------------Coisas uteis------------

exists_transp(Transp_name):-
    transp(Transp_name,_)
    ->
    write('=> Transporter already exists'),
    nl,
    fail
    ;
    true.

single_read_string(Atom):-
    read_string(user_input,"\n","\r",_,Str),
    string_to_atom(Str,Atom).

exists_factory(Fact_name):-
    fact(Fact_name,_)
    ->
    write('=> Factory Name Taken'),nl,
    fail
    ;
    true.

conc([], L, L).
conc([C|R], L, [C|T]) :- conc(R, L, T).

single_read_numb(Number):-
    read_string(user_input,"\n","\r",_,Str),
    string_to_atom(Str,Atom),
    atom_number(Atom,Number).

valid_fact_name(Fact_name):-
    fact(Fact_name,_).
valid_fact_name(_):-
    write('=> Invalid Factory Name'),nl,
    fail.

valid_prod_name(Fact_name,Prod_name):-
    fact(Fact_name,Prod_list),
    is_member(Prod_name,Prod_list).
valid_prod_name(_,_):-
    write('=> Invalid Product Name Or Product not in factory'),nl,
    fail.

is_member(E, [E|_]).
is_member(E, [_|R]) :- is_member(E,R).

exists_travel(Transp_name,Fact_name_i,Fact_name_f):-
    route(Transp_name,Fact_name_i,Fact_name_f,_,_)
    ->
    write('=> Cant have same route from same transporter'),nl,
    fail
    ;
    true.

valid_transp_name(Transp_name):-
    transp(Transp_name,_).
valid_transp_name(_):-
    write('=> Transporter does not exist'),nl,
    fail.

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

%-----------------Route-----------------
save_route :- tell('route.pl'),
            listing(route),
            told.


memorize_route(route(Name,Transp_type,Fact1,Fact2,Dist)) :- assertz(route(Name,Transp_type,Fact1,Fact2,Dist)),
    save_route.
memorize_route(_) :- write('=> Invalid Data').

:- dynamic route/5.
:- consult('route.pl').
:- write('Loaded:'), listing(route).

%---------------ADD FACTORY---------------
%new_fact :- read(S),memorize_fact(S).

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
    exists_factory(Node),
    read_fact_prods_finish(Node,[]).
new_fact:-
    new_fact.

%-------------ADD PROD DESC--------------

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
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    write('Enter stock amount: '),
    single_read_numb(Stock),
    read_prods_mat_finish(Fact_name,Prod_name,Stock,[]).
add_desc:-
    add_desc.

%-------------ADD PROD STOCK-------------

add_stock(prod(Prod_name,Fact_name,Initial_stock,Mat_list),Stock):-
    New_stock is Initial_stock + Stock,
    retract(prod(Prod_name,Fact_name,Initial_stock,Mat_list)),
    memorize_prod(prod(Prod_name,Fact_name,New_stock,Mat_list)).

add_stock_menu:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    write('Enter aditional stock amount: '),
    single_read_numb(Stock),
    prod(Prod_name,Fact_name,Initial_stock,Mat_list),
    add_stock(prod(Prod_name,Fact_name,Initial_stock,Mat_list),Stock).
add_stock_menu:-
    add_stock_menu.

%---------------ADD TRANSP---------------

read_transp_type_finish(Transp_name,Transp_list):-
    write('Enter transport type (Enter stop to finish): '),
    single_read_string(Trans_type),
    process_transp_type(Transp_name,Transp_list,Trans_type).

process_transp_type(Transp_name,Transp_list,stop):-
    memorize_transp(transp(Transp_name,Transp_list)).
process_transp_type(Transp_name,Transp_list,Transp_type):-
    dif(Transp_type, stop),
    conc([],[Transp_type],Transp_temp_list1),
    write('Enter vel_med: '),
    single_read_numb(Vel),
    conc(Transp_temp_list1,[Vel],Transp_temp_list2),
    write('Enter emitions: '),
    single_read_numb(Emit),
    conc(Transp_temp_list2,[Emit],Transp_temp_list3),
    write('Enter price per Km: '),
    single_read_numb(Price),
    conc(Transp_temp_list3,[Price],Transp_temp_list4),
    conc(Transp_list,[Transp_temp_list4],Transp_list1),
    read_transp_type_finish(Transp_name,Transp_list1).

add_transp:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    exists_transp(Transp_name),
    read_transp_type_finish(Transp_name,[]).
add_transp:-
    add_transp.

%---------------ADD ROUTE---------------

add_route:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    write('Enter shipper factory name: '),
    single_read_string(Fact_name_i),
    valid_fact_name(Fact_name_i),
    write('Enter receiver factory name: '),
    single_read_string(Fact_name_f),
    valid_fact_name(Fact_name_f),
    exists_travel(Transp_name,Fact_name_i,Fact_name_f),
    write('Enter travel distance: '),
    single_read_numb(Distance),
    write('Enter price per ton: '),
    single_read_numb(Price),
    memorize_transp(transp(Transp_name,Fact_name_i,Fact_name_f,Distance,Price)).
add_route:-
    add_route.

%---------------RMV FACTORY---------------

rmv_fact:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    fact(Fact_name,Prod_list),
    retract(fact(Fact_name,Prod_list)).
rmv_fact:-
    rmv_fact.

%-------------RMV PROD DESC--------------



%-------------RMV PROD STOCK-------------



%---------------RMV TRANSP---------------

rmv_transp:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    valid_transp_name(Transp_name),
    retract(transp(Transp_name,_)),
    findall((route(Transp_name,_,_,_,_)), (route(Transp_name,_,_,_,_)), List),
    forall(member(route(Transp_name,_,_,_,_),List),(retract(route(Transp_name,_,_,_,_)))).
rmv_transp:-
    rmv_transp.

%------------------LIST REQUIRED PIECES------------------
%RF5
get_prod_reqs:-
    single_read_string(Product),
    prod(Product,_,_,Materials),
    write(Materials).

%------------------LIST FACTORIES WITH A PRODUCT------------------
%RF6
get_prod_from_fact:-
    write('Insert Product to search:'),
    single_read_string(Product),
    findall((Factory), 
        (fact(Factory, Products),
        is_member(Product,Products)), 
        List),
    nl,
    forall(member((Transport), List), 
        format('~w~n',[Transport])).

%------------------LIST TRANSPORTS BETWEEN FACTORIES------------------

get_transp_fact:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    findall((Transport,Method), 
        (route(Transport,Method,Fab1,Fab2,_)), 
        List),
    nl,
    forall(member((Transport,Method), List), 
        format('~w: ~w ~w -> ~w~n',
            [   Fab1, 
                Transport,
                Method,
                Fab2
            ])
    ).

%------------------LIST TRANSPORTS BETWEEN FACTORIES THROUGH OTHER FACTORIES------------------


get_2transp_m_facts:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    findall((Transport,Method,FabX,Transport2,Method2), 
        (route(Transport,Method,Fab1,FabX,_),
        route(Transport2,Method2,FabX,Fab2,_)), 
        List),
    nl,
    forall(member((Transport,Method,FabX,Transport2,Method2), List), 
       format('~w: ~w ~w -> ~w: ~w ~w -> ~w~n',
            [   Fab1, 
                Transport,
                Method,
                FabX,
                Transport2,
                Method2,
                Fab2
            ])
    ).


get_3transp_m_facts:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    
    findall((Transport,Method,FabX,Transport2,Method2,FabY,Transport3,Method3), 
        (route(Transport,Method,Fab1,FabX,_),
        route(Transport2,Method2,FabX,FabY,_),
        route(Transport3,Method3,FabY,Fab2,_)), 
        List),
    nl,
    forall(member((Transport,Method,FabX,Transport2,Method2,FabY,Transport3,Method3), List), 
       format('~w: ~w ~w -> ~w: ~w ~w -> ~w: ~w ~w -> ~w~n',
            [   Fab1, 
                Transport,
                Method,
                FabX,
                Transport2,
                Method2,
                FabY,
                Transport3,
                Method3,
                Fab2
            ])
    ).




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

