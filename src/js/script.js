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
  const spanTime = document.getElementById('time');
  const spanLinternaIzq = document.getElementById('linterna-izquierda');
  const spanLinternaDer = document.getElementById('linterna-derecha');
  const btnCruzar = document.getElementById('cruzar');

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
    if (linterna === 'izquierda') {
      if (seleccionados.length === 0) {
        alert('Selecciona 1 o 2 personajes');
        return;
      }
      const tiempoCruce = Math.max(...seleccionados.map(id => tiempos[id]));
      tiempoTotal += tiempoCruce;

      seleccionados.forEach(id => {
        const el = document.querySelector(`#lado-inicial .personaje[data-id="${id}"]`);
        el.classList.remove('seleccionado');
        ulFinal.appendChild(el);
      });

      linterna = 'derecha';
    } else {
      if (seleccionados.length !== 1) {
        alert('Selecciona 1 personaje para cruzar de regreso');
        return;
      }
      const tiempoCruce = tiempos[seleccionados[0]];
      tiempoTotal += tiempoCruce;

      const id = seleccionados[0];
      const el = document.querySelector(`#lado-final .personaje[data-id="${id}"]`);
      el.classList.remove('seleccionado');
      ulInicial.appendChild(el);

      linterna = 'izquierda';
    }

    seleccionados = [];
    bindClicks();
    actualizarUI();

    verificarEstado();
  });

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
        alert('¡HAZ GANADO! Todos cruzaron en ' + tiempoTotal + ' minutos.');
      } else {
        alert('Perdiste, se pasó del tiempo máximo (60 minutos). Tiempo total: ' + tiempoTotal);
      }
    }
  }
});
