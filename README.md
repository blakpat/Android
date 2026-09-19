# Docker & Containers on Android (Termux / Dex)

Ejecución de Docker, Portainer y Grafana en dispositivos Android (Samsung DeX, tablets y móviles) sin necesidad de acceso root.

---

## 🏗 Arquitectura

Debido a que el kernel de Android no expone cgroups ni soporte nativo de contenedores para usuarios no-root:

1. **Termux (Host Android ARM64):** Gestiona la emulación y herramientas CLI.
2. **QEMU (Emulador x86_64 TCG):** Proporciona una máquina virtual ligera con 2 cores y 2 GB RAM.
3. **Alpine Linux v3.22 (Guest x86_64):** Sistema operativo invitado optimizado, seguro y con mínimo consumo de RAM.
4. **Docker Daemon (dockerd):** Ejecuta contenedores estándar compatibles con arquitectura x86_64 (amd64).
5. **Wrappers CLI:** Permite usar docker y docker-compose directamente desde la terminal de Termux de forma transparente mediante SSH interno.

---

## 🚀 Requisitos Previos

- Dispositivo Android con arquitectura arch64 (mínimo 4 GB RAM recomendado).
- [Termux](https://github.com/termux/termux-app/releases) instalado desde F-Droid o GitHub.
- Mínimo 10 GB de almacenamiento libre.

---

## 📦 Instalación Rápida

1. Clona este repositorio dentro de Termux:
   `ash
   git clone https://github.com/blakpat/Android.git ~/docker-android
   cd ~/docker-android
   `

2. Ejecuta el asistente de instalación:
   `ash
   chmod +x *.sh bin/*
   ./termux-setup.sh
   ./install.sh
   `

3. Instala los wrappers en el PATH de Termux:
   `ash
   cp bin/* /bin/
   chmod +x /bin/docker*
   `

4. Añade los alias a tu ~/.bashrc:
   `ash
   cat << 'EOF' >> ~/.bashrc
   alias dstart='docker-start.sh'
   alias dstop='docker-stop.sh'
   alias dconsole='docker-console.sh'
   alias dstatus='docker ps'
   EOF
   source ~/.bashrc
   `

---

## 🛠 Comandos de Control

| Comando / Alias | Descripción |
|---|---|
| dstart | Inicia la máquina virtual Docker en segundo plano (sesión tmux docker-vm). |
| dstop | Apaga limpiamente la VM y el daemon de Docker. |
| dconsole | Abre la consola interactiva de la máquina virtual (Alpine). |
| dstatus | Muestra los contenedores en ejecución (docker ps). |
| docker ... | Ejecuta cualquier comando Docker estándar transparente desde Termux. |
| docker-compose ... | Ejecuta docker-compose sobre la VM. |

---

## 🌐 Servicios Preconfigurados y Puertos

Los puertos están redirigidos automáticamente entre la VM y el navegador de la tablet:

- **Portainer CE:** http://localhost:9000
- **Grafana OSS:** http://localhost:3000 (Usuario: dmin, Password: dmin)
- **Puertos de desarrollo:** 8000, 8080
- **SSH Interno VM:** localhost:2222

---

## 📊 Ejemplo: Levantar Grafana con Persistencia

`ash
docker run -d \
  -p 3000:3000 \
  --name=grafana \
  --restart=always \
  -v grafana-storage:/var/lib/grafana \
  -e GF_SECURITY_ADMIN_USER=admin \
  -e GF_SECURITY_ADMIN_PASSWORD=admin \
  -e GF_USERS_ALLOW_SIGN_UP=false \
  grafana/grafana-oss:latest
`

---

## 🔒 Seguridad

- Acceso por clave privada SSH dedicada (qemukey) restringida a localhost:2222.
- El disco virtual (lpine.img) y las claves privadas no deben subirse a repositorios públicos (.gitignore preconfigurado).

---

## 📄 Licencia

MIT License.
