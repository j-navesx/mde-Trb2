%---------------FACTORY---------------
save_facts :- tell('facts.pl'),
            listing(fact),
            told.

memorize_fact(fact(Node,Prod)) :- assertz(fact(Node,Prod)),
                    nl,
                    listing(fact),
                    save_facts.

:- dynamic fact/2.
:- consult('facts.pl').
:- write('Loaded:'), listing(fact).

%---------------TRANSPORT---------------
save_transps :- tell('transps.pl'),
            listing(transp),
            told.

memorize_transp(transp(Name,Fact1,Fact2,Dist,Cost)) :- assertz(transp(Name,Fact1,Fact2,Dist,Cost)),
                    nl,
                    listing(transp),
                    save_transps.

:- dynamic transp/5.
:- consult('transps.pl').
:- write('Loaded:'), listing(transp).

%---------------ADD FACTORY---------------
new_fact :- read(S),memorize_fact(S).



memorize_fact(_) :- write('=> Invalid Data').
memorize_transp(_) :- write('=> Invalid Data').