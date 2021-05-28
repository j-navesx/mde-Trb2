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
    fact(Fact_name,_),
    !.
valid_fact_name(_):-
    write('=> Invalid Factory Name'),nl,
    fail.

valid_prod_name(Fact_name,Prod_name):-
    fact(Fact_name,Prod_list),
    is_member(Prod_name,Prod_list),
    !.
valid_prod_name(_,_):-
    write('=> Invalid Product Name Or Product not in factory'),nl,
    fail.

is_member(E, [E|_]).
is_member(E, [_|R]) :- is_member(E,R).

exists_route(Transp_name,Transp_type,Fact_name_i,Fact_name_f):-
    route(Transp_name,Transp_type,Fact_name_i,Fact_name_f,_)
    ->
    write('=> Cant have same route from same transporter'),nl,
    fail
    ;
    true.

valid_transp_name(Transp_name):-
    transp(Transp_name,_),
    !.
valid_transp_name(_):-
    write('=> Transporter does not exist'),nl,
    fail.

valid_route(Transp_name,Transp_type,Fact_name_i,Fact_name_f):-
    route(Transp_name,Transp_type,Fact_name_i,Fact_name_f,_),
    !.
valid_route(_):-
    write('=> Route invalid'),nl,
    fail.

fail_if_member(List,Element):-
    is_member(Element,List)
    -> 
    write('=> Element already in list'),nl,
    fail
    ;
    true.

is_method_Registered(Transp_name,Method):-
    transp(Transp_name,Method_list),
    member(([Method,_,_,_,_]),Method_list),
    !.
is_method_Registered(_):-
    write('=> Method Not Registered'),nl,
    fail.

round(X,Y,D):- 
    Z is X * 10^D, 
    round(Z, ZA), 
    Y is ZA / 10^D.

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

% BiDirectional Routing

biDirectional_route(Transp,Method,FactX,FactY,Dist):- route(Transp,Method,FactX,FactY,Dist).
biDirectional_route(Transp,Method,FactX,FactY,Dist):- route(Transp,Method,FactY,FactX,Dist).

% Pathing

passed([(_,_,Fact,_,_)|_], Fact).
passed([(_,_,_,Fact,_)|_], Fact).
passed([_|Rest], Fact) :- passed(Rest, Fact).

add_no_repetition(Path, (Transp,Method,Fact1,Fact2,Dist), Pathi) :- 
    not(passed(Path, Fact2)), 
    conc(Path,[(Transp,Method,Fact1,Fact2,Dist)],Pathi).

step_no_repetition(FactX, FactY, Current_Path, TotalPath,
    PathDist, PathTime, PathEmitions, PathPrice, PathConsumption,
    Total_Dist, Total_Time, Total_Emitions, Total_Price, Total_Consumption) :- 
    biDirectional_route(Transp,Method,FactX,FactY,Dist), 
    transp(Transp,Method_list),
    member(([Method,Velocity,Emitions,Price,Consumption]),Method_list),
    round((Dist/Velocity),StepTime,2),
    StepEmitions is (Emitions*Dist),
    StepPrice is (Price*Dist),
    StepConsuption is (Consumption*Dist),
    add_no_repetition(Current_Path, (Transp,Method,FactX, FactY, Dist, StepTime),TotalPath), 
    Total_Dist is PathDist + Dist,
    round((PathTime + StepTime),Total_Time,2),
    Total_Emitions is PathEmitions + StepEmitions,
    Total_Price is PathPrice + StepPrice,
    Total_Consumption is PathConsumption + StepConsuption.
step_no_repetition(FactX, FactY, Current_Path, TotalPath, 
    PathDist, PathTime, PathEmitions, PathPrice, PathConsumption, 
    Total_Dist, Total_Time, Total_Emitions, Total_Price, Total_Consumption) :- 
    biDirectional_route(Transp,Method,FactX,FactZ,Dist), 
    transp(Transp,Method_list),
    member(([Method,Velocity,Emitions,Price,Consumption]),Method_list),
    round((Dist/Velocity),StepTime,2),
    StepEmitions is (Emitions*Dist),
    StepPrice is (Price*Dist),
    StepConsuption is (Consumption*Dist),
    add_no_repetition(Current_Path, (Transp,Method,FactX, FactZ, Dist, StepTime),Pathi), 
    Disti is PathDist + Dist,
    round((PathTime + StepTime),Timei,2),
    Emitionsi is PathEmitions + StepEmitions,
    Pricei is PathPrice + StepPrice,
    Consumptioni is PathConsumption + StepConsuption,
    step_no_repetition(FactZ, FactY, Pathi, TotalPath, 
        Disti, Timei, Emitionsi, Pricei, Consumptioni, 
        Total_Dist, Total_Time, Total_Emitions, Total_Price, Total_Consumption).

path(Fact1,Fact2,TotalPath,Total_Dist,Total_Time, Total_Emitions, Total_Price, Total_Consumption):- 
    step_no_repetition(Fact1, Fact2, [], TotalPath, 0, 0, 0, 0, 0, Total_Dist, Total_Time, Total_Emitions, Total_Price, Total_Consumption).

filter([],_,[]).
filter([Path|Rest1],Fact,[Path|Rest2]):-
    passed(Path,Fact),
    filter(Rest1,Fact,Rest2).
filter([_|Rest1],Fact,Rest2):- 
    filter(Rest1,Fact,Rest2).

multiple_entry_filter(_,[],_).
multiple_entry_filter(AllPaths,[Current_Fact|Rest_Fact],Filtered_paths):-
    filter(AllPaths,Current_Fact,Filtered_paths),
    multiple_entry_filter(Filtered_paths,Rest_Fact,Filtered_paths).

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
    write('Enter necessary material amount: '),
    single_read_numb(Amount),
    conc([Mat],[Amount],Mat_tuple),
    conc(Mat_list,[Mat_tuple],Mat_list1),
    read_prods_mat_finish(Fact_name,Prod_name,Stock,Mat_list1).

add_prod_desc:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    write('Enter stock amount: '),
    single_read_numb(Stock),
    read_prods_mat_finish(Fact_name,Prod_name,Stock,[]).
add_prod_desc:-
    add_prod_desc.

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
    write('Enter Comsumption per Km: '),
    single_read_numb(Comsumption),
    conc(Transp_temp_list4,[Comsumption],Transp_temp_list5),
    conc(Transp_list,[Transp_temp_list5],Transp_list1),
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
    write('Enter transport method name: '),
    single_read_string(Transp_type),
    is_method_Registered(Transp_name,Transp_type),
    write('Enter shipper factory name: '),
    single_read_string(Fact_name_i),
    valid_fact_name(Fact_name_i),
    write('Enter receiver factory name: '),
    single_read_string(Fact_name_f),
    valid_fact_name(Fact_name_f),
    exists_route(Transp_name,Transp_type,Fact_name_i,Fact_name_f),
    write('Enter travel distance: '),
    single_read_numb(Distance),
    memorize_route(route(Transp_name,Transp_type,Fact_name_i,Fact_name_f,Distance)).
add_route:-
    add_route.

%---------------RMV FACTORY---------------

rmv_fact:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    fact(Fact_name,Prod_list),
    retract(fact(Fact_name,Prod_list)),
    ((findall((route(_,_,Fact_name,_,_)), (route(_,_,Fact_name,_,_)), List1),
    forall(member(route(_,_,Fact_name,_,_),List1),(retract(route(_,_,Fact_name,_,_)))));true),
    ((findall((route(_,_,_,Fact_name,_)), (route(_,_,_,Fact_name,_)), List2),
    forall(member(route(_,_,_,Fact_name,_),List2),(retract(route(_,_,_,Fact_name,_)))));true),
    ((findall((prod(_,Fact_name,_,_)), (prod(_,Fact_name,_,_)), List3),
    forall(member(prod(_,Fact_name,_,_),List3),(retract(prod(_,Fact_name,_,_)))));true).
rmv_fact:-
    rmv_fact.

%-------------RMV PROD DESC--------------

rmv_prod_desc:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    retract(prod(Prod_name,Fact_name,_,_)).
rmv_prod_desc:-
    rmv_prod_desc.

%-------------RMV PROD STOCK-------------

subtract_stock(prod(Prod_name,Fact_name,Initial_stock,Mat_list),Stock):-
    New_stock is Initial_stock - Stock,
    retract(prod(Prod_name,Fact_name,Initial_stock,Mat_list)),
    memorize_prod(prod(Prod_name,Fact_name,New_stock,Mat_list)).

subtract_stock_menu:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    write('Enter stock amount to remove: '),
    single_read_numb(Stock),
    prod(Prod_name,Fact_name,Initial_stock,Mat_list),
    subtract_stock(prod(Prod_name,Fact_name,Initial_stock,Mat_list),Stock).
subtract_stock_menu:-
    subtract_stock_menu.

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

%---------------RMV ROUTE---------------

rmv_route:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    write('Enter transport method name: '),
    single_read_string(Transp_type),
    write('Enter shipper factory name: '),
    single_read_string(Fact_name_i),
    valid_fact_name(Fact_name_i),
    write('Enter receiver factory name: '),
    single_read_string(Fact_name_f),
    valid_fact_name(Fact_name_f),
    valid_route(Transp_name,Transp_type,Fact_name_i,Fact_name_f),
    retract(route(Transp_name,Transp_type,Fact_name_i,Fact_name_f,_)).
rmv_route:-
    rmv_route.

%---------------ALTER FACTORY---------------

alter_fact(Fact_name,New_Prod_List):-
    retract(fact(Fact_name,_)),
    memorize_fact(fact(Fact_name,New_Prod_List)).

process_option_AF(Fact_name, Prod_list, 1):-
    write('Enter new product name: '),
    single_read_string(New_Prod),
    conc(Prod_list, [New_Prod], New_Prod_List),
    alter_fact(Fact_name,New_Prod_List).

process_option_AF(Fact_name, Prod_list, 2):-
    write('Enter product name to remove: '),
    single_read_string(Rmv_Prod),
    valid_prod_name(Fact_name,Rmv_Prod),
    delete(Prod_list,Rmv_Prod,New_Prod_List),
    alter_fact(Fact_name,New_Prod_List).

alter_fact_menu:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('1 -> Add factory product'),nl,
    write('2 -> Remove factory product'),nl,
    readoption(OP),
    fact(Fact_name,Prod_list),
    process_option_AF(Fact_name, Prod_list, OP).
alter_fact_menu:-
    alter_fact_menu.

%-------------ALTER PROD DESC--------------

alter_prod(Prod_name,Fact_name,Stock,Mat_list,New_Mat_list):-
    retract(prod(Prod_name,Fact_name,Stock,Mat_list)),
    memorize_prod(prod(Prod_name,Fact_name,Stock,New_Mat_list)).

process_option_APD(Prod_name,Fact_name,Stock,Mat_list, 1):-
    write('Enter new material name: '),
    single_read_string(New_mat),
    write('Enter necessary material amount: '),
    single_read_numb(Amount),
    conc([New_mat],[Amount],Mat_tuple),
    conc(Mat_list,[Mat_tuple],New_Mat_list),
    alter_prod(Prod_name,Fact_name,Stock,Mat_list,New_Mat_list).

process_option_APD(Prod_name,Fact_name,Stock,Mat_list, 2):-
    write('Enter material name to remove: '),
    single_read_string(Rmv_Mat),
    is_member(Mat_list,[Rmv_Mat,_]),
    delete(Mat_list,[Rmv_Mat,_],New_Mat_list),
    alter_prod(Prod_name,Fact_name,Stock,Mat_list,New_Mat_list).

alter_prod_menu:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    write('1 -> Add product material'),nl,
    write('2 -> Remove product material'),nl,
    readoption(OP),
    prod(Prod_name,Fact_name,Stock,Mat_list),
    process_option_APD(Prod_name,Fact_name,Stock,Mat_list,OP).
alter_prod_menu:-
    alter_prod_menu.

%-------------ALTER PROD STOCK-------------

alter_stock(Prod_name,Fact_name,New_stock,Mat_list):-
    retract(prod(Prod_name,Fact_name,_,Mat_list)),
    memorize_prod(prod(Prod_name,Fact_name,New_stock,Mat_list)).

alter_stock_menu:-
    write('Enter factory name: '),
    single_read_string(Fact_name),
    valid_fact_name(Fact_name),
    write('Enter product name: '),
    single_read_string(Prod_name),
    valid_prod_name(Fact_name,Prod_name),
    write('Enter new stock value: '),
    single_read_numb(New_stock),
    prod(Prod_name,Fact_name,_,Mat_list),
    alter_stock(Prod_name,Fact_name,New_stock,Mat_list).
alter_stock_menu:-
    alter_prod_menu.

%---------------ALTER TRANSP---------------

alter_transp(Transp_name,New_Transp_list):-
    retract(transp(Transp_name,_)),
    memorize_transp(transp(Transp_name,New_Transp_list)).

process_option_AT(Transp_name,Transp_list,1):-
    write('Enter new transport method name: '),
    single_read_string(Method),
    fail_if_member(Transp_list,[Method,_,_,_]),
    write('Enter average transport speed: '),
    single_read_numb(Speed),
    write('Enter average transport emitions: '),
    single_read_numb(Emitions),
    write('Enter transport price: '),
    single_read_numb(Price),
    write('Enter transport Consumption: '),
    single_read_numb(Consumption),
    conc(Transp_list,[[Method,Speed,Emitions,Price,Consumption]],New_Transp_list),
    alter_transp(Transp_name,New_Transp_list).

process_option_AT(Transp_name,Transp_list,2):-
    write('Enter transport method name to remove: '),
    single_read_string(Rmv_Method),
    is_member(Transp_list,[Rmv_Method,_,_,_]),
    delete(Transp_list,[Rmv_Method,_,_,_],New_Transp_list),
    alter_transp(Transp_name,New_Transp_list).

alter_transp_menu:-
    write('Enter transporter name: '),
    single_read_string(Transp_name),
    valid_transp_name(Transp_name),
    write('1 -> Add new transport method'),nl,
    write('2 -> Remove existing transport method'),nl,
    readoption(OP),
    transp(Transp_name,Transp_list),
    process_option_AT(Transp_name,Transp_list,OP).
alter_transp_menu:-
    alter_transp_menu.

%---------------ALTER ROUTE---------------

alter_route(Transp_name, Transp_method, Fact1, Fact2, New_Dist):-
    retract(route(Transp_name, Transp_method, Fact1, Fact2, _ )),
    memorize_route(route(Transp_name, Transp_method, Fact1, Fact2, New_Dist)).

alter_route_menu:-
    write('Enter shipper factory name: '),
    single_read_string(Fact1),
    valid_fact_name(Fact1),
    write('Enter receiver factory name: '),
    single_read_string(Fact2),
    valid_fact_name(Fact2),
    write('Enter new distance value: '),
    single_read_numb(New_Dist),
    findall((route(_, _, Fact1, Fact2, _)), (route(_, _, Fact1, Fact2, _)), List),
    forall(member(route(Transp_name, Transp_method, Fact1, Fact2, _),List),(alter_route(Transp_name, Transp_method, Fact1, Fact2, New_Dist))).
alter_route_menu:-
    alter_route_menu.

%------------------LIST REQUIRED PIECES------------------
%RF5
get_prod_reqs:-
    single_read_string(Product),

    findall((Materials),
    prod(Product,_,_,Materials),
    List),
    
    forall((member((Materials), List)), 
        (forall((member((Material), Materials)),
                (   [Name, Quantity] = Material,
                    format('~w: ~w~n',[Name, Quantity])
                )
            )
        )
    ).
    

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
    findall((Path), 
        (path(Fab1,Fab2,Path,_,_,_,_,_)), 
        List),
    nl,
    forall(member((Path), List),
        (format('Route:~n'),
        forall(member((Transport,Method,FabX,FabY,_), Path), 
            (format('~w: ~w ~w -> ~w ',
                [   FabX,
                    Transport,
                    Method,
                    FabY
                ])
            )
        ),
        nl
        )
    ).

%------------------LIST TRANSPORTS BETWEEN FACTORIES WITH INFO------------------

get_transp_fact_info:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    findall((Path,Total_Dist), 
        (path(Fab1,Fab2,Path,Total_Dist,_,_,_,_)), 
        List),
    nl,
    forall(member((Path,Total_Dist), List),
        (format('Route:~n'),
        forall(member((Transport,Method,FabX,FabY,_), Path), 
            (format('~w: ~w ~w -> ~w ',
                [   FabX,
                    Transport,
                    Method,
                    FabY
                ])
            )
        ),
        format('Total Distance: ~w ~n',[Total_Dist]),
        nl
        )
    ).

%------------------LIST TRANSPORTS BETWEEN FACTORIES THROUGH OTHER FACTORIES------------------
%RF9

read_mult_facts(stop,Facts_list,Final_facts_list):-
    delete(Facts_list,stop,Final_facts_list).
read_mult_facts(_,Facts_list,Final_facts_list):-
    write('Enter fact (Enter stop to finish): '),
    single_read_string(Fact_name),
    conc(Facts_list,[Fact_name],Facts_list_i),
    read_mult_facts(Fact_name,Facts_list_i,Final_facts_list).

pass_fact(FactX,FactY,Facts_to_pass_list,Filtered_Paths):- 
    findall((Path),path(FactX,FactY,Path,_,_,_,_,_),AllPaths), 
    multiple_entry_filter(AllPaths,Facts_to_pass_list,Filtered_Paths), 
    !.

get_transp_pass_fact:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    write('Input Factories to Pass Through '),
    read_mult_facts(1,[],Facts_to_pass_list),
    pass_fact(Fab1,Fab2,Facts_to_pass_list,Filtered_Paths), 
    nl,
    forall(member((Paths), Filtered_Paths),
        (format('Route:~n'),
        forall(member((Transport,Method,FabX,FabY,_), Paths), 
            (format('~w: ~w ~w -> ~w ',
                [   FabX,
                    Transport,
                    Method,
                    FabY
                ])
            )
        ),
        format('Total Distance: ~w ~n',[Total_Dist])
        )
    ),
    !.

%------------------GET MINIMUM TRANSPORT TO FACTORY------------------
%RF10

minp([(Path, Distance)], Path, Distance).
minp([(Path, Distance)|Rest], Path, Distance):-
    minp(Rest,_,Min),
    Distance=< Min.
minp([(Path, Distance)|Rest],Min):-
    minp(Rest,Path,Min),
    Distance > Min.

get_short_path(FactX, FactY, MinPath, MinDistance):-
    findall((Path, Distance), 
    path(FactX,FactY,Path,Distance,_,_,_,_), 
    List),
    minp(List, MinPath, MinDistance),
    !.

get_shortest_path:-
    write('Start point:'),
    single_read_string(Fab1),
    write('End point:'),
    single_read_string(Fab2),
    get_short_path(Fab1,Fab2,MinPath,MinDistance),
    nl,
    format('Route:~n'),
    forall(member((Transport,Method,FabX,FabY,_), MinPath), 
        (format('~w: ~w ~w -> ~w ',
            [   FabX,
                Transport,
                Method,
                FabY
            ])
        )
    ),
    format('Total Distance: ~w ~n',[MinDistance]).

%------------------LIST TRANSPORTS BETWEEN FACTORIES THROUGH OTHER FACTORIES WITH PRODUCT------------------
%RF11

pass_fact_with_prod(_,_,[],_).
pass_fact_with_prod(FactX,FactY,[Current_Product|Rest_Products],Filtered_paths):-
    findall(Path,path(FactX,FactY,Path,_,_,_,_,_),AllPaths),
    findall((Factory), (fact(Factory, Products), is_member(Current_Product,Products)), Facts_to_pass_list),
    multiple_entry_filter(AllPaths,Facts_to_pass_list,Filtered_paths), 
    pass_fact_with_prod(FactX,FactY,Rest_Products,Filtered_paths),
    !.

%------------------LIST TRANSPORTS BETWEEN FACTORIES THROUGH OTHER FACTORIES WITH PRODUCT materials------------------
%RF12

extract_material_name_from_product_desc([],Final_Materials_list,Final_Materials_list).
extract_material_name_from_product_desc([[Current_Material,_]|Rest_Materials],Current_Materials_list,Final_Materials_list):-
    conc(Current_Materials_list,[Current_Material],Materials_list_i),
    extract_material_name_from_product_desc(Rest_Materials,Materials_list_i,Final_Materials_list).

process_materials_list(_,[],Final_Path_list,Final_Path_list).
process_materials_list(Receiver_Fact,[Current_material|Rest_materials],Current_Path_list,Final_Path_list):-
    findall((Factory), (fact(Factory, Products), is_member(Current_material,Products)), Shipper_Facts_list),
    paths_from_Fact_list(Shipper_Facts_list,Receiver_Fact,[],All_Paths_to_fact),
    conc([Current_material],All_Paths_to_fact,All_Paths_to_fact_i),
    conc(Current_Path_list,[All_Paths_to_fact_i],Path_list_i),
    process_materials_list(Receiver_Fact,Rest_materials,Path_list_i,Final_Path_list).

paths_from_Fact_list([],_,Final_Path_list,Final_Path_list).
paths_from_Fact_list([Shipper_Fact|Rest_Facts],Receiver_Fact,Current_Path_list,Final_Path_list):-
    findall(Path,path(Shipper_Fact,Receiver_Fact,Path,_,_,_,_,_),AllPaths_to_fact),
    conc(Current_Path_list,AllPaths_to_fact,AllPaths_i),
    paths_from_Fact_list(Rest_Facts,Receiver_Fact,AllPaths_i,Final_Path_list).

pass_fact_with_prod_materials(Fact,Product,Final_Path_list):-
    prod(Product,Fact,_,Product_desc_list),
    extract_material_name_from_product_desc(Product_desc_list,[],Materials_list),
    process_materials_list(Fact,Materials_list,[],Final_Path_list), 
    !.

%------------------MENU------------------

readoption(O):-
    get_single_char(C),
    put_code(C),
    number_codes(O,[C]), 
    valid(O),
    nl,
    !.
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
exec(14) :- 
    add_route,
    menu_add.
exec(15) :- 
    add_prod_desc,
    menu_add.
exec(16) :- menu_1.

exec(21) :- 
    alter_fact_menu,
    menu_alter.
exec(22) :- 
    alter_stock_menu,
    menu_alter.
exec(23) :-
    alter_transp_menu,
    menu_alter.
exec(24) :-
    alter_route_menu,
    menu_alter.
exec(25) :-
    alter_prod_menu,
    menu_alter.
exec(26) :- menu_1.

exec(31) :- 
    rmv_fact,
    menu_rmv.
exec(32) :- 
    subtract_stock_menu,
    menu_rmv.
exec(33) :- 
    rmv_transp,
    menu_rmv.
exec(34) :- 
    rmv_route,
    menu_rmv.
exec(35) :- 
    rmv_prod_desc,
    menu_rmv.
exec(36) :- menu_1.

