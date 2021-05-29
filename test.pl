%fact(factname, product_list).

fact(a,[pneus,pastilhas]).
fact(b,[parabrisas,janelas]).
fact(c,[jantesvw,portasvw,capovw,custombodywork]).
fact(d,[motores1300diesel,motores2000gasolina]).
fact(hallo, [prod1, prod2, prod3]).

%prod(prod_name,factory_name,stock_units,material_list[ material_name, amount]).

prod(prod2, hallo, 100, [[rubber, 2]]).
prod(prod1, hallo, 150, [[silica, 4], [quartz, 1]]).
prod(prod3, hallo, 200, [[mat1, 10], [mat2, 20]]).
prod(pneus, a, 100, [[mat1, 10], [mat2, 20]]).

%route(transpname, transp_type, fact1, fact2, dist(Km))

route(transp2, plane1, b, c, 600).
route(transp1, ship1, a, b, 300).
route(transp2, ship2, a, b, 300).
route(transp3, truck1, a, b, 300).
route(transp3, truck1, a, d, 300).
route(transp3, truck1, d, c, 300).

%transp(transpname, [transp_type, (Km/h)med, Emitions/Km, price/Km]).

transp(transp2, [[ship2, 70, 40, 60, 10], [plane1, 250, 60, 110, 10]]).
transp(transp3, [[truck1, 90, 50, 30, 10]]).
transp(transp1, [[ship1, 90, 80, 50, 10]]).

single_read_numb(Number):-
    read_string(user_input,"\n","\r",_,Str),
    string_to_atom(Str,Atom),
    atom_number(Atom,Number).

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

menu :- 
    menu(_).

menu(Op) :- 
    nl,
    write('Gestao da base de conhecimento'), 
    nl,
    write('1 -> Adicionar'),nl,
    write('2 -> Alterar'),nl,
    write('3 -> Remover'),nl,
    write('4 -> Listagem'),nl,
    write('5 -> Exit'), nl,
    single_read_numb(Op),
    (Op >= 1, Op =< 4), %valid?
    process_main_menu(Op),
    menu(_),
    !.
menu(_).

process_main_menu(Op):-
    (Op >= 1, Op =< 4),
    exec(Op).
process_main_menu(Op):-
    (Op < 1 ; Op > 4), %not valid?
    menu(_).

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

rmv_menu(Op):-
    nl,
    write('Menu para remover cenas'), 
    nl,
    write('1 -> Remover fabricas da cadeia/rede'),nl,
    write('2 -> Remover stock numa fabrica'),nl,
    write('3 -> Remover transportadores'),nl,
    write('4 -> Remover descricao de produto'),nl,
    write('5 -> Exit'), nl,
    single_read_numb(Op1),
    Op is Op1 + 30,
    (Op >= 31, Op =< 35), %valid?
    process_rmv_menu(Op),
    rmv_menu(_),
    !.
rmv_menu(_).

process_rmv_menu(Op):-
    (Op >= 31, Op =< 35),
    exec(Op).
process_rmv_menu(Op):-
    (Op < 31 ; Op > 35), %not valid?
    rmv_menu(_).


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
exec(3) :- rmv_menu(_).
exec(4) :- fail.

%exec(1) :- add_menu(Op).
%exec(2) :- addFact.
%exec(3) :- removeFact.
%exec(4) :- removeFact.
exec(15) :- fail.

%exec(1) :- add_menu(Op).
%exec(2) :- addFact.
%exec(3) :- removeFact.
%exec(4) :- removeFact.
exec(25) :- fail.

exec(31) :- nl,write('Funciona'),nl.
%exec(2) :- addFact.
%exec(3) :- removeFact.
%exec(4) :- removeFact.
exec(35) :- fail.

/*path(FactX,FactY, [(Transp,Method,FactX,FactY,Dist)]) :- 
    route(Transp,Method,FactX,FactY,Dist).
path(FactX,FactY, [(Transp,Method,FactX,FactZ,Dist)| Rest]) :- 
    route(Transp,Method,FactX,FactZ,Dist),
    path(FactZ,FactY,Rest).

allpaths(FactX,FactY,AllPaths):-
    findall(Path,path(FactX,FactY,Path),AllPaths).*/

biDirectional_route(Transp,Method,FactX,FactY,Dist):- route(Transp,Method,FactX,FactY,Dist).
biDirectional_route(Transp,Method,FactX,FactY,Dist):- route(Transp,Method,FactY,FactX,Dist).

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


pass_fact(FactX,FactY,Facts_to_pass,Filtered_paths):- 
    findall(Path,path(FactX,FactY,Path,_,_,_,_,_),AllPaths), 
    multiple_entry_filter(AllPaths,Facts_to_pass,Filtered_paths), 
    !.

get_transp_fact:-
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
        format('Total Distance: ~w ~n',[Total_Dist])
        )
    ).

single_read_string(Atom):-
    read_string(user_input,"\n","\r",_,Str),
    string_to_atom(Str,Atom).

round(X,Y,D) :- Z is X * 10^D, round(Z, ZA), Y is ZA / 10^D.

read_mult_facts(stop,Facts_list,Final_facts_list):-
    delete(Facts_list,stop,Final_facts_list).
read_mult_facts(_,Facts_list,Final_facts_list):-
    write('Enter fact (Enter stop to finish): '),
    single_read_string(Fact_name),
    conc(Facts_list,[Fact_name],Facts_list_i),
    read_mult_facts(Fact_name,Facts_list_i,Final_facts_list).

%read_mult_facts(1,[],Final_facts_list).




minp([(Path, Distance)], Path, Distance).
minp([(Path, Distance)|Rest], Path, Distance):-
    minp(Rest,_,Min),
    Distance=< Min.
minp([(_, Distance)|Rest],Path,Min):-
    minp(Rest,Path,Min),
    Distance > Min.

get_short_path(FactX, FactY, MinPath, MinDistance):-
    findall((Path, Distance), 
    path(FactX,FactY,Path,Distance,_,_,_,_), 
    List),
    minp(List, MinPath, MinDistance),
    !.



save_dist :- tell('dist.pl'),
            listing(dist),
            told.

memorize_dist(dist(FactName,Distance)) :- 
    assertz(dist(FactName,Distance)),
    save_dist.
memorize_dist(_) :- write('=> Invalid Data').

remove_all_dist:-
    retractall(dist(_,_)),
    save_dist.

:- dynamic dist/2.
:- consult('dist.pl').
:- write('Loaded:'), listing(dist).

max([E],E).
max([E|R],E):-
    max(R,M),
    E >= M.
max([E|R],M):-
    max(R,M),
    E < M.

get_all_distances:-
    findall((FactName),fact(FactName,_),FactNames),
    add_distance(FactNames,FactNames,FactNames,_,0,_,Result),
    nl,
    write(Result),
    nl.
    /* forall(member((FName),FactNames),
        (forall(member((FName2),FactNames),
            (findall((MD),get_short_path(FName,FName2,_,MD),List),
            write(List)
            )
        ),
        nl
        )
    ). */
get_fact_number(Number_Facts):-
    findall(Fact_name,fact(Fact_name,_),Facts_List),
    length(Facts_List, Number_Facts).

add_distance(_,_,_,_,_,_,Result):-
    !.
add_distance(_,[],_,_,_,Centralized,Result):-
    max(Centralized, Result),
    write(Centralized),nl,
    write(Result),nl,
    add_distance(_,_,_,_,_,_,Result),
    !.
add_distance(OriginalFacts,[_|Rest1],[],TotalDistance,StepDistance,Centralized,_):-
    TotalDistance is StepDistance,
    get_fact_number(N),
    Central is (N-1)/(TotalDistance),
    conc(Centralized,[Central],Centralized1),
    add_distance(OriginalFacts,Rest1,OriginalFacts,_,0,Centralized1,_),
    !.
add_distance(OriginalFacts,[CurrentFact1|Rest1],[CurrentFact2|Rest2],_,StepDistance,Centralized,_):-
    findall((MD),get_short_path(CurrentFact1,CurrentFact2,_,MD),List),
    (([MinDist] = List);(not(member(_,List)),MinDist is 0)),
    NewDistance is StepDistance + MinDist,
    add_distance(OriginalFacts,[CurrentFact1|Rest1],Rest2,_,NewDistance,Centralized,_),
    !.

find_centrality:-
    % Quantas fabricas existem Number_Facts
    % Lista de fabricas
    get_fact_number_and_list(Facts_List,Number_Facts),
    % Listar o sumatorio das dist minimas de uma fab X para o resto Min_Dists_list is [[Fact_name, Sum_Min_Dists],[Fact_name, Sum_Min_Dists],...]
    sum_min_distance( Facts_List, Facts_List, Facts_List, 0, _, Min_Dists_list),
    % Converter para Centrality_list is [[Fact_name, (Number_Facts - 1)/Sum_Min_Dists],[Fact_name, (Number_Facts - 1)/Sum_Min_Dists],...]
    calc_centralized_value(Min_Dists_list,Number_Facts,_,Centralized_value_list),
    % Encontrar fábrica com o valor maior
    max_centralized_value(Centralized_value_list,Centralized_value,Centralized_Fact_name),
    format('~w: value: ~w ~n', [Centralized_Fact_name, Centralized_value]),
    !.

get_fact_number_and_list(Facts_List,Number_Facts):-
    findall(Fact_name,fact(Fact_name,_),Facts_List),
    length(Facts_List, Number_Facts).

sum_min_distance(_,[],_,_,Final_Min_Dists_list,Final_Min_Dists_list).
sum_min_distance( Original_Facts_List, [CurrentFact1|Rest1], [], Current_fact_Min_dist_Sum, Min_Dists_list, Final_Min_Dists_list):-
    conc(Min_Dists_list,[[CurrentFact1,Current_fact_Min_dist_Sum]],Min_Dists_list_i),
    sum_min_distance(Original_Facts_List, Rest1, Original_Facts_List, 0, Min_Dists_list_i, Final_Min_Dists_list),
    !.
sum_min_distance( Original_Facts_List, [CurrentFact1|Rest1], [CurrentFact2|Rest2], Current_fact_Min_dist_Sum, Min_Dists_list, Final_Min_Dists_list):-
    findall((MD),get_short_path(CurrentFact1, CurrentFact2, _, MD),List),
    (([Step_Min_Distance] = List);(not(member(_,List)),Step_Min_Distance is 0)),
    Current_fact_Min_dist_Sum_i is Current_fact_Min_dist_Sum + Step_Min_Distance,
    sum_min_distance( Original_Facts_List, [CurrentFact1|Rest1], Rest2, Current_fact_Min_dist_Sum_i, Min_Dists_list, Final_Min_Dists_list),
    !.

calc_centralized_value([],_,Final_Centralized_value_list,Final_Centralized_value_list).
calc_centralized_value([[Fact_name,Sum_Min_Dists]|Rest],Number_Facts,Centralized_value_list,Final_Centralized_value_list):-
    ((Sum_Min_Dists is 0 , Centralized_value is 0);Centralized_value is (Number_Facts-1)/(Sum_Min_Dists)),
    conc(Centralized_value_list,[[Fact_name,Centralized_value]],Centralized_value_list_i),
    calc_centralized_value(Rest,Number_Facts,Centralized_value_list_i,Final_Centralized_value_list),
    !.

max_centralized_value([[Centralized_Fact_name,Centralized_value]],Centralized_value,Centralized_Fact_name).
max_centralized_value([[Centralized_Fact_name,Centralized_value]|Rest],Centralized_value,Centralized_Fact_name):-
    max_centralized_value(Rest,Max_Centralized_value,_),
    Centralized_value >= Max_Centralized_value.
max_centralized_value([[_,Centralized_value]|Rest],Max_Centralized_value,Centralized_Fact_name):-
    max_centralized_value(Rest,Max_Centralized_value,Centralized_Fact_name),
    Centralized_value < Max_Centralized_value.

% test sum_min_distance( [a,b,c,hallo], [a,b,c,hallo], [a,b,c,hallo], 0, _, Final_Min_Dists_list).

% test calc_centralized_value([[a, 900], [b, 900], [c, 1200], [hallo, 0]],3,_,Centralized_value_list).

% test max_centralized_value([[a, 0.0022222222222222222], [b, 0.0022222222222222222], [c, 0.0016666666666666668], [hallo, 0]],Centralized_value,Centralized_Fact_name).


