%fact(factname, product_list).

fact(a,[pneus,pastilhas]).
fact(b,[parabrisas,janelas]).
fact(c,[jantesvw,portasvw,capovw,custombodywork]).
fact(d,[motores1300diesel,motores2000gasolina]).

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

