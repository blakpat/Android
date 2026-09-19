# 🐳 Docker on Android (Termux / Samsung DeX)

Entorno completo y automatizado para ejecutar Docker, Portainer y Grafana sobre dispositivos Android (ARM64) sin necesidad de acceso root.

---

## Arquitectura del Sistema

El kernel estándar de Android para usuarios no-root no provee soporte nativo para `cgroups` ni namespaces completos requeridos por Docker. Este proyecto implementa una arquitectura multicapa altamente optimizada:

```
+-------------------------------------------------------------+
|                     Android (ARM64)                         |
|  +-------------------------------------------------------+  |
|  |             Termux (Host CLI & Wrappers)              |  |
|  |  +-------------------------------------------------+  |  |
|  |  |           QEMU v10 (x86_64 TCG Engine)          |  |  |
|  |  |  +-------------------------------------------+  |  |  |
|  |  |  |      Alpine Linux v3.22 (Guest OS)        |  |  |  |
|  |  |  |  +-------------------------------------+  |  |  |  |
|  |  |  |  |         Docker Daemon (dockerd)     |  |  |  |  |
|  |  |  |  |  +-------------------------------+  |  |  |  |  |
|  |  |  |  |  | Portainer (:9000)             |  |  |  |  |  |
|  |  |  |  |  | Grafana (:3000) + Persistence |  |  |  |  |  |
|  |  |  |  |  +-------------------------------+  |  |  |  |  |
|  +--+--+--+----------------------------------+--+--+--+--+  |
+-------------------------------------------------------------+
```

---

## 📂 Estructura del Proyecto

```text
Android/
├── bin/                    # Wrappers CLI transparentes para Termux
│   ├── docker              # Wrapper 'docker' hacia la VM
│   ├── docker-compose      # Wrapper 'docker-compose'
│   ├── docker-start.sh     # Inicio en segundo plano (tmux)
│   ├── docker-stop.sh      # Apagado limpio y seguro
│   └── docker-console.sh   # Consola interactiva
├── installer/              # Aprovisionamiento y scripts de instalacion
│   ├── answerfile          # Automatizacion para setup-alpine
│   ├── config.sample       # Parametros configurables (RAM, disco, ISO)
│   ├── debug-install.sh    # Modo depuracion
│   ├── install.sh          # Ejecutor de instalacion
│   ├── installqemu.expect  # Script expect para automatizar teclado
│   └── termux-setup.sh     # Script rapido 1-line
├── vm/                     # Configuracion de la maquina virtual
│   ├── startqemu.sh        # Comando de arranque QEMU con reenvio de puertos
│   └── ssh2qemu.sh         # Conexion SSH directa
├── setup.sh                # Instalador principal 1-click
├── .gitignore              # Proteccion contra fugas de claves o imagenes
├── LICENSE                 # Licencia MIT
└── README.md               # Documentacion completa
```

---

##  Instalacion Rapida en Termux

En la app Termux de tu tablet o telefono:

```bash
pkg update -y && pkg install -y git
git clone https://github.com/blakpat/Android.git ~/docker-android
cd ~/docker-android/docker-on-dex
chmod +x setup.sh bin/* installer/*.sh vm/*.sh
./setup.sh
```

---

## Comandos de Control

Una vez instalado, reinicia Termux o ejecuta `source ~/.bashrc`. Dispones de los siguientes alias:

| Comando | Descripcion |
|---|---|
| `dstart` | Enciende la maquina virtual Docker en segundo plano (tmux: `docker-vm`). |
| `dstatus` | Muestra los contenedores corriendo (`docker ps`). |
| `dconsole` | Abre la sesion directa de la maquina virtual Alpine. |
| `dstop` | Apaga limpiamente la VM y el daemon Docker. |
| `docker <cmd>` | Ejecuta comandos nativos de Docker de forma transparente. |
| `docker-compose` | Ejecuta docker-compose dentro del guest. |

---

## Servicios y Mapeo de Puertos

Todos los puertos de la VM estan redirigidos a `localhost` en el navegador de Android:

- **Portainer CE:** `http://localhost:9000`
- **Grafana OSS:** `http://localhost:3000` (Login inicial: `admin` / `admin`)
- **Puertos de desarrollo:** `8000`, `8080`
- **SSH Guest Interno:** `localhost:2222`

---

## Despliegue de Grafana con Persistencia

Para levantar Grafana con volumen persistente y plugins de monitoreo:

```bash
docker run -d \
  -p 3000:3000 \
  --name=grafana \
  --restart=always \
  -v grafana-storage:/var/lib/grafana \
  -e GF_SECURITY_ADMIN_USER=admin \
  -e GF_SECURITY_ADMIN_PASSWORD=admin \
  -e GF_USERS_ALLOW_SIGN_UP=false \
  -e GF_INSTALL_PLUGINS=grafana-clock-panel,marcusolsson-json-datasource,redis-datasource \
  grafana/grafana-oss:latest
```

---

## Seguridad y Buenas Practicas

- **Sin elevacion Root:** No altera particiones del sistema Android ni compromete el dispositivo.
- **Aislamiento por clave SSH:** Solo conexiones locales mediante clave privada efimera (`qemukey`).
- **Seguridad en Git:** `.gitignore` preconfigurado para evitar subir claves privadas o volumenes de datos.

---

## Licencia

Este proyecto esta bajo la Licencia MIT.
