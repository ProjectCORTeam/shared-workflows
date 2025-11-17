# shared-workflows

## Configuración de GitHub Token

Para usar los comandos de la API de GitHub, configura tu token como variable de entorno:

### Configuración del Token

1. **Crear un Personal Access Token en GitHub:**
   - Ve a: https://github.com/settings/tokens
   - Click en "Generate new token (classic)"
   - Selecciona los siguientes scopes:
     - `repo` (acceso completo a repositorios)
     - `read:org` (lectura de organización)
     - `admin:org` (si necesitas administrar la organización)
     - `workflow` (para gestionar workflows)

2. **Configurar variable de entorno:**

```bash
# En tu ~/.zshrc o ~/.bashrc (para persistencia)
export GITHUB_TOKEN="tu_token_aqui"

# O solo para la sesión actual
export GITHUB_TOKEN="tu_token_aqui"
```

3. **Usar el token en comandos curl:**

```bash
curl -L \
  -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/repos/ProjectCORTeam/Notifications/actions/runners/registration-token
```

### Ejemplos de uso

#### Obtener token de registro de runner:
```bash
curl -L \
  -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/repos/ProjectCORTeam/Notifications/actions/runners/registration-token
```

#### Obtener downloads de runners (organización):
```bash
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/ProjectCORTeam/actions/runners/downloads
```

### Testing de Token de Organización

Para probar si tu token funciona con recursos de organización:

```bash
# 1. Probar acceso básico a organización
curl -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/orgs/ProjectCORTeam

# 2. Probar creación de registration token (lo que necesita ARC en K8s)
curl -X POST \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/orgs/ProjectCORTeam/actions/runners/registration-token

# 3. Verificar permisos del token
curl -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/user
```

### GitHub Actions Runner Controller (ARC) en Kubernetes

Para ARC en Kubernetes, necesitas:

1. **GitHub App (Recomendado):**
   - Crear una GitHub App en la organización
   - Instalar la app en la organización
   - Usar el App ID y Private Key en ARC

2. **PAT con permisos de organización:**
   - El token debe tener `admin:org` scope
   - O permisos específicos de organización aprobados por un owner
   - Algunos PATs pueden no funcionar aunque tengan los permisos (limitación de GitHub)

### Seguridad

⚠️ **NUNCA** subas el token a git o lo expongas en código público.
- Usa variables de entorno
- Agrega `.env` al `.gitignore` si creas archivos de configuración
- Revoca tokens expuestos inmediatamente
