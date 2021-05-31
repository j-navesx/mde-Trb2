:- dynamic transp/2.

%Transportadoras
%transp(transpname, [transp_type, (Km/h)med, Emitions/Km, price/Km, Consumption]).

transp(ups, [[truck1, 90, 0.035, 0.5, 0.24]]).
transp(atlantic, [[ship1, 54, 0.85, 0.2, 23]]).
transp(dhl, [[ship2, 57, 0.88, 0.2, 26],[truck2, 85, 0.065, 0.3, 0.34]]).
transp(spedycargo, [[airbus_a380, 910, 0.35, 5.6, 21]]).
