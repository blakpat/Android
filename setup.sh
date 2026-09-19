#!/data/data/com.termux/files/usr/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== 1. Instalando dependencias de sistema en Termux ==="
pkg update -y
pkg install -y expect curl qemu-utils qemu-common qemu-system-x86_64-headless openssh tmux

echo "=== 2. Preparando archivos del instalador ==="
cd "$PROJECT_DIR/installer"

if [ ! -f "config.env" ]; then
    cp config.sample config.env
fi

echo "=== 3. Instalando Alpine Linux x86_64 en QEMU ==="
expect -f installqemu.expect

# Asegurar puertos mapeados en ~/alpine/startqemu.sh
cp "$PROJECT_DIR/vm/startqemu.sh" ~/alpine/startqemu.sh
chmod +x ~/alpine/startqemu.sh

echo "=== 4. Instalando wrappers y comandos en Termux ($PREFIX/bin) ==="
mkdir -p "$PREFIX/bin"
cp "$PROJECT_DIR/bin/"* "$PREFIX/bin/"
chmod +x "$PREFIX/bin/docker"*

echo "=== 5. Configurando alias en ~/.bashrc ==="
if ! grep -q "alias dstart=" ~/.bashrc 2>/dev/null; then
    cat << 'EOF' >> ~/.bashrc

# Docker VM Aliases
alias dstart='docker-start.sh'
alias dstop='docker-stop.sh'
alias dconsole='docker-console.sh'
alias dstatus='docker ps'
EOF
fi

echo ""
echo "=========================================================="
echo "  Instalacion finalizada con exito!"
echo "=========================================================="
echo "Comandos disponibles:"
echo "  dstart    -> Iniciar VM Docker en segundo plano (tmux)"
echo "  dstatus   -> Ver contenedores (docker ps)"
echo "  dconsole  -> Consola directa de la VM Alpine"
echo "  dstop     -> Apagar la VM limpiamente"
echo "  docker    -> Wrapper CLI transparente"
echo "=========================================================="
