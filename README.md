# Biblia en español para Omarchy

Complemento de barra `io.github.enoceli26-oss.biblia-es` para Omarchy Shell (Quickshell).

- Biblia completa en español, Reina-Valera 1909: 66 libros y 31 102 versículos.
- Lectura sin conexión, selector de libro y capítulo, navegación anterior/siguiente.
- Búsqueda sin distinguir tildes ni mayúsculas (mínimo 3 caracteres; máximo 200 resultados).
- Versículo del día según la fecha local. Pulsa su referencia para abrir el capítulo.
- Tamaño de letra ajustable y texto seleccionable para copiar con Ctrl+C.
- Colores del tema de Omarchy. Esc o clic fuera para cerrar.

## Instalar

Ejecuta `./install.sh` desde esta carpeta. Necesita Python 3 y Omarchy Shell.
Copia el complemento a `${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins/io.github.enoceli26-oss.biblia-es`
y añade una entrada a la derecha de la barra conservando el resto de la configuración.
Antes de modificar shell.json crea una copia con fecha. Se puede ejecutar de nuevo sin duplicar el botón.
El instalador no necesita sudo. Si no hay una sesión de Omarchy Shell activa, se cargará en el siguiente inicio.

Para desactivarlo: `omarchy plugin disable io.github.enoceli26-oss.biblia-es`.

## Texto y atribución

Texto Reina-Valera 1909, de dominio público, obtenido de scrollmapper/bible_databases.
La fuente y la conversión están documentadas en `data/SOURCE.md`.
Licencia del código: MIT (archivo `LICENSE`). Licencia de la fuente: `data/LICENSE`.

## Instalación desde GitHub

```bash
omarchy plugin add https://github.com/enoceli26-oss/-omarchy-biblia-es.git --enable
```
