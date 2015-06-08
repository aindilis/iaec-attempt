:- use_module(ikb,[iassert]).

populate_kb :-
	ikb:iassert([isa(andrewDougherty,aiResearcher)],baseMt).

show_kb(Microtheory) :-
	ikb:show_kb(Microtheory).
