document.addEventListener('DOMContentLoaded', () => {
  let seleccionados = [];
  let tiempoTotal = 0;
  let linterna = 'izquierda';

  const tiempos = {
    buzz: 5,
    woody: 10,
    rex: 20,
    hamm: 25
  };

  const ulInicial = document.getElementById('lado-inicial');
  const ulFinal = document.getElementById('lado-final');
  const btnCruzar = document.getElementById('cruzar');
  const btnSolAuto = document.getElementById('solAuto');
  const btnReinicio = document.getElementById('reiniciar');
  const spanTime = document.getElementById('time');
  const spanLinternaIzq = document.getElementById('linterna-izquierda');
  const spanLinternaDer = document.getElementById('linterna-derecha');

  function bindClicks() {
    // Limpiar eventos para evitar duplicados
    document.querySelectorAll('.personaje').forEach(el => {
      el.replaceWith(el.cloneNode(true));
    });

    if (linterna === 'izquierda') {
      document.querySelectorAll('#lado-inicial .personaje').forEach(el => {
        el.addEventListener('click', () => toggleSeleccion(el, 2));
      });
    } else {
      document.querySelectorAll('#lado-final .personaje').forEach(el => {
        el.addEventListener('click', () => toggleSeleccion(el, 1));
      });
    }
  }
  bindClicks();

  function toggleSeleccion(el, maxSeleccionados) {
    const id = el.dataset.id;
    if (el.classList.contains('seleccionado')) {
      el.classList.remove('seleccionado');
      seleccionados = seleccionados.filter(x => x !== id);
    } else if (seleccionados.length < maxSeleccionados) {
      el.classList.add('seleccionado');
      seleccionados.push(id);
    } else {
      alert(`Máximo ${maxSeleccionados} personaje(s)`);
    }
  }

  btnCruzar.addEventListener('click', () => {
    if (seleccionados.length === 0 || (linterna === 'izquierda' && seleccionados.length > 2) || (linterna === 'derecha' && seleccionados.length !== 1)) {
      alert('Selección inválida.');
      return;
    }
    cruzarPaso();
  });

  function cruzarPaso() {
    fetch('/validarPaso', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        ladoInicial: Array.from(ulInicial.querySelectorAll('.personaje')).map(el => el.dataset.id),
        ladoFinal: Array.from(ulFinal.querySelectorAll('.personaje')).map(el => el.dataset.id),
        linterna: linterna,
        seleccionados: seleccionados,
        tiempoActual: tiempoTotal
      })
    })
      .then(res => res.json())
      .then(data => {
        if (data.ok) {
          tiempoTotal = data.tiempoNuevo;

          // Actualizar UI con nuevos lados

          actualizarLado(ulInicial, data.nuevoLadoInicial);
          actualizarLado(ulFinal, data.nuevoLadoFinal);

          linterna = linterna === 'izquierda' ? 'derecha' : 'izquierda';
          seleccionados = [];
          bindClicks();
          actualizarUI();
          verificarEstado();

        } else {
          alert('¡PERDISTE!, se agoto el tiempo límite ¡Zurg ha vencido!.');
          reinicio();
        }
      })
      .catch(err => {
        console.error(err);
        alert('Error de validación.');
      });
  }


  function actualizarLado(contenedor, ids) {
    contenedor.innerHTML = '';

    ids.forEach(id => {
      const nuevo = document.createElement('li');
      nuevo.className = 'personaje';
      nuevo.dataset.id = id;

      const circle = document.createElement('span');
      circle.className = 'circle';
      circle.textContent = '';

      const nombre = document.createElement('span');
      nombre.className = 'nombre';
      nombre.textContent = id.charAt(0).toUpperCase() + id.slice(1);

      const tiempo = document.createElement('span');
      tiempo.className = 'tiempo';
      tiempo.textContent = tiempos[id] + ' minutos';

      nuevo.appendChild(circle);
      nuevo.appendChild(nombre);
      nuevo.appendChild(tiempo);

      contenedor.appendChild(nuevo);
    });
  }



  function actualizarUI() {
    spanTime.textContent = tiempoTotal;

    // Mostrar linterna en el lado correcto
    spanLinternaIzq.textContent = linterna === 'izquierda' ? '🔦' : '';
    spanLinternaDer.textContent = linterna === 'derecha' ? '🔦' : '';

    // Cambiar texto del botón según la posición de la linterna
    btnCruzar.textContent = linterna === 'izquierda' ? 'Cruzar a la derecha' : 'Cruzar a la izquierda';
  }


  function verificarEstado() {
    const personajesEnFinal = ulFinal.querySelectorAll('.personaje').length;
    const totalPersonajes = Object.keys(tiempos).length;

    if (personajesEnFinal === totalPersonajes) {
      // Todos cruzaron
      if (tiempoTotal <= 60) {
        alert('¡HAS GANADO! Todos cruzaron en ' + tiempoTotal + ' minutos.');
      } else {
        alert('¡PERDISTE!, se agoto el tiempo límite ¡Zurg ha vencido!.');
      }
    }
  }


  //Manejo de la solución automática utilizando el programa realizado en el TPO1
  btnSolAuto.addEventListener('click', () => {
    resolver();
  });

  function resolver() {
    fetch('/solCarrera')
      .then(response => {
        if (!response.ok) throw new Error("Error al obtener la solución.");
        return response.text();  // Recibe HTML generado por mostrar_movimientos//1
      })
      .then(html => {
        document.getElementById('resultado-solucion').innerHTML = html;
      })
      .catch(error => {
        console.error('Error:', error);
        alert('No se pudo obtener la solución.');
      });
  }


  btnReinicio.addEventListener('click', () => {
    reinicio();
  });


  function reinicio() {
    // Opción fuerte: recarga limpia con sincronización backend
    fetch('/reiniciarJuego', { method: 'POST' })
      .then(res => res.json())
      .then(data => {
        if (data.exito) {
          location.reload(); // recarga total del DOM y del estado JS
        } else {
          alert('No se pudo reiniciar el juego');
        }
      })
      .catch(err => {
        console.error(err);
        alert('Error al reiniciar el juego');
      });
  }

});
