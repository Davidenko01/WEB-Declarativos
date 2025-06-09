:- module(components, [
    pagina_inicio//0,
    pagina_carrera//0,
    personaje_card//5,
    mostrar_movimientos//1
]).

:- use_module(library(http/html_write)).
:- use_module(juguetes).  % Asegurate de tener definidos los personajes en juguetes.pl

% Página de inicio con las tarjetas de personajes
pagina_inicio -->
    {
        maplist(format_image_path,
                ['buzz.png','woody.png','rex.png','hamm.png'],
                [BuzzPath, WoodyPath, RexPath, HammPath])
    },
    html(
        div([class='container'],
            [ h1([class='title'], 'ESCAPA POR EL PUENTE!'),
              p([class='description'],
                'ESCAPA DE ZURG! CUIDADO, EL PUENTE ES OSCURO Y MUY DÉBIL'),
              h2([class='subtitle'], 'JUGUETES DE ANDY:'),
              div([class='characters-container'],
                  [ \personaje_card('woody', WoodyPath, 'woody-color', 'EL SHERIFF', '10 minutos'),
                    \personaje_card('buzz', BuzzPath, 'buzz-color', 'EL GUARDIÁN DEL ESPACIO', '5 minutos'),
                    \personaje_card('hamm', HammPath, 'hamm-color', 'ALGO ANDA MAL...', '25 minutos'),
                    \personaje_card('rex', RexPath, 'rex-color', 'EL T-REX', '20 minutos')
                  ]),
              div([style='margin-top: 45px;'],
                  a([href='/carrera', class='button'], 'JUGAR'))
            ])
    ).

% Página de cruce del puente
pagina_carrera -->
    html(
        div([class='container'],
            [ h1([class='title'], 'Problema del Cruce del Puente'),
              div([class='top-bar'],
                  [ p([], [strong('Tiempo usado: '), span([id=time], '0'), '/60 minutos']),
                    div([class='actions'],
                        [ button([id='solucion', onclick="resolver()"], 'Solucion automatica'),
                          button([onclick="reiniciar()"], 'Reiniciar')
                        ])
                  ]),
              div([class='content'],
                  [ div([class='side'],
                        [ h2([], ['Lado Inicial ', span([id='linterna'], 'Linterna')]),
                          \lista_personajes(inicial)
                        ]),
                    div([class='center'],
                        [ div([class='bridge'], 'PUENTE'),
                          button([id='cruzar', onclick="cruzarSeleccionados()"], 'Cruzar hacia la derecha'),
                          p([class='note'], 'Selecciona 1 o 2 personajes para cruzar')
                        ]),
                    div([class='side'],
                        [ h2([], 'Lado Final'),
                          \lista_personajes(final)
                        ])
                  ])
            ])
    ).

% Lista de personajes
lista_personajes(Lado) -->
    {
        personajes(Personajes),
        ( Lado = inicial -> Id = 'lado-inicial' ; Id = 'lado-final' )
    },
    html(ul([id=Id],
        \render_personajes(Personajes, Lado)
    )).

% Renderizado de personajes
render_personajes([], _) --> [].
render_personajes([personaje(Id, Nombre, Tiempo)|T], inicial) -->
    html(li([class='personaje', 'data-id'=Id],
             [ span([class='circle'], ''),
               Nombre, span([class='tiempo'], Tiempo)
             ])),
    render_personajes(T, inicial).
render_personajes(_, final) --> [].

% Tarjeta individual de personaje
personaje_card(Nombre, Imagen, ColorClass, Texto, Tiempo) -->
    html(
        div([class='card'],
            [ h3([class=ColorClass], Nombre),
              img([src=Imagen, alt=Nombre]),
              p([], Texto),
              strong([], Tiempo)
            ])
    ).

% Mostrar los pasos de la solución
mostrar_movimientos([]) --> [].
mostrar_movimientos(['b-->'(A,B)|T]) -->
    {
        format(atom(Txt), '~w y ~w', [A, B])
    },
    html([
        h3([], 'Cruzan por el puente:'),
        h4([], Txt)
    ]),
    mostrar_movimientos(T).
mostrar_movimientos(['<--b'(A)|T]) -->
    {
        format(atom(Txt), '~w', [A])
    },
    html([
        h3([], 'Regresa a buscar un amigo:'),
        h4([], Txt)
    ]),
    mostrar_movimientos(T).

% Ruta a imágenes
format_image_path(FileName, Path) :-
    format(atom(Path), '/assets/~w', [FileName]).

% Personajes con sus tiempos, para armar la interfaz estática
personajes([
    personaje(buzz, 'Buzz', '5 minutos'),
    personaje(woody, 'Woody', '10 minutos'),
    personaje(rex, 'Rex', '20 minutos'),
    personaje(hamm, 'Hamm', '25 minutos')
]).

