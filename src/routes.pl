:- module(routes, [server/1]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_json)).
:- use_module(components).
:- use_module(juguetes). 


server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Rutas
:- http_handler(root(.), inicio_handler, []).
:- http_handler(root(carrera), carrera, []).
:- http_handler(root(solCarrera), solAutomatica, []).
:- http_handler(root(validarPaso), validar_paso_handler, [method(post)]).
:- http_handler('/reiniciarJuego', reiniciar_juego_handler, []).
:- http_handler('/assets/', serve_files_in('assets'), [prefix]).
:- http_handler('/css/', serve_files_in('css'), [prefix]).
:- http_handler('/html/', serve_files_in('html'), [prefix]).
:- http_handler('/js/', serve_files_in('js'), [prefix]).

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


solAutomatica(_Request) :-
    movesJuguetes(Sol),
    phrase(mostrar_movimientos(Sol), HTMLTokens),
    print_html(HTMLTokens).
    


validar_paso_handler(Request) :-
    http_read_json_dict(Request, Dict),
    
    maplist(atom_string, LadoInicial, Dict.ladoInicial),
    maplist(atom_string, LadoFinal, Dict.ladoFinal),
    maplist(atom_string, Seleccionados, Dict.seleccionados),

    % Mapear linterna a ida/vuelta según valor recibido
    ( Dict.linterna = "izquierda" -> LinternaAtom = ida
    ; Dict.linterna = "derecha"  -> LinternaAtom = vuelta
    ; atom_string(LinternaAtom, Dict.linterna)  % Por si ya es ida/vuelta
    ),

    TiempoActual = Dict.tiempoActual,

    ( validar_paso(LadoInicial, LadoFinal, Seleccionados, LinternaAtom, TiempoActual,
                   TiempoNuevo, NuevoLadoInicial, NuevoLadoFinal)
    -> reply_json_dict(_{
           ok: true,
           nuevoLadoInicial: NuevoLadoInicial,
           nuevoLadoFinal: NuevoLadoFinal,
           tiempoNuevo: TiempoNuevo
       })
    ; reply_json_dict(_{ ok: false, error: "Paso inválido o tiempo excedido" }, [status(400)])
    ).


reiniciar_juego_handler(_Request) :-
    % no hacés nada porque no hay estado global, solo devolvés ok
    reply_json_dict(_{exito: true}).
