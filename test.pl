dist(a,b,50).
dist(a,c,30).
dist(b,d,60).
dist(c,b,20).
dist(c,d,25).
dist(c,e,40).

distance(X,Y,D) :- dist(X,Y,D).
distance(X,Y,D) :- dist(X,Z,D1), distance(Z,Y, D2), D is D1 + D2.
