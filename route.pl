:- dynamic route/5.

%route(transpname, transp_type, fact1, fact2, dist(Km))

route(transp1, ship1, a, b, 500).
route(transp2, ship2, a, b, 500).
route(transp2, plane1, b, c, 600).
route(transp1, truck1, c, d, 400).
route(transp3, ship1, a, b, 500).
route(transp3, ship2, a, b, 500).