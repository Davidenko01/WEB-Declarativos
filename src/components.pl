:- module(components, [pagina_inicio//0, personaje_card//5]).

:- use_module(library(http/html_write)).

pagina_inicio -->
    {
        maplist(format_image_path, 
                ['buzz.png','woody.png','rex.png','hamm.png'],
                [BuzzPath, WoodyPath, RexPath, HammPath])
    },
    html(
        div([class='container'],
            [ h1([class='title'], '¡ESCAPA POR EL PUENTE!'),
              p([class='description'],
                'ESCAPA DE ZURG! CUIDADO! EL PUENTE ES OSCURO Y MUY DEBIL'),
              h2([class='subtitle'], 'JUGUETES DE ANDY:'),
              div([class='characters-container'],
                  [ 
                    \personaje_card('Woody', WoodyPath, 'woody-color', 'EL SHERIFF', '10 minutos'),
                    \personaje_card('Buzz', BuzzPath, 'buzz-color', 'EL GUARDIAN DEL ESPACIO', '5 minutos'),
                    \personaje_card('Hamm', HammPath, 'hamm-color', 'ALGO ANDA MAL...', '25 minutos'),
                    \personaje_card('Rex', RexPath, 'rex-color', 'EL T-REX', '20 minutos')
                  ]),
              div([style='margin-top: 45px;'],
                  a([href='/html/reglas.html', class='button'],
                    '¡JUGAR!'))
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