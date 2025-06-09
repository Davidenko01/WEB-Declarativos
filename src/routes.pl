:- module(routes, [server/1]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(components).
:- use_module(juguetes). 

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Rutas
:- http_handler(root(.), inicio_handler, []).
:- http_handler(root(carrera), carrera, []).
:- http_handler('/assets/', serve_files_in('assets'), [prefix]).
:- http_handler('/css/', serve_files_in('css'), [prefix]).
:- http_handler('/html/', serve_files_in('html'), [prefix]).

serve_files_in(Dir, Request) :-
    http_reply_from_files(Dir, [], Request).

inicio_handler(_Request) :-
    reply_html_page(
        [ 
          title('Toy Story - Escape de Zurg'),
          meta([name='viewport', content='width=device-width, initial-scale=1.0']),
          meta([charset='UTF-8']),
          link([rel='stylesheet', href='/css/styles.css'])
        ],
        [ 
          \pagina_inicio
        ]
    ).

carrera(_Request) :-
  reply_html_page(
        [ 
          title('Toy Story - Escape de Zurg'),
          meta([name='viewport', content='width=device-width, initial-scale=1.0']),
          meta([charset='UTF-8']),
          link([rel='stylesheet', href='/css/styles.css'])
        ],
        [ 
          \pagina_carrera
        ]
    ).
