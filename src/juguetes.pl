:- module(juguetes, [movesJuguetes/1]).
:- use_module(library(clpfd)).


%%Tiempo que tarda cada juguete
tiempo(buzz, 5).
tiempo(woody,  10).
tiempo(rex,  20).
tiempo(hamm,  25).

%%Programa principal
movesJuguetes(Ms) :-
   length(Ms,_),phrase(moveJuguete(state([buzz,woody,rex,hamm],[]),0,60),Ms).

moveJuguete(state(Ls0,Rs0),TiempoActual,TiempoFinal) -->
     {
 	select(N1,Ls0,Ls1),select(N2,Ls1,Ls2), %%Selecciona dos juguetes
      N1 @< N2, %%Verifica que sean distintos
 	tiempo(N1,W1),tiempo(N2,W2), %%Obtiene sus tiempos
      S #= max(W1, W2), %%Toma el máximo tiempo entre los dos
      S #=< TiempoFinal, %%Verifica que no se pasen de 60 segundos
      NuevoTiempo #= TiempoActual + S %%Acumula los tiempos
     },
    ['b-->'(N1,N2)],
    moveJuguetes_(state(Ls2,[N1,N2|Rs0]), NuevoTiempo, TiempoFinal).

%%Método para la vuelta de un juguete
moveJuguetes_(state([], _), TiempoActual, TiempoMax) -->
    {
        TiempoActual #=< TiempoMax %%Verifica que no se pasen del tiempo
    },
    [].

moveJuguetes_(state(Ls0,Rs0),TiempoActual, TiempoFinal) -->
     {
	   select(N,Rs0,Rs1), %%Obtiene el tiempo del juguete con menor tiempo
         tiempo(N,W),
         NuevoTiempo #= W + TiempoActual, %%Acumula los tiempos
         NuevoTiempo #=< TiempoFinal %%Verifica que no se hayan pasado del tiempo
     },
	     ['<--b'(N)],
	     moveJuguete(state([N|Ls0],Rs1),NuevoTiempo, TiempoFinal).