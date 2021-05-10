%fact(factname, product_list).

fact(a,[pneus,pastilhas]).
fact(b,[parabrisas,janelas]).
fact(c,[jantesvw,portasvw,capovw,custombodywork]).
fact(d,[motores1300diesel,motores2000gasolina]).

%prod().



%transp(transpname, fact1, fact2, dist, cost).

transp(transp1, a, b, 50, 0.1).
transp(transp2, b, c, 20, 0.2).

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------

conc([], L, L).
conc([C|R], L, [C|T]) :- conc(R, L, T). 

