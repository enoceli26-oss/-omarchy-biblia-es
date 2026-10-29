# Biblia en español para Omarchy

Complemento de barra `local.biblia` para Omarchy Shell (Quickshell).

- Biblia completa en español, Reina-Valera 1960: 66 libros y 31 104 versículos.
- Lectura sin conexión, selector de libro y capítulo, navegación anterior/siguiente.
- Búsqueda sin distinguir tildes ni mayúsculas (mínimo 3 caracteres; máximo 200 resultados).
- Versículo del día según la fecha local. Pulsa su referencia para abrir el capítulo.
- Tamaño de letra ajustable y texto seleccionable para copiar con Ctrl+C.
- Colores del tema de Omarchy. Esc o clic fuera para cerrar.

## Instalar

Ejecuta `./install.sh` desde esta carpeta. Necesita Python 3 y Omarchy Shell.
Copia el complemento a `${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/local.biblia`
y añade una entrada a la derecha de la barra conservando el resto de la configuración.
Antes de modificar shell.json crea una copia con fecha. Se puede ejecutar de nuevo sin duplicar el botón.
El instalador no necesita sudo. Si no hay una sesión de Omarchy Shell activa, se cargará en el siguiente inicio.

Para desactivarlo: `omarchy plugin disable local.biblia`.

## Texto y atribución

Datos: https://github.com/thiagobodruk/bible/blob/master/json/es_rvr1960.json
Descargados el 2026-10-28. Se conserva el archivo original sin modificar.
Licencia del repositorio en `data/LICENSE`. Los derechos de la traducción pertenecen a sus respectivos titulares, como indica la fuente.
El complemento no necesita red durante su uso, no usa claves API y no envía búsquedas a servidores.
