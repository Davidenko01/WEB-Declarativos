:- use_module(routes).

:- initialization(start_server).

start_server :-
    server(8000).
