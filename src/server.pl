:- use_module(routes).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_header)).

:- initialization(start_server).

start_server :-
    server(8000).

%detener server y limpiar base de datos
detener_server :- http_stop_server(8000,[]).