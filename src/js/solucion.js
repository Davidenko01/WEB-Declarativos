console.log("solucion.js cargado");

function resolver() {
    fetch('/solucion')
      .then(response => response.text())
      .then(html => {
        document.getElementById('solucion-container').innerHTML = html;
      })
      .catch(err => {
        console.error("Error al obtener la solución:", err);
      });
}

