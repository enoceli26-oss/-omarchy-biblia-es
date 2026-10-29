#!/usr/bin/env bash
set -euo pipefail
plugin_source="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
plugin_config="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy"
plugin_target="$plugin_config/plugins/local.biblia"
mkdir -p "$plugin_target"
if [[ "$plugin_source" != "$plugin_target" ]]; then
  cp -a "$plugin_source/manifest.json" "$plugin_source/Widget.qml" "$plugin_source/Reader.qml" "$plugin_source/data" "$plugin_source/README.md" "$plugin_target/"
fi
python3 - "$plugin_config/shell.json" <<'PY'
import json, pathlib, shutil, sys, datetime, os
p = pathlib.Path(sys.argv[1])
if not p.exists():
    raise SystemExit('No existe shell.json; configura primero Omarchy Shell.')
d = json.loads(p.read_text())
if d.get('version') != 1:
    raise SystemExit('Versión de shell.json no compatible.')
layout = d.setdefault('bar', {}).setdefault('layout', {})
if not any(e.get('id') == 'local.biblia' for section in layout.values() if isinstance(section, list) for e in section if isinstance(e, dict)):
    backup = str(p) + '.biblia-' + datetime.datetime.now().strftime('%Y%m%d-%H%M%S-%f') + '.bak'
    shutil.copy2(p, backup)
    layout.setdefault('right', []).append({'id': 'local.biblia'})
    temp = p.with_name('shell.json.biblia-tmp')
    temp.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    os.chmod(temp, p.stat().st_mode & 0o777)
    temp.replace(p)
    print('Copia de seguridad:', backup)
PY
if omarchy-shell shell ping >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins
  echo 'Biblia instalada y activada en la barra.'
else
  echo 'Biblia instalada. Aparecerá al iniciar Omarchy Shell en tu sesión gráfica.'
fi
