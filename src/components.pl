:- module(components, [pagina_inicio//0, pagina_carrera//0, personaje_card//5, mostrar_movimientos//1]).

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
            [ h1([class='title'], 'ESCAPA POR EL PUENTE!'),
              p([class='description'],
                  'ESCAPA DE ZURG! CUIDADO, EL PUENTE ES OSCURO Y MUY DEBIL'),
               h2([class='subtitle'], 'SOLUCION PARA NUESTROS AMIGOS:'),
               \mostrar_movimientos(Movimientos)
            ])
    ).  


mostrar_movimientos([]) --> [].

mostrar_movimientos(['b-->'(A,B)|T]) -->
    {
        format(atom(Txt), '~w y ~w', [A, B])
    },
    html([
        h3('Cruzan por el puente:'),
        h4(Txt)
    ]),
    mostrar_movimientos(T).

mostrar_movimientos(['<--b'(A)|T]) -->
    {
        format(atom(Txt), '~w', [A])
    },
    html([
        h3('Regresa a buscar un amigo:'),
        h4(Txt)
    ]),
    mostrar_movimientos(T).




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