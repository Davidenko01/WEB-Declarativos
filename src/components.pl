:- module(components, [pagina_inicio//0, pagina_carrera//0, personaje_card//5]).

:- use_module(library(http/html_write)).
:- use_module(juguetes).

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
                'ESCAPA DE ZURG! CUIDADO, EL PUENTE ES OSCURO Y MUY DEBIL'),
              h2([class='subtitle'], 'JUGUETES DE ANDY:'),
              div([class='characters-container'],
                  [ 
                    \personaje_card('woody', WoodyPath, 'woody-color', 'EL SHERIFF', '10 minutos'),
                    \personaje_card('buzz', BuzzPath, 'buzz-color', 'EL GUARDIAN DEL ESPACIO', '5 minutos'),
                    \personaje_card('hamm', HammPath, 'hamm-color', 'ALGO ANDA MAL...', '25 minutos'),
                    \personaje_card('rex', RexPath, 'rex-color', 'EL T-REX', '20 minutos')
                  ]),
              div([style='margin-top: 45px;'],
                  a([href='/carrera', class='button'],
                    'JUGAR'))
            ])
    ).

pagina_carrera -->
    {
        movesJuguetes(Movimientos)
    },
    html(
        div([class='container'],
            [ h1([class='title'], 'Problema del Cruce del Puente'),
              div([class='controls'], [
                  p([class='timer'], [
                      'Tiempo usado: ', span([class='green'], '0'), '/60 minutos'
                  ]),
                  div([class='buttons'], [
                      button([class='button'], 'Solucion automática'),
                      button([class='button'], 'Reiniciar')
                  ])
              ]),
              div([class='bridge-layout'], [
                  div([class='lado-inicial'], [
                      h3([], ['Lado Inicial ', span([class='linterna'], '🔦')]),
                      \personaje_card('buzz', '/assets/buzz.png', 'circle', 'Buzz', '5 minutos'),
                      \personaje_card('woody', '/assets/woody.png', 'circle', 'Woody', '10 minutos'),
                      \personaje_card('rex', '/assets/rex.png', 'circle', 'Rex', '20 minutos'),
                      \personaje_card('hamm', '/assets/hamm.png', 'circle', 'Hamm', '25 minutos')
                  ]),

                  div([class='puente'], [
                      div([class='puente-img'], 'PUENTE'),
                      div([class='accion-boton'], [
                          button([class='button'], 'Cruzar hacia la derecha →'),
                          p([class='seleccion'], 'Selecciona 1 o 2 personajes para cruzar')
                      ])
                  ]),

                  div([class='lado-final'], [
                      h3([], 'Lado Final'),
                      p([], 'No hay personajes en este lado')
                  ])
              ])
            ])
    ).


format_image_path(FileName, Path) :-
    format(atom(Path), '/assets/~w', [FileName]).

personaje_card(Nombre, Imagen, ColorClass, Texto, Tiempo) -->
    html(
        div([class='card'],
            [ h3([class=ColorClass], Nombre),
              img([src=Imagen, alt=Nombre]),
              p(Texto),
              strong(Tiempo)
            ]
        )
    ).