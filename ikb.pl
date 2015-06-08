:- module(ikb,
          [
	   iassert/2,
	   iretract/2,
	   show_kb/1
	  ]).

:- use_module(list_utils).
:- use_module(library(persistency)).

:- persistent ikb_list(assertion:list, microtheory:atom).

:- db_attach(ikb,[flush]).
:- db_sync_all(reload).

ikb_holds(Assertion,Microtheory) :-
	ikb_list(AssertionList,Microtheory),
	member(Assertion,AssertionList).

list_ikb_holds(AssertionList,Microtheory) :-
	member(Assertion,AssertionList),
	not(is_list(Assertion)),
	ikb_holds(Assertion,Microtheory).

iassert(Assertion,Microtheory) :-
	not(is_list(Assertion)),
	ikb_holds(Assertion,Microtheory),
	write('Error: already asserted '),write(Assertion),nl,
	fail.
iassert(Assertion,Microtheory) :-
	not(is_list(Assertion)),
	not(ikb_holds(Assertion,Microtheory)),
        assert_ikb_list([Assertion],Microtheory),
	write('Asserted: '),write([Assertion]),nl.

iassert(AssertionList,Microtheory) :-
	is_list(AssertionList),
	member(Assertion,AssertionList),
	not(is_list(Assertion)),
	ikb_holds(Assertion,Microtheory),
	write('Error: already asserted '),write(Assertion),nl,
	fail.
iassert(AssertionList,Microtheory) :-
	is_list(AssertionList),
	list_ikb_holds(AssertionList,Microtheory),
	write('Error: skipping assertion of list '),write(AssertionList),nl,
	!.
iassert(AssertionList,Microtheory) :-
	is_list(AssertionList),
	not(list_ikb_holds(AssertionList,Microtheory)),
        assert_ikb_list(AssertionList,Microtheory),
	write('Asserted: '),write(AssertionList),nl.

iretract(Assertion,Microtheory) :-
	not(is_list(Assertion)),
	member(Assertion,AssertionList),
	remove(AssertionList,Assertion,NewAssertionListe),
        retractall_ikb_list(AssertionList,Microtheory),
	assert_ikb_list(NewAssertionList,Microtheory).
iretract(AssertionList,Microtheory) :-
	is_list(AssertionList),
	member(Assertion,AssertionList),
	iretract(Assertion,Microtheory).

show_kb(Microtheory) :-
	write('Listing Microtheory: '),write(Microtheory),nl,fail.
show_kb(Microtheory) :-
	ikb_holds(Assertion,Microtheory),
	tab(3),write(Assertion),nl,
	fail.
show_kb(Microtheory) :-
	write('Done listing Microtheory: '),write(Microtheory),nl.
