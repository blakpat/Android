#!/data/data/com.termux/files/usr/bin/bash
if tmux has-session -t docker-vm 2>/dev/null; then
    echo "Docker VM ya está en ejecución."
else
    echo "Iniciando Docker VM en sesión tmux 'docker-vm'..."
    tmux new-session -d -s docker-vm 'cd ~/alpine && ./startqemu.sh'
    echo "Esperando a que la VM arranque..."
    sleep 15
    echo "Listo."
fi
